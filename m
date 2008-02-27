Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYB0P3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYB0P3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYB0P25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:28:57 -0500
Received: from sacred.ru ([62.205.161.221]:33689 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbYB0P25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:28:57 -0500
Message-ID: <47C581AD.60603@openvz.org>
Date: Wed, 27 Feb 2008 18:28:45 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.25-rc3 regression] sysctl table check failed: /kernel/vsyscall64
References: <200802271609.48450.elendil@planet.nl>
In-Reply-To: <200802271609.48450.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 27 Feb 2008 18:28:38 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Just tried 2.6.25-rc3 and got the error below. Boot continued normally.
> Error was not present in rc2.
> 
> System is x86_64, dual core Pentium D, Debian unstable.
> 
> Cheers,
> FJP
> 
> P.S. Yes, I do have VirtualBox working under 2.6.25 now ;-)

That's due to commit ce28b9 x86: fix vsyscall wreckage

The proc_handler initialization is simply dropped for this table,
but AFAIS from the commit comment this was done simply to disable
the vsyscall_gtod_data.sysctl_enabled tuning. Did I miss something?

 > [...]
> checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
> Switched to high resolution mode on CPU 0
>  it is
> Freeing initrd memory: 3765k freed
> sysctl table check failed: /kernel/vsyscall64  No proc_handler
> Pid: 1, comm: swapper Not tainted 2.6.25-rc3 #60
> 
> Call Trace:
>  [<ffffffff8024a61f>] set_fail+0x48/0x53
>  [<ffffffff8024ab15>] sysctl_check_table+0x4eb/0x53e
>  [<ffffffff8024ab2f>] sysctl_check_table+0x505/0x53e
>  [<ffffffff8023a96e>] __register_sysctl_paths+0xf1/0x146
>  [<ffffffff8023a9ec>] register_sysctl_paths+0x29/0x2b
>  [<ffffffff8023aa01>] register_sysctl_table+0x13/0x15
>  [<ffffffff8059bb18>] vsyscall_init+0x49/0x6e
>  [<ffffffff8059571e>] kernel_init+0x162/0x2d2
>  [<ffffffff8020ce18>] child_rip+0xa/0x12
>  [<ffffffff803357dc>] ? acpi_ds_init_one_object+0x0/0x88
>  [<ffffffff805955bc>] ? kernel_init+0x0/0x2d2
>  [<ffffffff8020ce0e>] ? child_rip+0x0/0x12
> 
> audit: initializing netlink socket (disabled)
> [...]
> 
> 

