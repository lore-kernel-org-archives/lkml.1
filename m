Return-Path: <linux-kernel-owner+w=401wt.eu-S1030862AbXDRDZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030862AbXDRDZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 23:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031322AbXDRDZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 23:25:57 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:48713 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030862AbXDRDZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 23:25:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iERoQ62qpwd1ytVNsjH6zu1TmXLLAAbuJU1Lk6jhgmzwAicI6tOXgdc50bi0sSzaLvJ1QdYInxPX2o81uPZ389DVv5joyW+eMEuGhgHqACzkFCG0xeuz8bCHS+fS9TAZ+sWzwWZoEvTqH1bpApeLeRU2t24Ld9U0c1j1jVDg8CA=  ;
X-YMail-OSG: V51pRTwVM1kyPuGLEKA89dIAePxmKfbKN5wLhgNNO0xCdLdIVNn0zMdQSLbY_GQ._heUXMLfBw--
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
Date: Tue, 17 Apr 2007 20:25:52 -0700
User-Agent: KMail/1.7.1
Cc: Pavel Machek <pavel@ucw.cz>, Zhang Rui <rui.zhang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org,
       "linux-acpi@vger" <linux-acpi@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704031741.42273.david-b@pacbell.net> <200704171457.50416.david-b@pacbell.net> <20070418030343.GB12756@kroah.com>
In-Reply-To: <20070418030343.GB12756@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704172025.52862.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2007 8:03 pm, Greg KH wrote:
> On Tue, Apr 17, 2007 at 02:57:49PM -0700, David Brownell wrote:

> > Looks like the i8042 serial nodes will be bizarre too:
> > 
> > 	/sys/devices/pnp0/00:09
> > 		... touchpad's PNP node
> > 	/sys/devices/acpi_system:00/device:00/PNP0A03:00/device:15/PNP0F13:00
> > 		... its ACPI node
> > 	/sys/devices/platform/i8042/serio4
> > 		... its serio node
> > 
> > That seems like two nodes too many, but without me trying to twist
> > my mind around i8042 issues, I can't quite speculate why struct
> > serio "is-a" device rather than "has-a" device (the PNP node) as
> > would be the case with a more normal driver structure.
> > 
> > But the existence of that device_add() in serio.c sure explains why
> > the PNP node doesn't get associated with the input class device one
> > would expect from knowing that 00:09 is the touchpad.
> 
> Ick, how can we fix this up?

You're asking the wrong penguin for that answer ... :)

But I'd suggest that someone who knows ACPI -- and PNPACPI --- work
on merging those ACPI and PNP nodes.  (Same thing would need doing
with ACPI and PCI ...)

That ACPI subtree is quite new, at least in terms of being public.
So I'd think its details must be very flexible right now.


> > And hmm, just this morning I saw email from Greg re-affirming that
> > drivers should not device_add().  Converting such legacy drivers is
> > simple though, right?  :)
> 
> Heh, yeah right, they can remain platform drivers :)

Most platform drivers aren't legacy drivers.  Just the x86 ones!
And a lot of those wouldn't be headaches if PNPACPI were used better...

In this case, making the i8042 stuff use PNP more naturally would
seem like the most natural way to resolve the problem for all but
pre-ACPI legacy x86 hardware.  Now that ACPI implies PNPACPI by
default, various corner cases have vanished.

That said, I know less about i8042 wierdness -- and I know there's
a lot of it! -- than about ACPI, so I'll stay out of that.  Beyond
pointing out these curious little corner cases I've uncovered while
trying to make sure wakeup annotations get assigned to the right
sysfs device nodes.  :)

- Dave


> 
> thanks,
> 
> greg k-h
> 
