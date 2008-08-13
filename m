Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYHMQYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYHMQYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYHMQYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:24:25 -0400
Received: from ns1.suse.de ([195.135.220.2]:50575 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbYHMQYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:24:24 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Power management for SCSI
Date: Wed, 13 Aug 2008 18:25:26 +0200
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       James.Bottomley@hansenpartnership.com, teheo@novell.com
References: <Pine.LNX.4.44L0.0808131051330.2455-100000@iolanthe.rowland.org> <200808131724.52461.oneukum@suse.de> <48A30140.9040704@s5r6.in-berlin.de>
In-Reply-To: <48A30140.9040704@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808131825.27303.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 13 August 2008 17:44:00 schrieb Stefan Richter:
> Oliver Neukum wrote:
> > Am Mittwoch 13 August 2008 16:59:23 schrieb Alan Stern:
> [Quoting Oliver:  true SCSI busses can be shared. So are we using the
> correct approach?]
> >> This is a good question.  Most USB mass-storage devices do not act as a
> >> true SCSI bus, but I believe there are a few non-standard ones that do
> >> -- the USB device really contains a SCSI host and arbitrary SCSI
> > 
> > OK, but does it make sense to have SCSI autosuspend? Or should autosuspend
> > operate on the bus the _host_ is connected to (usb, pci, ...)?
> 
> In Alan's patch, SCSI calls scsi_host_template methods (if the LLD
> provides ones) to suspend and resume a Scsi_Host.  The LLD can use them
> to work with the underlying infrastructure to determine what can be done
> at that time.  I.e. are there other protocols or other initiator-like
> nodes sharing the link?  If yes or if "maybe yes", the infrastructure
> keeps the link up.  If not, it can move it into a low-power state.

That is a parculiar way of viewing it. Alan's patch introduce runtime
pm attributes to the devices. Quoting:


+/**
+ * scsi_suspend_sdev - suspend a SCSI device
+ * @sdev: the scsi_device to suspend
+ * @msg: Power Management message describing this state transition
+ *
+ * SCSI devices can't actually be suspended in a literal sense,
+ * because SCSI doesn't have any notion of power management.  Instead
+ * this routine drains the request queue and calls the ULD's suspend
+ * method to flush caches, spin-down drives, and so on.
+ *
+ * If the suspend succeeds, we call scsi_autosuspend_host to decrement
+ * the host's count of unsuspended devices and invoke the LLD's suspend
+ * method.

So you cannot operate on the link independent from the devices.

	Regards
		Oliver
