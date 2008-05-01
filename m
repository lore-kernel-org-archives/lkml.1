Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbYEALfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbYEALfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 07:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbYEALfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 07:35:36 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53554 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756147AbYEALff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 07:35:35 -0400
Message-ID: <4819AB03.3030808@sgi.com>
Date: Thu, 01 May 2008 04:35:31 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
CC: sfr@canb.auug.org.au, Ingo Molnar <mingo@elte.hu>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: x86_64 does not boot in Qemu
References: <48191E75.70305@gmail.com>
In-Reply-To: <48191E75.70305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitri,

There are 3 "fix" patches after this one (sorry about that).

	http://marc.info/?l=linux-kernel&m=120941725114635&w=4
	http://marc.info/?l=linux-kernel&m=120949583029044&w=4
	http://marc.info/?l=linux-kernel&m=120956778620842&w=4

Checking out the "latest" sched/latest it appears though that the
entire patchset has been removed.  I'll wait for Ingo's feedback
on what's up.

I will also try out your example test.

Thanks,
Mike

Dmitri Vorobiev wrote:
> Hi Stephen, Mike, Ingo,
> 
> Starting from
> 
> 
> [dmitri.vorobiev@amber linux-2.6]$ git bisect good
> 66c38e394e8c178c806266bb213f1087cd182701 is first bad commit
> commit 66c38e394e8c178c806266bb213f1087cd182701
> Author: Mike Travis <travis@sgi.com>
> Date:   Mon Apr 28 14:09:07 2008 -0700
> 
>     x86: remove static boot_cpu_pda array v2
> 
>       * Remove the boot_cpu_pda array and pointer table from the data section.
>         Allocate the pointer table and array during init.  do_boot_cpu()
>         will reallocate the pda in node local memory and if the cpu is being
>         brought up before the bootmem array is released (after_bootmem = 0),
>         then it will free the initial pda.  This will happen for all cpus
>         present at system startup.
> 
>         This removes 512k + 32k bytes from the data section.
> 
>     For inclusion into sched-devel/latest tree.
> 
>     Based on:
>         git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>         +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git
> 
>     Signed-off-by: Mike Travis <travis@sgi.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> <<<<
> 
> the x86_64 kernel stopped booting for me. The symptom is that no output
> whatsoever is produced after the following command:
> 
> 
> qemu-0.9.1/bin/qemu-system-x86_64 image_64.raw \
>         -kernel src/linux-2.6/arch/x86/boot/bzImage \
>         -append "console=ttyS0 root=/dev/hda1 ro" -nographic \
>         -redir tcp:2222::22 -m 512
> 
> <<<<
> 
> Qemu just hangs seemingly doing nothing. Normally, the usual boot log is
> displayed.
> 
> Bisection on linux-next leads to the commit given above. Config attached.
> 
> Thanks,
> Dmitri
> 

