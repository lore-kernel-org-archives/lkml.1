Return-Path: <linux-kernel-owner+w=401wt.eu-S934395AbZIDW0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395AbZIDW0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 18:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934364AbZIDW0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 18:26:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934292AbZIDW0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 18:26:18 -0400
Message-ID: <4AA194CE.30200@redhat.com>
Date: Fri, 04 Sep 2009 18:29:34 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip tracing/kprobes 3/6] kprobes/x86: Fix to add	__kprobes
 to in-kernel fault handing functions
References: <20090827152539.GE6058@nowhere> <20090827172311.8246.92725.stgit@localhost.localdomain> <20090830005355.GB387@nowhere> <4A99E8CB.1040600@redhat.com> <20090830160939.GA6131@nowhere> <4A9E6BDD.6090705@redhat.com> <20090904190651.GC6118@nowhere>
In-Reply-To: <20090904190651.GC6118@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Wed, Sep 02, 2009 at 08:58:05AM -0400, Masami Hiramatsu wrote:
>> Frederic Weisbecker wrote:
>>> BTW, after your patchset:
>>>
>>> TEST    posttest
>>>    Building modules, stage 2.
>>> Error: c0101038:	2e a1 f8 b0 9e c0    	mov    %cs:0xc09eb0f8,%eax
>>> Error: objdump says 6 bytes, but insn_get_length() says 10 (attr:40000)
>>> make[1]: *** [posttest] Erreur 2
>>> make: *** [bzImage] Erreur 2
>>> make: *** Attente des tâches non terminées....
>>>    MODPOST 4 modules
>>>
>>>
>>> I'm cross compiling from 64 to 32 using:
>>>
>>> make ARCH=x86
>>>
>>> I've attached my config.
>>
>> Aah, you might miss an important patch :D
>> http://lkml.org/lkml/2009/8/28/367
>>
>> Thank you,
>>
>
>
> Well, even with this patch I have this problem occuring with
> make ARCH=x86
>
> Error: c125d65d:	0f 6f 02             	movq   (%edx),%mm0
> Error: objdump says 3 bytes, but insn_get_length() says 2 (attr:0)
> make[1]: *** [posttest] Erreur 2
> make: *** [bzImage] Erreur 2
>
> Hmm, may be that's because it doesn't support mmx instructions.
> The whole patchset is on
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/kprobes
>
> Config and make V=1 log attached.

Aah, Indeed. It's time to add MMX/SSE support on x86 insn decoder.

Thank you for reporting!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

