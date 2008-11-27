Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYK0POz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYK0POz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYK0POr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:14:47 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:56191 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbYK0POq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:14:46 -0500
Date: Thu, 27 Nov 2008 10:14:45 -0500
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: How to add the Asus R1F to asus-laptop.c?
Message-ID: <20081127151445.GH5682@csclub.uwaterloo.ca>
References: <20080903170649.GF12476@csclub.uwaterloo.ca> <200809031859.28203.alistair@devzero.co.uk> <20080903201620.GS12474@csclub.uwaterloo.ca> <200809032132.34967.alistair@devzero.co.uk> <20080903203954.GT12474@csclub.uwaterloo.ca> <71cd59b00809032348h7874167ckae1ea3d1ddab1e1c@mail.gmail.com> <20080904134139.GU12474@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904134139.GU12474@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 09:41:39AM -0400, Lennart Sorensen wrote:
> On Thu, Sep 04, 2008 at 08:48:03AM +0200, Corentin Chary wrote:
> > Hi,
> > Currently I've no internet connection, so I'm depend off the hotspot I
> > can found when I'm close to my windows
> > Anyway, my connection will be activated soon, so please poke me again monday.
> > I'ts true that I should take a look at sf.net patchs ...
> > Anyway, this laptop should work with asus-laptop oO.
> > modprobe asus-laptop gives you "No such device" ?
> 
> Using 2.6.26, I get no such device and the driver refuses to load.
> asus-acpi loads fine and does its job.
> 
> I will try the patch and see if that helps.  I was rather surprised that
> it didn't load, so I started doing acpi dumps and looking at the driver
> to see if I could figure out what it used to determine things.  It
> looked to me like it checks if the hotkey registration works, which by
> the looks of it it isn't doing at the moment.

I finally got a chance to play with this.  Turns out asus-laptop DOES
work.  It however does NOT work if asus-acpi is already loaded, which
for some reason udev likes to do automatically because both claim to
support the same devices, but they sure aren't equal.

Now once asus-acpi is unloaded and asus-laptop loaded, then it does
appear to do stuff.  fn+f2 does manage to do something, although not
consistently or very reliably, but I suspect that may be a user space
acpi events problem to do with the scripts that are run when the key is
hit, so I have to play with that a bit more.

It does appear that when loaded, the wifi rf_kill is cleared, but after
hitting fn+f2 a few times, it gets set again and never clears after that
other than by unloading and reloading asus-laptop, so something fishy is
still going on.

-- 
Len Sorensen
