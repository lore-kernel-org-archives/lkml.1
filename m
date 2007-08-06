Return-Path: <linux-kernel-owner+w=401wt.eu-S933848AbXHFPDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848AbXHFPDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932768AbXHFPDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:03:38 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37951 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932580AbXHFPDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:03:37 -0400
X-Sasl-enc: XUM9HOLyteS2OOSniwUHs1l6krQZxgUmBPQuIwng71cF 1186412615
Date: Mon, 6 Aug 2007 12:03:32 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       Pavel Machek <pavel@ucw.cz>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: suspend/hibernation regression between 2.6.19 and 2.6.20 w/
	Thinkpad T41
Message-ID: <20070806150332.GD31615@khazad-dum.debian.net>
References: <200708051902.18801.toralf.foerster@gmx.de> <200708061136.50491.toralf.foerster@gmx.de> <20070806143631.GB31615@khazad-dum.debian.net> <200708061656.17027.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708061656.17027.rjw@sisk.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2007, Rafael J. Wysocki wrote:
> On Monday, 6 August 2007 16:36, Henrique de Moraes Holschuh wrote:
> > On Mon, 06 Aug 2007, Toralf Förster wrote:
> > > Am Montag, 6. August 2007 00:29 schrieb Pavel Machek:
> > > > Yes, I seen similar reports. Does it happen in all shutdown mode and
> > > > 2.6.22? Does it happen   in platform mode in 2.6.19?
> > > 
> > > I can reproduce this behaviour by doing the following with kernel 2.6.20 :
> > > 
> > > 1. <Fn>+<F4>   - the systems sleeps within RAM
> > > 2. <Fn>             - the systems wakes up
> > > 3. <Fn>+<F12> - the systems hibernates to disk
> > > 4. <power>       - systems wakes up
> > > 5. <Fn>+<F4>   - the systems sleeps within RAM
> > > 
> > > Now pressing <Fn> doesn't wake up the system, I have to press the power button
> > > for that instead.
> > 
> > The resume path for suspend to disk is very different (for the firmware, at
> > least) than the resume path from sleep-to-RAM.  One of them goes through a
> > system shutdown and cold boot (S5) or whatever-boot (S4 - who knows if it is
> > the same as a cold boot in a given thinkpad model? It doesn't have to be!).
> > 
> > The firmware *knows* when you press Fn+F4/FN+F12, and recalls that. That's
> > why you can't get multiple hot key presses from pressing Fn+F4 or FN+F12
> > until you actually do an ACPI wake-up.
> > 
> > While you are just doing S3, all that state is preserved without fuss. But
> > S5 does not preserve anything, and S4 is anyone's guess.  Numerous thinkpad
> > BIOS fixes in the past were releated to such problems, so if you are not
> > using the latest BIOS for your model, your first duty is to upgrade it and
> > try again.
> > 
> > IMHO, probably some ACPI state is being lost by the BIOS because of the
> > sleep-to-disk.  I don't know how sleep-to-disk plays with the ACPI NV areas,
> > and ACPI data areas from the BIOS, so I can't help much there.
> 
> We have the problem that ACPI is already initialized by the boot kernel before
> the hibernation image is loaded, so there's a chance that the saved state
> information will be lost.

Yeah.  Big bad design issue right there.  And not one that is even remotely
easy to "fix", AFAIK.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
