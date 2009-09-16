Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbZIPHIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbZIPHIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbZIPHIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:08:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55058 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZIPHII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:08:08 -0400
Message-ID: <4AB08E8D.3050102@cn.fujitsu.com>
Date: Wed, 16 Sep 2009 15:06:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Paulo Marques <pmarques@grupopie.com>
Subject: Re: [PATCH] kallsyms: Fix segfault in prefix_underscores_count().
References: <20090916050845.GA5805@linux-sh.org> <4AB085A6.8000605@cn.fujitsu.com> <20090916064840.GC5805@linux-sh.org>
In-Reply-To: <20090916064840.GC5805@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> But..as the name "prefix_underscores_count" suggests, shouldn't
>> it be:
>> 	while (*tail == '_')
>> 		tail++;
>> ??
>>
> Yes, that was what I did initially as well, but the behaviour is not
> exactly the same, and I wanted an explanation from Lai if there were some
> other intentions for the code. In any event, simplifying it still manages
> to do the right thing, so I'm fine with that.
> 

I know what happened.

Lai sent this patch:
	http://lkml.org/lkml/2009/3/13/72

And he himself found the bug, and fixed it and resent it:
	http://lkml.org/lkml/2009/3/13/156

But Andrew mistakenly picked up the former one.

> ------------------------
> Subject: [PATCH] kallsyms: Fix segfault in prefix_underscores_count().
> 
> Commit b478b782e110fdb4135caa3062b6d687e989d994 "kallsyms, tracing:
> output more proper symbol name" introduces a "bugfix" that introduces
> a segfault in kallsyms in my configurations.
> 
> The cause is the introduction of prefix_underscores_count() which
> attempts to count underscores, even in symbols that do not have them.
> As a result, it just uselessly runs past the end of the buffer until it
> crashes:
> 
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
>   KSYM    .tmp_kallsyms1.S
> /bin/sh: line 1: 16934 Done                    sh-linux-gnu-nm -n .tmp_vmlinux1
>      16935 Segmentation fault      | scripts/kallsyms > .tmp_kallsyms1.S
> make: *** [.tmp_kallsyms1.S] Error 139
> 
> This simplifies the logic and just does a straightforward count.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
