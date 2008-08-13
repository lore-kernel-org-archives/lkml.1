Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYHMTmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYHMTmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYHMTmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:42:12 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42763 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbYHMTmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:42:11 -0400
Subject: Re: Power management for SCSI
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>, teheo@novell.com
In-Reply-To: <Pine.LNX.4.44L0.0808131534440.13982-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0808131534440.13982-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 14:42:06 -0500
Message-Id: <1218656526.3237.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-13 at 15:37 -0400, Alan Stern wrote:
> On Wed, 13 Aug 2008, Oliver Neukum wrote:
> 
> > > In Alan's patch, SCSI calls scsi_host_template methods (if the LLD
> > > provides ones) to suspend and resume a Scsi_Host.  The LLD can use them
> > > to work with the underlying infrastructure to determine what can be done
> > > at that time.  I.e. are there other protocols or other initiator-like
> > > nodes sharing the link?  If yes or if "maybe yes", the infrastructure
> > > keeps the link up.  If not, it can move it into a low-power state.
> > 
> > That is a parculiar way of viewing it. Alan's patch introduce runtime
> > pm attributes to the devices. Quoting:
> > 
> > 
> > +/**
> > + * scsi_suspend_sdev - suspend a SCSI device
> > + * @sdev: the scsi_device to suspend
> > + * @msg: Power Management message describing this state transition
> > + *
> > + * SCSI devices can't actually be suspended in a literal sense,
> > + * because SCSI doesn't have any notion of power management.  Instead
> > + * this routine drains the request queue and calls the ULD's suspend
> > + * method to flush caches, spin-down drives, and so on.
> > + *
> > + * If the suspend succeeds, we call scsi_autosuspend_host to decrement
> > + * the host's count of unsuspended devices and invoke the LLD's suspend
> > + * method.
> > 
> > So you cannot operate on the link independent from the devices.
> 
> With the original patch, you can't operate on the link independent from 
> the devices.  But with the revised patch (whenever I manage to find 
> time to write it!), you _will_ be able to.

That sounds great .. if you link it through the transport class, that
can implement the policy you want (as in power all devices down before
the link for USB, but just power down the link for SAS/SATA).

James


