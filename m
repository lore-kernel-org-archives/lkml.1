Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYHNGHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYHNGHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYHNGHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:07:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:40177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYHNGHc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:07:32 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Power management for SCSI
Date: Thu, 14 Aug 2008 08:08:26 +0200
User-Agent: KMail/1.9.9
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@suse.cz>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com
References: <Pine.LNX.4.44L0.0808131525530.13982-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808131525530.13982-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808140808.27022.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 13 August 2008 21:34:30 schrieb Alan Stern:
> On Wed, 13 Aug 2008, Oliver Neukum wrote:
> 
> > Am Mittwoch 13 August 2008 17:44:46 schrieb Alan Stern:
> > > > All children that are USB must be powered down. We know in fact that most
> > > > drives don't care that the device is suspended. The problem was drive
> > > > enclosures that cut power upon suspension losing cached data.
> > > 
> > > You misunderstood my question.  Are there SCSI transports other than
> > > USB sharing the requirement that all child devices must be suspended
> > > before the link can be powered down?
> > 
> > I dispute that USB in general has this property.
> 
> How can you dispute that?  You said it yourself, in the top quote
> above: "All children that are USB must be powered down."

But the children are SCSI, not USB.

> > Some storage devices
> > need their caches flushed. USB itself is perfectly happy with autosuspending
> > the storage device (host) without telling the disks (devices)
> > 
> > You could even argue that these storage devices violate the USB spec.
> 
> Oliver, you can't have it both ways.  Either we do spin down disks and
> drain device caches before autosuspending usb-storage or we don't.

That is true.

> For safety's sake, obviously we should.  The overhead is minimal since
> this happens only after the idle timeout has expired.  And for devices
> that don't support it (like flash storage), sd skips the spin-down
> command anway.

But you cannot make the conclusion that the ultimate children should have
any autosuspend attributes. We can implement autosuspend in usb storage
and propagate the suspend calls down the tree without SCSI knowing about
autosuspend.

Such a system would have it drawbacks, but it'd be a lot simpler.

	Regards
		Oliver
