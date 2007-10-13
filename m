Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbXJMSqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbXJMSqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762474AbXJMSqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:46:09 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57859
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761119AbXJMSqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:46:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [patch 7/8] b43 wireless needs <linux/io.h>
Date: Sat, 13 Oct 2007 20:45:20 +0200
User-Agent: KMail/1.9.6
Cc: Larry Finger <larry.finger@lwfinger.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20071013123123.085686856@mail.of.borg> <4710E2C6.5090302@lwfinger.net> <Pine.LNX.4.64.0710132027410.15951@anakin>
In-Reply-To: <Pine.LNX.4.64.0710132027410.15951@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710132045.20787.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 October 2007 20:38:43 Geert Uytterhoeven wrote:
> On Sat, 13 Oct 2007, Larry Finger wrote:
> > Geert Uytterhoeven wrote:
> > > linux/drivers/net/wireless/b43/pio.h: In function 'b43_pio_write':
> > > linux/drivers/net/wireless/b43/pio.h:89: error: implicit declaration of function 'mmiowb'
> > >
> > > linux/drivers/net/wireless/b43/phy.c: In function 'b43_phy_write':
> > > linux/drivers/net/wireless/b43/phy.c:301: error: implicit declaration of function 'mmiowb'
> > >
> > > linuxdrivers/net/wireless/b43/sysfs.c: In function 'b43_attr_interfmode_store':
> > > linuxdrivers/net/wireless/b43/sysfs.c:147: error: implicit declaration of function 'mmiowb'
> > 
> > From the distribution list for this E-mail, I presume this error occurred for m68k. Is this correct?
> 
> That's correct.
> 
> > If so, I will probably need to prepare a similar patch for b43legacy.
> 
> I had no problems compiling b43legacy on m68k, though. Probably
> <linux/io.h> was included through some other include file.
> Of course it's safer to always #include <linux/io.h> when using I/O.
> 
> During linking, I did get a bunch of `undefined reference to `dma_*''
> errors, with both b43 and b43legacy (and a few other drivers). Probably
> they need to depend on HAS_DMA.
> I'll post separate patches for those after I've sorted them out.

We could make the b43 and b43legacy DMA engine code depend on HAS_DMA
then. So it can still be compiled with PIO. (Though, I don't know if
anybody would put such a card into a machine without DMA, anyway).

The DMA engine code is a seperate kconfig option.

-- 
Greetings Michael.
