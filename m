Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbYFMG7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbYFMG7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 02:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYFMG73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 02:59:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:8887 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbYFMG72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 02:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=X6U4LQWMFlLOnJJKFgvFe0mAnzEX0TnfUSN8HLsc1xbi2J5RBqd+jVOR0pApqA27ka
         BH7se8GpRJm5wM/xvmThrPHlaN/yuhZdgT7Hkmwttw/T3U7ZvqnPvdZ3zyOUUQe7KH6R
         hx+xdcmUEJMie4yvvHZMc5JC/jrT91X03MnOY=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Fri, 13 Jun 2008 06:56:42 +0000
User-Agent: KMail/1.9.9
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-usb@vger.kernel.org
References: <200806010415.05290.chris2553@googlemail.com> <485027AC.6060901@s5r6.in-berlin.de> <1213212965.3461.12.camel@localhost.localdomain>
In-Reply-To: <1213212965.3461.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806130656.43016.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Wednesday 11 June 2008, James Bottomley wrote:
> On Wed, 2008-06-11 at 21:29 +0200, Stefan Richter wrote:
> > James Bottomley wrote:
> > > On Wed, 2008-06-11 at 12:15 -0700, Greg KH wrote:
> > >> On Wed, Jun 11, 2008 at 06:58:05PM +0000, Chris Clayton wrote:
> > >>> Jun 11 17:48:13 upstairs udevd-event[1457]: wait_for_sysfs: wait for
> > >>> '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.
> > >>>0/host4/ioerr_cnt' for 20 mseconds Jun 11 17:48:18 upstairs last
> > >>> message repeated 236 times
> > >>
> > >> This doesn't look good.  It looks like a udev rule in your system is
> > >> looking for a file that will never show up.  That's a short way to a
> > >> long delay time :)
> > >>
> > >> Try commenting out the rule that does this and see if things are
> > >> fixed.
> > >
> > > Actually, there's something seriously wrong here:  ioerr_cnt is a
> > > property of the device, not of the host (as in it will never appear
> > > under .../host4 but under .../host4/targetX:X:X/4:X:X:X/ioerr_cnt).
> > > Perhaps an investigation of why udevd-event is looking under host4/ is
> > > in order.
> >
> > So the change which commit b0ed43360fdca227048d88a08290365cb681c1a8
> > "[SCSI] add scsi_host and scsi_target to scsi_bus" introduced is leading
> > the udev scripts onto a wrong trail?
>
> Yes, I think so ... what it does is make us get bus events for the
> target as well as the lun, whereas without it we only get them for the
> lun.  I think something is misparsing the new target event and this is
> where the trouble is coming from.
>

I assume that since we now the source of this problem, you can create it at 
will. I only mention because if you need me to test a patch, it will have to be 
before Tuesday, June 17 - I go on holiday (vacation) on that day.

Thanks

Chris
> James



-- 
Beauty is in the eye of the beerholder.
