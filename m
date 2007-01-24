Return-Path: <linux-kernel-owner+w=401wt.eu-S1751063AbXAXKdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063AbXAXKdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 05:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbXAXKdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 05:33:37 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:40730 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbXAXKdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 05:33:36 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 24 Jan 2007 05:33:13 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: identifying CONFIG variable typoes in the source tree
In-Reply-To: <Pine.LNX.4.62.0701240917530.30467@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.64.0701240511300.23168@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701231559090.3014@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.62.0701240917530.30467@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007, Geert Uytterhoeven wrote:

> On Tue, 23 Jan 2007, Robert P. J. Day wrote:
> >   let's check these:
> >
> > $ grep -r 53C700_BE_BUS .
> > ./drivers/scsi/53c700.h:#ifdef CONFIG_53C700_BE_BUS
>
> This is the core support for big endian 53c700 SCSI busses. It's
> needed for various m68k machines, patch to be submitted when the
> m68k support is ready for submission.
>
> Gr{oetje,eeting}s,

  just to be clear, all that script is doing is identifying variables
of the form "CONFIG_fubar" that are being tested in *some*
preprocessor directive somewhere in the tree, but for which there is
apparently no corresponding entry in a Kconfig file anywhere that
could cause that variable to be configured.

  naturally, as geert suggests, this might represent a feature that's
in progress so it's clearly not a mistake.  but it's a good way to
trap potential problems, as in finding "GALILLEO_GT64240_ETH" which,
superficially, would seem like an obvious typo no matter what:

$ grep -r GALILLEO_GT64240_ETH .
./arch/mips/momentum/ocelot_g/prom.c:#ifdef CONFIG_GALILLEO_GT64240_ETH
./arch/mips/momentum/ocelot_g/prom.c:#ifdef CONFIG_GALILLEO_GT64240_ETH
./arch/mips/momentum/ocelot_g/setup.c:#ifdef CONFIG_GALILLEO_GT64240_ETH
./arch/mips/momentum/ocelot_g/setup.c:#ifdef CONFIG_GALILLEO_GT64240_ETH
$

as well as what is *obviously* dead code:

$ grep -rw CONFIG_KERNELD .
./sound/core/timer.c:#ifdef CONFIG_KERNELD
$ grep -rw KERNELD .
./net/core/dev.c: *             Bjorn Ekwall    :       Added KERNELD hack.

  the script isn't perfect -- it will generate false positives if the
variable is being set elsewhere -- perhaps hardcoded in the file or
defined in a Makefile.  but if you're curious, just run it against
your favourite subdirectory and see what comes up.

rday

