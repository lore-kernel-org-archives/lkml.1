Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbYBSAhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbYBSAhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYBSAgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:36:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:53265 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbYBSAgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:36:52 -0500
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] fb: add support for
	foreign	endianness
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Clemens Koller <clemens.koller@anagramm.de>
Cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       Krzysztof Helt <krzysztof.h1@poczta.fm>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <47BA162C.5000807@anagramm.de>
References: <20080205154432.GA8749@localhost.localdomain>
	 <20080214224942.a0cb6218.akpm@linux-foundation.org>
	 <20080215164542.GB16810@localhost.localdomain>
	 <Pine.LNX.4.64.0802171030330.6848@anakin>
	 <20080218081847.e9e65f2f.krzysztof.h1@poczta.fm>
	 <19805.1203355811@turing-police.cc.vt.edu>  <47BA162C.5000807@anagramm.de>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 11:35:53 +1100
Message-Id: <1203381353.6740.59.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-19 at 00:35 +0100, Clemens Koller wrote:
> Valdis.Kletnieks@vt.edu schrieb:
> > On Mon, 18 Feb 2008 08:18:47 +0100, Krzysztof Helt said:
> >> I know two fb drivers which use endianess information (pm2fb and s3c2410fb).
> >> Both resolve endianess at driver level. Actually, both handle it by setting special
> >> bits so the graphics chip itself reorder bytes to transform foreign endianess. 
> >> I understand that this patch is for chips which cannot reorder bytes by themselves.
> > 
> > Does anybody know of such a chip that's actually available in the wild?  Or are
> > we writing drivers for speculative possible chips?
> > 
> 
> I had troubles with the Silicon Motion SM501/SM502 endianess on PowerPC PCI vs. LocalBus.
> The chip also has a register to swap endianess, but that seems to only affect some
> LocalBus modes.
> The current fb and X drivers are working, but when it comes to font
> aliasing and hw-acceleration, the problems start to rise again...

Most "sane" gfx chips nowadays provide configurable surfaces that allow
to perform the swap when writing/reading from regions of the
framebuffer, with the ability to set a different swapper setting (based
on bit depth) per region.

Then there is also the risk that your PCI<->Localbus has been wired
improperly :-)

Ben.


