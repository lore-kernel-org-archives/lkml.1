Return-Path: <linux-kernel-owner+w=401wt.eu-S1761618AbYFIXm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618AbYFIXm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 19:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761186AbYFIXlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 19:41:45 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:60368 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760815AbYFIXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 19:41:44 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200806092341.m59NfOFu022668@turbo.physics.adelaide.edu.au>
Subject: Re: [PATCH] Fujitsu U810 keyboard light support
To: jules@panic.cs-bristol.org.uk (Julian Brown)
Date: Tue, 10 Jun 2008 09:11:24 +0930 (CST)
Cc: linux-kernel@vger.kernel.org,
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe)
In-Reply-To: <20080608204948.GA22405@panic.cs-bristol.org.uk> from "Julian Brown" at Jun 08, 2008 09:49:48 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julian

Thanks for your patch.

> This patch contains support for the Fujitsu U810 mini-laptops'
> keyboard-illuminating "headlights". Information on how to control these
> was reverse-engineered from the ACPI DSDT and from disassembling the
> Windows driver for the device (i.e. it's not 100% certain that this
> patch won't make your laptop explode, but it works for me. A more likely
> problem is that I might have broken support for other Fujitsu laptops,
> but I can't test that).
> 
> The patched fujitsu-laptop module creates two entities in the /sys
> hierarchy:
> 
>   /sys/devices/platform/fujitsu-laptop/kbd_light
>   /sys/class/leds/kbd_light/*
> 
> So that then, the lights can be controlled by reading/writing to these
> files. (Probably not all the LED class things are relevant, though).
> 
> The fujitsu-laptop module before patching only uses the FUJ02B1 ACPI "HID"
> (namespace? Identifier?), but the keyboard LEDs (as well as several other
> possibly-interesting things) hang off the FUJ02E3 ("FEXT") HID. I'm not
> sure if adding the latter to the existing driver (vs. creating a new one)
> was the right thing to do, but I think it's probably sensible.
> 
> Any comments/suggestions?

There is a later version of the fujitsu-laptop module floating around the
linux-acpi list (v0.4.1) which I have submitted for inclusion in the next
merge window.  This version adds support additional backlight controls used
on some Fujitsu laptops, and for some of the fujitsu hotkeys.  The latter is
done using the FUJ02E3 HID.  It has been extensively tested on the fujitsu
laptops we currently have access to.  As it stands your current patch will
clash horribly with the new fujitsu-laptop version.

IMHO the easiest way forward would be for you to rebase your patch against
this newer fujitsu-laptop version and see where things go from there.  As
maintainer of the fujitsu-laptop module I would rather get the current
well-tested hotkeys/backlight code in and use that as the base for your
"headlights" patch.  That way we can build on the work that's already been
done rather than reinventing the wheel (so to speak).  You'll find the patch
on the linux-acpi list - contact me off-list if you can't locate it.

FYI the fujitsu-laptop development generally happens through the linux-acpi
subsystem/list.

Regards
  jonathan
