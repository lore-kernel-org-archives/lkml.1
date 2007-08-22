Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbXHVJ2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbXHVJ2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbXHVJ23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:28:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016AbXHVJ22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:28:28 -0400
Date: Wed, 22 Aug 2007 12:22:17 +0200
From: Andi Kleen <ak@suse.de>
To: Zachary Amsden <zach@vmware.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
Message-ID: <20070822102217.GE2642@bingen.suse.de>
References: <46CBC842.4070100@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CBC842.4070100@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 10:23:14PM -0700, Zachary Amsden wrote:
> In general, I/O in a virtual guest is subject to performance problems.  
> The I/O can not be completed physically, but must be virtualized.  This 
> means trapping and decoding port I/O instructions from the guest OS.  
> Not only is the trap for a #GP heavyweight, both in the processor and 
> the hypervisor (which usually has a complex #GP path), but this forces 
> the hypervisor to decode the individual instruction which has faulted.  

Is that really that expensive? Hard to imagine.

e.g. you could always have a fast check for inb/outb at the beginning
of the #GP handler. And is your initial #GP entry really more expensive
than a hypercall? 

> Worse, even with hardware assist such as VT, the exit reason alone is 
> not sufficient to determine the true nature of the faulting instruction, 
> requiring a complex and costly instruction decode and simulation.

It's unclear to me why that should be that costly.

Worst case it's a switch()

-Andi
