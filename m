Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbXEYVsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbXEYVsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763684AbXEYVr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:47:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218AbXEYVr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:47:27 -0400
Date: Fri, 25 May 2007 14:40:05 -0700
From: Greg KH <gregkh@suse.de>
To: Mattia Dongili <malattia@linux.it>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stuart Hayes <stuart_hayes@dell.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [2.6.22-rc1-mm1] ehci-hcd - BUG: scheduling while atomic:
	rmmod/0x00000001/4568
Message-ID: <20070525214005.GA6925@suse.de>
References: <20070521024437.GA4751@inferi.kami.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521024437.GA4751@inferi.kami.home>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 11:44:37AM +0900, Mattia Dongili wrote:
> Hello,
> 
> with gregkh-usb-usb-ehci-cpufreq-fix.patch removing ehci-hcd causes the
> following BUG:

Thanks for letting me know.

Stuart, any help here?

thanks,

greg k-h



> [  459.800033] BUG: scheduling while atomic: rmmod/0x00000001/4568
> [  459.800045]  [<c0104eb3>] dump_trace+0x63/0x1ec
> [  459.800055]  [<c0105056>] show_trace_log_lvl+0x1a/0x30
> [  459.800066]  [<c0105c82>] show_trace+0x12/0x14
> [  459.800099]  [<c0105d0f>] dump_stack+0x16/0x18
> [  459.800135]  [<c02eff66>] __sched_text_start+0x56/0x7db
> [  459.800142]  [<c02f0768>] wait_for_completion+0x65/0x9b
> [  459.800147]  [<c0132c38>] synchronize_rcu+0x2d/0x33
> [  459.800154]  [<c0138387>] synchronize_srcu+0x23/0x5f
> [  459.800160]  [<c012f6bf>] srcu_notifier_chain_unregister+0x43/0x4d
> [  459.800185]  [<c0287b83>] cpufreq_unregister_notifier+0x22/0x32
> [  459.800203]  [<f8e85713>] ehci_stop+0x4f/0xb7 [ehci_hcd]
> [  459.800248]  [<f8dc48d4>] usb_remove_hcd+0x97/0xd7 [usbcore]
> [  459.800280]  [<f8dcdf1d>] usb_hcd_pci_remove+0x18/0x6a [usbcore]
> [  459.800317]  [<c01f1ca3>] pci_device_remove+0x1c/0x3d
> [  459.800324]  [<c024fc46>] __device_release_driver+0x74/0x90
> [  459.800332]  [<c025009f>] driver_detach+0x81/0xc2
> [  459.800337]  [<c024f7f9>] bus_remove_driver+0x5d/0x7c
> [  459.800342]  [<c025010a>] driver_unregister+0xb/0xd
> [  459.800347]  [<c01f1e1d>] pci_unregister_driver+0x13/0x65
> [  459.800351]  [<f8e858f8>] ehci_hcd_cleanup+0x10/0x12 [ehci_hcd]
> [  459.800360]  [<c0143b11>] sys_delete_module+0x187/0x1ae
> [  459.800367]  [<c0103e62>] sysenter_past_esp+0x5f/0x85
> [  459.800373]  [<ffffe410>] 0xffffe410
> [  459.800384]  =======================
> 
> static void ehci_stop (struct usb_hcd *hcd)
> {
> 	...
> 	spin_lock_irq(&ehci->lock);
> 	if (HC_IS_RUNNING (hcd->state))
> 		ehci_quiesce (ehci);
> 
> #ifdef CONFIG_CPU_FREQ
> 	cpufreq_unregister_notifier(&ehci->cpufreq_transition,
> 				    CPUFREQ_TRANSITION_NOTIFIER);
> #endif
> 
> -- 
> mattia
> :wq!
