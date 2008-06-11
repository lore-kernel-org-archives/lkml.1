Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbYFKTgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbYFKTgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 15:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYFKTgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 15:36:11 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52931 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554AbYFKTgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 15:36:09 -0400
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, Chris Clayton <chris2553@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-usb@vger.kernel.org
In-Reply-To: <485027AC.6060901@s5r6.in-berlin.de>
References: <200806010415.05290.chris2553@googlemail.com>
	 <1212950276.3574.7.camel@localhost.localdomain>
	 <200806102206.26818.chris2553@googlemail.com>
	 <200806111858.05114.chris2553@googlemail.com>
	 <20080611191533.GA6189@kroah.com>
	 <1213212282.3461.9.camel@localhost.localdomain>
	 <485027AC.6060901@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 14:36:05 -0500
Message-Id: <1213212965.3461.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 21:29 +0200, Stefan Richter wrote:
> James Bottomley wrote:
> > On Wed, 2008-06-11 at 12:15 -0700, Greg KH wrote:
> >> On Wed, Jun 11, 2008 at 06:58:05PM +0000, Chris Clayton wrote:
> >>> Jun 11 17:48:13 upstairs udevd-event[1457]: wait_for_sysfs: wait for '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/host4/ioerr_cnt' for 20 mseconds 
> >>> Jun 11 17:48:18 upstairs last message repeated 236 times
> >> This doesn't look good.  It looks like a udev rule in your system is
> >> looking for a file that will never show up.  That's a short way to a
> >> long delay time :)
> >>
> >> Try commenting out the rule that does this and see if things are fixed.
> > 
> > Actually, there's something seriously wrong here:  ioerr_cnt is a
> > property of the device, not of the host (as in it will never appear
> > under .../host4 but under .../host4/targetX:X:X/4:X:X:X/ioerr_cnt).
> > Perhaps an investigation of why udevd-event is looking under host4/ is
> > in order.
> 
> So the change which commit b0ed43360fdca227048d88a08290365cb681c1a8 
> "[SCSI] add scsi_host and scsi_target to scsi_bus" introduced is leading 
> the udev scripts onto a wrong trail?

Yes, I think so ... what it does is make us get bus events for the
target as well as the lun, whereas without it we only get them for the
lun.  I think something is misparsing the new target event and this is
where the trouble is coming from.

James


