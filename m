Return-Path: <linux-kernel-owner+w=401wt.eu-S1764926AbXHFOrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764926AbXHFOrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762765AbXHFOq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:46:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56492 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761442AbXHFOqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:46:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: suspend/hibernation regression between 2.6.19 and 2.6.20 w/ Thinkpad T41
Date: Mon, 6 Aug 2007 16:56:16 +0200
User-Agent: KMail/1.9.5
Cc: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>,
       Pavel Machek <pavel@ucw.cz>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <200708051902.18801.toralf.foerster@gmx.de> <200708061136.50491.toralf.foerster@gmx.de> <20070806143631.GB31615@khazad-dum.debian.net>
In-Reply-To: <20070806143631.GB31615@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708061656.17027.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 August 2007 16:36, Henrique de Moraes Holschuh wrote:
> On Mon, 06 Aug 2007, Toralf Förster wrote:
> > Am Montag, 6. August 2007 00:29 schrieb Pavel Machek:
> > > Yes, I seen similar reports. Does it happen in all shutdown mode and
> > > 2.6.22? Does it happen   in platform mode in 2.6.19?
> > 
> > I can reproduce this behaviour by doing the following with kernel 2.6.20 :
> > 
> > 1. <Fn>+<F4>   - the systems sleeps within RAM
> > 2. <Fn>             - the systems wakes up
> > 3. <Fn>+<F12> - the systems hibernates to disk
> > 4. <power>       - systems wakes up
> > 5. <Fn>+<F4>   - the systems sleeps within RAM
> > 
> > Now pressing <Fn> doesn't wake up the system, I have to press the power button
> > for that instead.
> 
> The resume path for suspend to disk is very different (for the firmware, at
> least) than the resume path from sleep-to-RAM.  One of them goes through a
> system shutdown and cold boot (S5) or whatever-boot (S4 - who knows if it is
> the same as a cold boot in a given thinkpad model? It doesn't have to be!).
> 
> The firmware *knows* when you press Fn+F4/FN+F12, and recalls that. That's
> why you can't get multiple hot key presses from pressing Fn+F4 or FN+F12
> until you actually do an ACPI wake-up.
> 
> While you are just doing S3, all that state is preserved without fuss. But
> S5 does not preserve anything, and S4 is anyone's guess.  Numerous thinkpad
> BIOS fixes in the past were releated to such problems, so if you are not
> using the latest BIOS for your model, your first duty is to upgrade it and
> try again.
> 
> IMHO, probably some ACPI state is being lost by the BIOS because of the
> sleep-to-disk.  I don't know how sleep-to-disk plays with the ACPI NV areas,
> and ACPI data areas from the BIOS, so I can't help much there.

We have the problem that ACPI is already initialized by the boot kernel before
the hibernation image is loaded, so there's a chance that the saved state
information will be lost.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
