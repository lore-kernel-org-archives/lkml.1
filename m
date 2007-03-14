Return-Path: <linux-kernel-owner+w=401wt.eu-S1030875AbXCNUGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030875AbXCNUGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030877AbXCNUGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:06:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48837 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030875AbXCNUGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:06:31 -0400
Date: Wed, 14 Mar 2007 16:06:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: David Howells <dhowells@redhat.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] question on irqs and memory ordering
In-Reply-To: <200703142044.23018.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0703141557210.7723-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Oliver Neukum wrote:

> Hi,
> 
> I am looking at this code:
> 
> 	if (new_msr &
> 	    (MOS_MSR_DELTA_CTS | MOS_MSR_DELTA_DSR | MOS_MSR_DELTA_RI |
> 	     MOS_MSR_DELTA_CD)) {
> 		icount = &mos7840_port->icount;
> 
> 		/* update input line counters */
> 		if (new_msr & MOS_MSR_DELTA_CTS) {
> 			icount->cts++;
> 		}
> 		if (new_msr & MOS_MSR_DELTA_DSR) {
> 			icount->dsr++;
> 		}
> 		if (new_msr & MOS_MSR_DELTA_CD) {
> 			icount->dcd++;
> 		}
> 		if (new_msr & MOS_MSR_DELTA_RI) {
> 			icount->rng++;
> 		}
> 	}
> 
> It is called in interrupt and uses no locking. What happens if the next
> irq is processed on another cpu? Is that cpu guaranteed to see the updates
> to the incremented variables?

I _think_ it's okay.  Taking an interrupt and returning from an interrupt
ought to have explicit or implicit memory barriers.

It wouldn't hurt to ask someone else.  David Howells wrote
Documentation/memory-barriers.txt so maybe he knows.  (The document itself
doesn't say one way or the other.)

Alan Stern

