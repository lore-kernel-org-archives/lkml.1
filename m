Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZF3XoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZF3XoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZF3XoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:44:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:53104 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbZF3XoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:44:16 -0400
Date: Tue, 30 Jun 2009 16:42:06 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, avi@redhat.com,
       ying.huang@intel.com, stable@kernel.org
Subject: Re: patch kvm-add-vt-x-machine-check-support.patch added to
	2.6.30-stable tree
Message-ID: <20090630234206.GA22546@suse.de>
References: <20090629184144.76C9948FD3@coco.kroah.org> <200907010053.40900.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907010053.40900.s.L-H@gmx.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 12:53:37AM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Wednesday 01 July 2009, gregkh@suse.de wrote:
> > This is a note to let you know that we have just queued up the patch titled
> > 
> >     Subject: KVM: Add VT-x machine check support
> > 
> > to the 2.6.30-stable tree.  Its filename is
> > 
> >     kvm-add-vt-x-machine-check-support.patch
> > 
> > A git repo of this tree can be found at 
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > 
> > From a0861c02a981c943573478ea13b29b1fb958ee5b Mon Sep 17 00:00:00 2001
> > From: Andi Kleen <ak@linux.intel.com>
> > Date: Mon, 8 Jun 2009 17:37:09 +0800
> > Subject: KVM: Add VT-x machine check support
> 
> This patch fails to compile if applied to 2.6.30 + current stable queue.
> 
> arch/x86/kvm/vmx.c: In function 'vmx_vcpu_run':
> arch/x86/kvm/vmx.c:3573: error: 'exit_intr_info' undeclared (first use in this function)
> arch/x86/kvm/vmx.c:3573: error: (Each undeclared identifier is reported only once
> arch/x86/kvm/vmx.c:3573: error: for each function it appears in.)
> make[4]: *** [arch/x86/kvm/vmx.o] Error 1
> make[3]: *** [arch/x86/kvm] Error 2
> make[3]: *** Waiting for unfinished jobs....
> 
> It seems to depend on the code refactoring introduced by 
> 
> From 7b4a25cb296e2a73d2e87a4af65361d45d450a27 Mon Sep 17 00:00:00 2001
> From: Gleb Natapov <gleb@redhat.com>
> Date: Mon, 30 Mar 2009 16:03:08 +0300
> Subject: KVM: VMX: Fix handling of a fault during NMI unblocked due to IRET
> 
> Bit 12 is undefined in any of the following cases:
>  If the VM exit sets the valid bit in the IDT-vectoring information field.
>  If the VM exit is due to a double fault.
> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> Signed-off-by: Avi Kivity <avi@redhat.com>
> 
> and followed up by the code movement in
> 
> From 20f65983e30f222e5383f77206e3f571d1d64610 Mon Sep 17 00:00:00 2001
> From: Gleb Natapov <gleb@redhat.com>
> Date: Mon, 11 May 2009 13:35:55 +0300
> Subject: KVM: Move "exit due to NMI" handling into vmx_complete_interrupts()
> 
> To save us one reading of VM_EXIT_INTR_INFO.
> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> Signed-off-by: Avi Kivity <avi@redhat.com>

Thanks, I was building without kvm enabled in my configs and missed this
one.

I've added these two other patches and everything looks better.

greg k-h
