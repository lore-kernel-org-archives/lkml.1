Return-Path: <linux-kernel-owner+w=401wt.eu-S933108AbYB0AkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbYB0AkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYB0Ajx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:39:53 -0500
Received: from ag-out-0708.google.com ([72.14.246.241]:19603 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760375AbYB0Ajw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:39:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PrRIZlVEbG5e/UVD7yGMvyboC4Tgq7b39Ewa8cxlBfP6r77MY0grVkI8v+/4qn5oEkPAfqH0d+2pJV2tJhq0pTZiyhxZtMkvKt8oNbrLSTP5dqok42ychUpKAIhydAcGgQ3vQAYCmiGNSkuWqsFZYhCqNOXDk/gtoP3Fgi3S1c0=
Message-ID: <a8e1da0802261639w47475f2bt66d567658a6b1bea@mail.gmail.com>
Date: Wed, 27 Feb 2008 08:39:50 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [BUG] using smp_processor_id() in preemptible as suspending
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080226083354.be0a7351.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080226082411.GA2853@darkstar.te-china.tietoenator.com>
	 <20080226083354.be0a7351.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 12:33 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Tue, 26 Feb 2008 16:24:11 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>
>  > I don't know whom I should mail to, could you cc the proper guy? Thanks.
>  >
>  > [  118.331674] acpi LNXSYSTM:00: suspend
>  > [  118.331674] Disabling non-boot CPUs ...
>  > [  118.331674] CPU0 attaching NULL sched-domain.
>  > [  118.331674] CPU1 attaching NULL sched-domain.
>  > [  118.438750] CPU 1 is now offline
>  > [  118.438750] lockdep: fixing up alternatives.
>  > [  118.438750] SMP alternatives: switching to UP code
>  > [  118.438750] BUG: using smp_processor_id() in preemptible [00000000] code: s2ram/2818
>  > [  118.438750] caller is rcu_offline_cpu+0x15a/0x1c0
>  > [  118.438750] Pid: 2818, comm: s2ram Not tainted 2.6.25-rc3-test #2
>  > [  118.438750]  [<c0129738>] ? printk+0x18/0x20
>  > [  118.438750]  [<c025c551>] debug_smp_processor_id+0xb1/0xc0
>  > [  118.438750]  [<c0161f8a>] rcu_offline_cpu+0x15a/0x1c0
>  > [  118.438750]  [<c03d408f>] rcu_cpu_notify+0x3f/0x60
>  > [  118.438750]  [<c0141b0d>] notifier_call_chain+0x3d/0x80
>  > [  118.438750]  [<c0141db9>] __raw_notifier_call_chain+0x19/0x20
>  > [  118.438750]  [<c0141dda>] raw_notifier_call_chain+0x1a/0x20
>  > [  118.438750]  [<c015262b>] _cpu_down+0x13b/0x230
>  > [  118.438750]  [<c01527c9>] disable_nonboot_cpus+0x49/0xd0
>  > [  118.438750]  [<c0157492>] suspend_devices_and_enter+0x72/0x130
>  > [  118.438750]  [<c0129738>] ? printk+0x18/0x20
>  > [  118.438750]  [<c0157623>] enter_state+0xb3/0xe0
>  > [  118.438750]  [<c015777d>] state_store+0x7d/0xc0
>  > [  118.438750]  [<c0157700>] ? state_store+0x0/0xc0
>  > [  118.438750]  [<c0249e4e>] kobj_attr_store+0x2e/0x40
>  > [  118.438750]  [<c01ca957>] flush_write_buffer+0x47/0x70
>  > [  118.438750]  [<c01ca9c9>] sysfs_write_file+0x49/0x70
>  > [  118.438750]  [<c0188d41>] vfs_write+0x91/0x140
>  > [  118.438750]  [<c0188e9d>] sys_write+0x3d/0x70
>  > [  118.438750]  [<c0104fca>] syscall_call+0x7/0xb
>  > [  118.438750]  =======================
>  > [  118.438750] CPU0 attaching NULL sched-domain.
>  > [  118.440335] CPU1 is down
>
>  Paul & Ingo I guess
>
>  > My .config
>
>  Doesn't tell us whether you'r eusing CONFIG_CLASSIC_RCU or
>  CONFIG_PREEMPT_RCU.  I assume CONFIG_CLASSIC_RCU, if you ran `make
>  oldconfig'.

# CONFIG_CLASSIC_RCU is not set
CONFIG_PREEMPT_RCU=y


>
>  Which kernel are you running here?
>

2.6.25-rc3 with some bluetooth debug code of mine
