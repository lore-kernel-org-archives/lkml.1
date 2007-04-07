Return-Path: <linux-kernel-owner+w=401wt.eu-S966231AbXDGSKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966231AbXDGSKJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 14:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966236AbXDGSKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 14:10:09 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:15914 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966231AbXDGSKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 14:10:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=nfDClX98ZIsWsWXUrxRmfovfvCHfw9PbDw1MvLjuWSKUUE+0LtiufvZpaDG7qXoiIuvbAKDRYWGrbtJuoOXHSApul+5JxDU5wRy1bvWZlevV4Qmx2UPVJ6uqoVbbAMEbxWUkyJFXNchnC/JtajKT7Vt5/ZZR2MHuMF7qgOgcVnU=
Message-ID: <4617DE67.4090801@googlemail.com>
Date: Sat, 07 Apr 2007 20:09:43 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
Subject: Re: mm snapshot broken-out-2007-04-07-03-27.tar.gz uploaded
References: <200704071029.l37ATdKR032505@shell0.pdx.osdl.net>	<46178ECC.2030107@googlemail.com> <20070407105328.836902d1.akpm@linux-foundation.org>
In-Reply-To: <20070407105328.836902d1.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> On Sat, 07 Apr 2007 14:30:04 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
>> akpm@linux-foundation.org napisał(a):
>>> The mm snapshot broken-out-2007-04-07-03-27.tar.gz has been uploaded to
>>>
>>>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-07-03-27.tar.gz
>>>
>>> It contains the following patches against 2.6.21-rc6:
>>>
>> LTP triggered a ptrace problem.
>>
>> ------------[ cut here ]------------
>> kernel BUG at kernel/ptrace.c:1281!
> 
> umm, Roland, if you're going to add assertions which only function with
> CONFIG_PREEMPT enabled, you'd better test with CONFIG_PREEMPT enabled ;)
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> We hold read_lock(tasklist_lock) in here.
> 
> Cc: Roland McGrath <roland@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/ptrace.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff -puN kernel/ptrace.c~utrace-fix-bug kernel/ptrace.c
> --- a/kernel/ptrace.c~utrace-fix-bug
> +++ a/kernel/ptrace.c
> @@ -1278,8 +1278,6 @@ found:
>  		 current->pid, tsk->pid, p->pid, exit_code,
>  		 p->exit_state, p->exit_signal);
>  
> -	NO_LOCKS;
> -
>  	/*
>  	 * If there was a group exit in progress, all threads report that
>  	 * status.  Most will have SIGKILL in their own exit_code.
> _
> 
> 
> 

Thanks.

BTW. I guess that this need a similar fix.

kernel BUG at kernel/ptrace.c:494!
invalid opcode: 0000 [#2]
PREEMPT SMP 
last sysfs file: devices/platform/w83627hf.656/temp2_input
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss intel_agp snd_pcm agpgart evdev snd_timer snd soundcore i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
CPU:    1
EIP:    0060:[<c0163f22>]    Not tainted VLI
EFLAGS: 00010202   (2.6.21-rc6-mm1 #1)
EIP is at ptrace_exit+0x29/0x21d

l *0xc0163f22
0xc0163f22 is in ptrace_exit (kernel/ptrace.c:494).
489     ptrace_exit(struct task_struct *tsk)
490     {
491             struct list_head *pos, *n;
492             int restart;
493
494             NO_LOCKS;
495
496             /*
497              * Taking the task_lock after PF_EXITING is set ensures that a
498              * child in ptrace_traceme will not put itself on our list when

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
