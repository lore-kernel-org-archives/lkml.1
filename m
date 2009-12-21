Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZLUWys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZLUWys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 17:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbZLUWyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 17:54:47 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45776
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813AbZLUWyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 17:54:46 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Brian Gerst <brgerst@gmail.com>
Subject: Re: Why is ARCH m68k hardwired into drivers/net/wan/Makefile?
Date: Mon, 21 Dec 2009 16:54:43 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-16-generic; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200912202342.16806.rob@landley.net> <200912210204.08583.rob@landley.net> <73c1f2160912210648j2a8790b6ue611503ef931a77b@mail.gmail.com>
In-Reply-To: <73c1f2160912210648j2a8790b6ue611503ef931a77b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912211654.43710.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 December 2009 08:48:31 Brian Gerst wrote:
> On Mon, Dec 21, 2009 at 3:04 AM, Rob Landley <rob@landley.net> wrote:
> > On Monday 21 December 2009 01:06:38 Brian Gerst wrote:
> >> On Mon, Dec 21, 2009 at 12:42 AM, Rob Landley <rob@landley.net> wrote:
> >> > Anyone have an opinion on this?
> >> >
> >> > From drivers/net/wan/Makefile:
> >> >>ifeq ($(ARCH),m68k)
> >> >>  AS68K = $(AS)
> >> >>  LD68K = $(LD)
> >> >>else
> >> >>  AS68K = as68k
> >> >>  LD68K = ld68k
> >> >>endif
> >>
> >> Looks like it's to build firmware to run on the card.
> >
> > Sure, I'm just wondering why such obvious arch-specific code is outside
> > the arch/m68k directory.
> >
> > In theory, when you're building for m68k, you supply appropriate AS and
> > LD values already (or the rest of the kernel won't build).  If you're not
> > building for m68k and this driver only supports m68k, then the config
> > should prevent you from selecting it.  So why is on earth is
> > architecture-specific tool selection being done in drivers/net/wan?
>
> The m68k processor that this firmware is being built for is embedded
> on the device, not the main system cpu.  You can have one of these
> cards on any system, not just m68k.
>
> PS. always CC the list with replies.

Happy to, but your message to me didn't cc the list, and I thought cc-ing 
private mail back to the list was impolite.

Explicitly saying somewhere "this card has an onbaord m68k processor even if 
the host doesn't" might be nice.  I eventually figured it out, but neither the 
makefile nor the firmware source actually said the card had an onboard 
processor, and my first glance at the kconfig help text just went "it's code for 
a QUICC processor, that's one of those freescale SoCs isnt it?  I vaguely 
recall booting Linux on one of those back in 2006..."

(Possibly I've been doing a bit too much embedded development lately. :)

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
