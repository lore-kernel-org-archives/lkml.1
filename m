Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbXEHUWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbXEHUWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbXEHUW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:22:28 -0400
Received: from waste.org ([66.93.16.53]:52604 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbXEHUW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:22:26 -0400
Date: Tue, 8 May 2007 15:22:15 -0500
From: Matt Mackall <mpm@selenic.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Create a top-level "Space-critical features" menu.
Message-ID: <20070508202215.GV11166@waste.org>
References: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain> <1178612519.3042.294.camel@localhost.localdomain> <Pine.LNX.4.64.0705080431110.13403@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705080431110.13403@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 04:41:58AM -0400, Robert P. J. Day wrote:
> On Tue, 8 May 2007, Thomas Gleixner wrote:
> 
> > On Tue, 2007-05-08 at 04:06 -0400, Robert P. J. Day wrote:
> > >   i've always hated that lower-level menu under "General setup":
> >
> > Good reason to break everything which depends on CONFIG_EMBEDDED.
> >
> > 	tglx
> >
> > > -menuconfig EMBEDDED
> > > -	bool "Configure standard kernel features (for small systems)"
> 
> ah, now i see what you're getting at here:
> 
> $ grep EMBEDDED $(find . -name Kconfig\*)
> ./drivers/pcmcia/Kconfig:       select CARDBUS if !EMBEDDED
> ./drivers/pcmcia/Kconfig:       bool "Special initialization for O2Micro bridges" if EMBEDDED
> ./drivers/pcmcia/Kconfig:       bool "Special initialization for Ricoh bridges" if EMBEDDED
> ./drivers/pcmcia/Kconfig:       bool "Special initialization for TI and EnE bridges" if EMBEDDED
> ./drivers/pcmcia/Kconfig:       bool "Auto-tune EnE bridges for CB cards" if EMBEDDED
> ./drivers/pcmcia/Kconfig:       bool "Special initialization for Toshiba ToPIC bridges" if EMBEDDED
> ./drivers/ata/Kconfig:  depends on EMBEDDED || ARCH_RPC
> ./drivers/acpi/Kconfig: bool "Power Management Timer Support" if EMBEDDED
> ./drivers/ide/Kconfig:  depends on ALPHA || SUPERH || IA64 || EMBEDDED
> ... snip ...
> 
>   in my opinion, the config option "EMBEDDED" is just plain silly.  as
> i mentioned earlier, there may be other reasons that people want to
> de-activate normally selected features rather than just for strictly
> embedded systems.
> 
>   here's an example:
> 
> drivers/input/keyboard/Kconfig:
> ...
> menuconfig INPUT_KEYBOARD
>         bool "Keyboards" if EMBEDDED || !X86
>         default y
> ...
> 
>   so i should only be allowed to de-activate keyboard support if i
> claim i'm working on an "embedded" system?  that's absurd.  maybe it's
> a 64-CPU monster server that just happens to be running headless and
> needs no keyboard.  making that selection dependent on EMBEDDED is
> just silly in that case.

No, turning off keyboard on your 64-CPU monster server to save ~10k is
the thing that's absurd. More importantly, it's a support headache
because invariably someone will try to plug a keyboard in and complain
to us when it mysteriously doesn't work. If memory serves, Linus
himself did exactly that shortly after the current input layer was
merged.

-- 
Mathematics is the supreme nostalgia of our time.
