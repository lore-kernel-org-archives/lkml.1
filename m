Return-Path: <linux-kernel-owner+w=401wt.eu-S1767577AbXCIWgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767577AbXCIWgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767572AbXCIWgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:36:20 -0500
Received: from gw.goop.org ([64.81.55.164]:37577 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767577AbXCIWgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:36:19 -0500
Message-ID: <45F1E160.1090608@goop.org>
Date: Fri, 09 Mar 2007 14:36:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309210430.GA14905@elte.hu> <20070309212714.GU10574@sequoia.sous-sol.org> <20070309214704.GA20988@elte.hu> <20070309221046.GV10574@sequoia.sous-sol.org> <20070309222435.GB24341@elte.hu>
In-Reply-To: <20070309222435.GB24341@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> ok, sure, how about the one i mentioned: long-term i'd like to have a 
> paravirt model where the guest does not store /any/ page tables - all 
> paging is managed by the hypervisor. The guest has a vma tree, but 
> otherwise it does not process pagefaults, has no concept of a pte (if in 
> paravirt mode), has no concept of kernel page tables either: there are 
> hypercalls to allocate/free guest-kernel memory, etc. This needs some 
> (serious) MM surgery but it's doable and it's interesting as well. How 
> would you map this to the VMI backend?

You wouldn't.  Why would you?  It might be a useful interface - and its
the perfect kind of high-level interface for pv_ops.  It might be worth
adapting a hypervisor to suit it, but you still need to support the
i386's pagetables.  So, you present the pv_ops interface with your
vma-based mappings, and it runs it through the vma->pagetable
translation layer to feed into either the i386 pagetables directly, or
to a hypervisor's page-based interface.

The important part is that there's more to the story than just pv_ops. 
If you wanted to make such a change, then you'd need to refactor the
i386 support code to add a vma->paging helper layer.  That layer would
be available for any pv_ops interface to use if it wishes.

(Remember, in the pv_ops model, bare hardware is a "hypervisor" too.)

Next problem?

    J
