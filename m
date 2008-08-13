Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbYHMTek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbYHMTek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYHMTec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:34:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33284 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751932AbYHMTeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:34:31 -0400
Date: Wed, 13 Aug 2008 15:34:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@suse.cz>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, <teheo@novell.com>
Subject: Re: [linux-pm] Power management for SCSI
In-Reply-To: <200808131821.30564.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0808131525530.13982-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, Oliver Neukum wrote:

> Am Mittwoch 13 August 2008 17:44:46 schrieb Alan Stern:
> > > All children that are USB must be powered down. We know in fact that most
> > > drives don't care that the device is suspended. The problem was drive
> > > enclosures that cut power upon suspension losing cached data.
> > 
> > You misunderstood my question.  Are there SCSI transports other than
> > USB sharing the requirement that all child devices must be suspended
> > before the link can be powered down?
> 
> I dispute that USB in general has this property.

How can you dispute that?  You said it yourself, in the top quote
above: "All children that are USB must be powered down."

> Some storage devices
> need their caches flushed. USB itself is perfectly happy with autosuspending
> the storage device (host) without telling the disks (devices)
> 
> You could even argue that these storage devices violate the USB spec.

Oliver, you can't have it both ways.  Either we do spin down disks and
drain device caches before autosuspending usb-storage or we don't.  
For safety's sake, obviously we should.  The overhead is minimal since
this happens only after the idle timeout has expired.  And for devices
that don't support it (like flash storage), sd skips the spin-down
command anway.

At any rate, Stefan Richter has answered my original question.  
Firewire has essentially the same restrictions as USB.

Alan Stern

