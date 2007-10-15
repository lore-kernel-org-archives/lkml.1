Return-Path: <linux-kernel-owner+w=401wt.eu-S1762906AbXJOVzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906AbXJOVzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbXJOVzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:55:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34443 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbXJOVzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:55:02 -0400
Date: Mon, 15 Oct 2007 14:54:06 -0700
From: Greg KH <greg@kroah.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Keir Fraser <keir@xensource.com>, Stable Kernel <stable@kernel.org>
Subject: Re: [stable] [PATCH 00/12] xen/paravirt_ops patches for 2.6.24
Message-ID: <20071015215406.GA1588@kroah.com>
References: <20071015204840.074767068@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015204840.074767068@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 01:48:40PM -0700, Jeremy Fitzhardinge wrote:
> Hi Linus,
> 
> Here's a set of patches to update paravirt_ops and Xen for 2.6.24
> 
> A quick overview of the patchset:
> 
> paravirt_ops:
> 	Remove the monolithic paravirt_ops structure, and replace it with
> 	smaller structures of related functions.  Also, clean up the handling
> 	of lazy mode to make it easier to implement.
> 
> x86/mm/init.c: remove a chunk of dead code
> 
> Xen:
> 	- remove duplicate includes
> 	- yield if the target vcpu of an IPI is not currently running
> 	- add post-batch callbacks for multicalls [*]
> 	- deal with unpinning pagetables when another vcpu still [*]
> 	  has a cr3 reference
> 	- deal with split ptelocks by pinning each pte page
> 	  separately under lock
> 	- determine the kernel/hypervisor address split dynamically
> 	- use the right arg structure for register_vcpu_info [*]
> 	- add extra debugging output for failed multicalls
> 
> XFS:
> 	- eagerly unmap vmapped areas to avoid confict with Xen
> 
> [*] bugfix needed for 2.6.23.  I've also cc:d them to stable@kernel.org

Yeah, but you cc:ed all 12 patches to stable@.  The majority of which we
don't want to take, right?  Which specific ones should stable@ care
about?

thanks,

greg k-h
