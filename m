Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbXFLUfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbXFLUfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 16:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbXFLUe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 16:34:58 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:2978 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbXFLUe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 16:34:57 -0400
Date: Tue, 12 Jun 2007 22:34:56 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David Schwartz <davids@webmaster.com>
cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: PC speaker
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEHOEIAC.davids@webmaster.com>
Message-ID: <Pine.LNX.4.64.0706122223350.19578@fbirervta.pbzchgretzou.qr>
References: <MDEHLPKNGKAHNMBLJOLKKEHOEIAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 12 2007 13:08, David Schwartz wrote:
>
>As far as burning out a speaker goes, if you can drop the frequency to zero
>(DC) and get continuous current through the speaker, that could burn it out.
>This makes several assumptions, many of which may not be true on modern PCs:
>
>1) It assumes the speaker is a conventional coil speaker, not a piezo
>element. (This is certainly true on some PCs, although it's increasingly
>false on newer PCs.)
>
>2) It assumes the speaker is DC driven. (I'm pretty sure this was true on
>the original IBM PC. Not sure about newer computers.)

Most likely. AC is hardly any good inside a computer :)

>3) It assumes you can configure the circuitry that drives the speaker such
>that it will stay on. (No idea.)

A crystal will drive the frequency, which can be set with outb(0x42).
Whether the crystal's oscillating signal is connected to the speaker
can be controlled with outb(0x61) IIRC [or just see
drivers/input/misc/pcspkr.c].

>4) It assumes the current will be sufficient to burn out the speaker. (I
>know it will get very hot on older machines, whether it will burn out --
>might even depend on the exact speaker model.)

Since you can set the x86's crystals frequency from 1193182 to 18 Hz
(PIT_TICK_RATE / 1 to PIT_TICK_RATE / 65535) [*], you can never really
bust it. But even then, what would a speaker do it was constanly given
+5V? (I _suppose_ the other level is 0V, not -5V -- makes for easy 
design.) That's IMO just like a sound file with volume(x) = 1, nothing 
spectacular if you ask me.

[*] The line "if (value > 20 && value < 32767) in pcspkr.c looks a bit bogus.


>On at least some older computers, you could burn out the hardware that
>drove the speaker this way. I think it was either the Pet or the Apple
>][ (didn't work on all machines, depended on how much current the
>speaker drew and other odd factors). I witnessed an Apple ][e blow out
>an I/O chip when it crashed with an output (that was supposed to be
>pulsed) left in the on position.


	Jan
-- 
