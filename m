Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbXHEM56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbXHEM56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 08:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbXHEM5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 08:57:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:54125 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbXHEM5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 08:57:49 -0400
Date: Sun, 5 Aug 2007 14:57:26 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Rob Landley <rob@landley.net>
cc: 7eggert@gmx.de, Greg KH <greg@kroah.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
In-Reply-To: <200707231749.50405.rob@landley.net>
Message-ID: <Pine.LNX.4.58.0708051226001.2279@be1.lrz>
References: <8I2t1-7jt-5@gated-at.bofh.it> <8Jbuh-84N-3@gated-at.bofh.it>
 <E1ICDr7-0000e9-P4@be1.lrz> <200707231749.50405.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18jV0ORhce+txSvUSrhbmPLpfuJA0+/wKi6e5L
 DF8foU84BNWtr7xrv1jQBN2adDtNfXeTls6nWOqcuBucB2a0ed
 cxGqwvwAs39pczM2KpaHg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Rob Landley wrote:
> On Saturday 21 July 2007 8:14:41 am Bodo Eggert wrote:
> > Greg KH <greg@kroah.com> wrote:
> > > On Fri, Jul 20, 2007 at 08:21:39PM -0400, Rob Landley wrote:
> > >> I'm not trying to document /sys/devices.  I'm trying to document
> > >> hotplug, populating /dev, and things like firmware loading that fall out
> > >> of that. This requires use of sysfs, and I'm only trying to document as
> > >> much of sysfs as you need to do that.
> > >
> > > Like I stated before, you do not need to even have sysfs mounted to have
> > > a dynamic /dev.
> > >
> > > And why do you need to document populating /dev dynamically?  udev
> > > already solves this problem for you, it's not like people are going off
> > > and reinventing udev for their own enjoyment would not at least look at
> > > how it solves this problem first.
> >
> > Turning your words around, you get: "Whatever one of these programs does
> > documents how dynamic devices should be handled." If this is true, any
> > change that makes one of these programs break is a kernel bug.
> >
> > Besides that: How am I supposed to be able to correctly change udev if
> > there is no document telling me what would work and what happens to
> > work by accident?
> 
> You aren't expected to.  Remember that udev and sysfs are written by the same 
> people, working together off-list.  They're free to break the exported data 
> format on a whim, because they write the code at both ends and fundamentally 
> they're talking to themselves.  They honestly say you can't expect a new 
> kernel to work with an old udev, and they say it with a straight face.  (To 
> me, this sounds like saying you can't expect a new kernel to work with an old 
> version of ps, because of /proc.)
> 
> Documentation is a threat to this way of working, because it would impose 
> restrictions on them.  A spec is only of use if you introduce the radical 
> idea that the information exported by sysfs exists for some purpose _other_ 
> than simply to provide udev with information (and a specific version of udev 
> matched to that kernel version, at that).

And having no documentation is, as you can see in this thread, a threat to
open software. Having exactly one blob of software, and being left on your
own once you change a bit, is one step away from having a binary only module.

> > > To do otherwise would be foolish :)
> >
> > Some people like to fool around and create even smaller wheels.
> > E.g. I'm changing the ACPI button driver to just call Ctrl_alt_del
> > in order not to have an extra process running and free 0.2 % of my RAM.
> 
> When I started looking at udev in 2005, it was a disaster.  My commentary at 
> the time is at http://lkml.org/lkml/2005/10/30/189 and the relevant bit is:

[...]

> And so I made mdev, a utility which populated /dev _with_ a config file in 7k.  
> Greg's upset I didn't just patch udev to remove libsysfs, remove the 
> duplicated klibc code, remove the gratuitous database, remove the 
> overcomplicated config file parser (with rules compiler), and so on.  They're 
> boggling that I could ever have been unhappy with the One True Project to 
> populate /dev.

I see, we agree on this point. Besides that, I like to see the steps to be
done, instead of having a letter sent to a voodoo doctor in Africa (called 
udev) and getting back a magic spell to be chanted on my system (unless 
he just pokes some voodoo doll).
-- 
Top 100 things you don't want the sysadmin to say:
87. Sorry, the new equipment didn't get budgetted.
