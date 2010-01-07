Return-Path: <linux-kernel-owner+w=401wt.eu-S932398Ab0AGDFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0AGDFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932349Ab0AGDFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:05:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64794 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932334Ab0AGDFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:05:02 -0500
Message-ID: <4B454F59.1030503@cn.fujitsu.com>
Date: Thu, 07 Jan 2010 11:04:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "menage@google.com" <menage@google.com>,
       kirill@shutemov.name
Subject: Re: mmotm 2010-01-06-14-34 uploaded (kernel/cgroup)
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>	<20100106170849.d0d95c9b.randy.dunlap@oracle.com>	<20100107113154.a1fa0103.kamezawa.hiroyu@jp.fujitsu.com>	<4B4549CB.8000809@cn.fujitsu.com> <20100107114728.58166ce4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107114728.58166ce4.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> It contains the following patches against 2.6.33-rc3:
>>>> kernel/cgroup.c: In function 'cgroup_write_event_control':
>>>> kernel/cgroup.c:2949: error: implicit declaration of function 'eventfd_fget'
>>>> kernel/cgroup.c:2949: warning: assignment makes pointer from integer without a cast
>>>> kernel/cgroup.c:2955: error: implicit declaration of function 'eventfd_ctx_fileget'
>>>> kernel/cgroup.c:2955: warning: assignment makes pointer from integer without a cast
>>>> make[2]: *** [kernel/cgroup.o] Error 1
>>>>
>>> Hmm, how about this rather than adding #ifdefs..
>>> Paul, Li, how do you think ?
>> I think make CONFIG_CGROUPS select EVENTFD would be better.
>>
> Hm, as far as I know, SELECT is not recommended. But yes, it seems side-effect
> of select is small here. But I avoid it as much as possible, usually.
> 
> Moreover, in this case,
>   - EVENTFD is a feature which is enabled by default.
>   - cgroup is "Say N if unsure" config.
> 
> In this case, "depends on" is good.
> 

I thought we use "depends on" if it's obvious by the config name
that a config depends on another config, and use "select" otherwise.

Referring to Documentation/Kbuild/kconfig-language.txt:

        select should be used with care.
        ...
        In general use select only for non-visible symbols
        (no prompts anywhere) and for symbols with no dependencies.

It does suggest "depends on" is better. :)

