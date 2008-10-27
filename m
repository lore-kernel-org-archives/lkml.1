Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbYJ0MpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbYJ0MpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 08:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYJ0MpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 08:45:11 -0400
Received: from ns2.suse.de ([195.135.220.15]:57230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbYJ0MpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 08:45:10 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Pavel Machek <pavel@suse.cz>
Subject: Re: leds-hp-disk vs lis3lv02d
Date: Mon, 27 Oct 2008 13:45:03 +0100
User-Agent: KMail/1.9.9
Cc: Eric Piel <eric.piel@tremplin-utc.net>, akpm@linux-foundation.org,
       burman.yan@gmail.com, rpurdie@rpsys.net,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Kay Sievers <kasievers@suse.de>, hmh@hmh.eng.br
References: <200810162255.m9GMtKj4001733@imap1.linux-foundation.org> <4902F817.4050108@tremplin-utc.net> <20081026174023.GA1847@ucw.cz>
In-Reply-To: <20081026174023.GA1847@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810271345.04961.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 October 2008 18:40:25 Pavel Machek wrote:
> Hi!
>
> > >> shouldn't this one be integrated into Eric's/Yan's driver?
> > >
> > > It is separate piece of hardware, completely unrelated to lids3v
> > > chip. No, it should not be integrated, but I'll makesure they work
> > > toggether well.
> >
> > Hello,
> > I think I talked too fast: it seems impossible to have both drivers
> > (leds-hp-disk and lis3lv02d) working at the same time. Only the first
> > driver loaded is used.
> >
> > After a little look at it, I think it comes from the fact that both
> > drivers are assigned to the same MODALIAS (HPQ0004). The ACPI PNP
> > (through the generic bus infrastructure) only declare the device to one
> > of the drivers supporting it, not all of them.
>
> I can reproduce it here and it obviously needs fixing.
These are the first ACPI drivers who register for the same ACPI Hardware ID.

> OTOH  it should 
> not block merge; both drivers still work and are useful.
But for long-term the HPQ0004 specific things in the lids3v driver should get 
merged with your HP leds driver also registering for HPQ0004 and the lids3v 
specific things should get a separate driver which HPQ0004 driver makes use 
of?
So in the end also for the HPQ0004 device only one driver should register for?
>
> > How can I tell to ACPI that it should load both drivers for the same PNP
> > ID match?
>
> I'll take a look if I can figure something out...
Kay may know whether this should work and how.
IMO having several drivers registering for the same HID should get avoided if 
possible, it's confusing.

     Thomas

Pavel: I am also not sure whether it's a good idea to mis-use the HP's LED for 
mail notification or similar or to expose this one as a general LED. This LED 
is intended to be used with the disk parking feature by the vendor?
I don't know the LED interface well, but if it's now possible that every mail 
or other app can reprogram the disk parking LED for it's own purposes, this 
sounds wrong. The LED can still be accessed and activated, e.g. when disk 
gets parked behind the OS'es back. If this is a nice hack to e.g. use LED for 
suspend debugging or similar, then it should be well hidden to the outside 
world.
