Return-Path: <linux-kernel-owner+w=401wt.eu-S934760AbXEHIme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760AbXEHIme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934665AbXEHImd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:42:33 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:41026 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934622AbXEHImc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:42:32 -0400
X-Originating-Ip: 72.143.66.196
Date: Tue, 8 May 2007 04:41:58 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Create a top-level "Space-critical features" menu.
In-Reply-To: <1178612519.3042.294.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705080431110.13403@localhost.localdomain>
References: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
 <1178612519.3042.294.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_GL 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Thomas Gleixner wrote:

> On Tue, 2007-05-08 at 04:06 -0400, Robert P. J. Day wrote:
> >   i've always hated that lower-level menu under "General setup":
>
> Good reason to break everything which depends on CONFIG_EMBEDDED.
>
> 	tglx
>
> > -menuconfig EMBEDDED
> > -	bool "Configure standard kernel features (for small systems)"

ah, now i see what you're getting at here:

$ grep EMBEDDED $(find . -name Kconfig\*)
./drivers/pcmcia/Kconfig:       select CARDBUS if !EMBEDDED
./drivers/pcmcia/Kconfig:       bool "Special initialization for O2Micro bridges" if EMBEDDED
./drivers/pcmcia/Kconfig:       bool "Special initialization for Ricoh bridges" if EMBEDDED
./drivers/pcmcia/Kconfig:       bool "Special initialization for TI and EnE bridges" if EMBEDDED
./drivers/pcmcia/Kconfig:       bool "Auto-tune EnE bridges for CB cards" if EMBEDDED
./drivers/pcmcia/Kconfig:       bool "Special initialization for Toshiba ToPIC bridges" if EMBEDDED
./drivers/ata/Kconfig:  depends on EMBEDDED || ARCH_RPC
./drivers/acpi/Kconfig: bool "Power Management Timer Support" if EMBEDDED
./drivers/ide/Kconfig:  depends on ALPHA || SUPERH || IA64 || EMBEDDED
... snip ...

  in my opinion, the config option "EMBEDDED" is just plain silly.  as
i mentioned earlier, there may be other reasons that people want to
de-activate normally selected features rather than just for strictly
embedded systems.

  here's an example:

drivers/input/keyboard/Kconfig:
...
menuconfig INPUT_KEYBOARD
        bool "Keyboards" if EMBEDDED || !X86
        default y
...

  so i should only be allowed to de-activate keyboard support if i
claim i'm working on an "embedded" system?  that's absurd.  maybe it's
a 64-CPU monster server that just happens to be running headless and
needs no keyboard.  making that selection dependent on EMBEDDED is
just silly in that case.

  anyway, must pack up and dash off for a few hours, but i'm hoping
you can see my point.  i don't disagree that there should be a way to
de-select normally selected features.  i just think the way it's being
done now is hideously misnamed.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
