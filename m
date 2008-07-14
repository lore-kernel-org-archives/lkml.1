Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYGNLWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYGNLWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 07:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYGNLWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 07:22:37 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54369 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636AbYGNLWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 07:22:36 -0400
X-Sasl-enc: uJpJ6o/qeQHnQMXWojddXx+Fau2UsNlRlpzB2vb/vR7S 1216034554
Date: Mon, 14 Jul 2008 08:22:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andy Lutomirski <luto@myrealbox.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Message-ID: <20080714112229.GA20593@khazad-dum.debian.net>
References: <48793A0E.3050803@myrealbox.com> <200807130133.12324.rjw@sisk.pl> <20080713091524.GA29907@elte.hu> <20080713120253.GA27582@srcf.ucam.org> <487A2431.2050103@myrealbox.com> <487A4CB7.1080001@firstfloor.org> <487A62B3.8010207@zytor.com> <487A63D2.9040006@firstfloor.org> <20080714012206.GA11882@khazad-dum.debian.net> <20080714061429.GF20258@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714061429.GF20258@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Pavel Machek wrote:
> On Sun 2008-07-13 22:22:06, Henrique de Moraes Holschuh wrote:
> > On Sun, 13 Jul 2008, Andi Kleen wrote:
> > > It probably switches to protected mode. I noticed this on my old
> > > Fujitsu laptop when I tried to make the S3 wakeup run in the s2ram x86 emulator
> > > and found it entered protected mode at some point, which x86emu
> > > didn't support.
> > > 
> > > I guess Lenovo is doing the same.
> > > 
> > > And that protected mode code relies on some GDT values that have been
> > > loaded earlier when the BIOS also went into protected mode.
> > > 
> > > It seems the BIOS programmers really don't like real mode anymore.
> > > Somehow understandable.
> > 
> > If it were just Lenovo, it shouldn't be too difficult to get them to fix the
> > BIOS.  But since other vendors have the same problem, that won't fly as a
> > solution.
> 
> With all the BIOSes in field, practically impossible to update? (My
> x60 has no CDrom..) No, I don't think we can expect fix from BIOS vendors.

I explicitly said it wouldn't fly as a solution, because I doubt we could
expect a fix from EVERY BIOS vendor that has such problems.  That sort of
account for machines that have not been updated, too.

But I do think "your BIOS is broken and there is an update available from
the vendor, apply it" *IS* a valid response if a workaround is not
desireable for some reason (e.g. it is too complex, or it would make the
kernel worse for a lot of others that did things right and don't have the
bug).  I don't think we need to fear that happening on this particular
issue, but still...

As for your X60, you can use a USB mass storage device like a pendrive.
Someone already did all the hard work:
http://thinkwiki.org/wiki/BIOS_Upgrade/X_Series

In fact, as I rule, I cannot recommend using anything but the latest BIOS
and EC releases on a ThinkPad.  That thing is too complex to live without
updates, just like the kernel (even if, just like the kernel, upgrading the
BIOS and EC can cause new bugs).  Look at the changelog for your X60 BIOS
and EC firmware at
http://www-307.ibm.com/pc/support/site.wss/MIGR-65345.html.  It has some
scary stuff fixed, and that's just what Lenovo decided to disclose, those
changelogs are NOT complete and often fail to list changes that are of
interest to Linux (such as fixes to the ACPI tables).

In fact, look at this interesting entry on the X60 BIOS changelog:
Version 7BETD3WW (2.14):
	(Fix) Memory address more than 4GB can't be accessed under Vista
	WindowsPE. (BIOS)

It is also listed for the X61 and the tablets on their BIOS updates.  Maybe
that 4GB change could be related to the issue at hand?

It would be nice to get a report on the Big Realmote patch, and also know
the BIOS version of ThinkPads that have (and don't have) the bug.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
