Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYHMThl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYHMThl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbYHMThX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:37:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33292 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754007AbYHMThW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:37:22 -0400
Date: Wed, 13 Aug 2008 15:37:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       <James.Bottomley@hansenpartnership.com>, <teheo@novell.com>
Subject: Re: Power management for SCSI
In-Reply-To: <200808131825.27303.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0808131534440.13982-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, Oliver Neukum wrote:

> > In Alan's patch, SCSI calls scsi_host_template methods (if the LLD
> > provides ones) to suspend and resume a Scsi_Host.  The LLD can use them
> > to work with the underlying infrastructure to determine what can be done
> > at that time.  I.e. are there other protocols or other initiator-like
> > nodes sharing the link?  If yes or if "maybe yes", the infrastructure
> > keeps the link up.  If not, it can move it into a low-power state.
> 
> That is a parculiar way of viewing it. Alan's patch introduce runtime
> pm attributes to the devices. Quoting:
> 
> 
> +/**
> + * scsi_suspend_sdev - suspend a SCSI device
> + * @sdev: the scsi_device to suspend
> + * @msg: Power Management message describing this state transition
> + *
> + * SCSI devices can't actually be suspended in a literal sense,
> + * because SCSI doesn't have any notion of power management.  Instead
> + * this routine drains the request queue and calls the ULD's suspend
> + * method to flush caches, spin-down drives, and so on.
> + *
> + * If the suspend succeeds, we call scsi_autosuspend_host to decrement
> + * the host's count of unsuspended devices and invoke the LLD's suspend
> + * method.
> 
> So you cannot operate on the link independent from the devices.

With the original patch, you can't operate on the link independent from 
the devices.  But with the revised patch (whenever I manage to find 
time to write it!), you _will_ be able to.

Alan Stern

