Return-Path: <linux-kernel-owner+w=401wt.eu-S1751859AbXBVUjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbXBVUjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbXBVUjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:39:21 -0500
Received: from joe.tiscali.it ([213.205.33.54]:33114 "EHLO joe.tiscali.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbXBVUjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:39:20 -0500
Date: Thu, 22 Feb 2007 21:39:04 +0100
From: Luca Tettamanti <kronos@people.it>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Message-ID: <20070222203904.GA15349@dreamland.darkstar.lan>
References: <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com> <20070128162907.370f5476.akpm@osdl.org> <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com> <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com> <20070130203301.GA15067@dreamland.darkstar.lan> <20070204201713.GA12867@dreamland.darkstar.lan> <Pine.LNX.4.64.0702062034380.9224@pentafluge.infradead.org> <cb7bb73a0702061508x767882dcia1b13f85d898b6e7@mail.gmail.com> <1172101406.4217.16.camel@daplas> <cb7bb73a0702220001u6acbdd95ncdc9fad10d06b421@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb7bb73a0702220001u6acbdd95ncdc9fad10d06b421@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Thu, Feb 22, 2007 at 09:01:52AM +0100, Giuseppe Bilotta ha scritto: 
> On 2/22/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> >On Wed, 2007-02-07 at 00:08 +0100, Giuseppe Bilotta wrote:
> >>
> >> As mentioned in another post in this thread, I can't get any info out
> >> of the i2c busses, because even when I have them available (i.e. after
> >> loading nvidiafb) I get XXXX all around (on all three of them).
> >> Suggestions on how to get the information welcome.
> >
> >Is this the same monitor you posted here?
> >
> >http://marc.theaimsgroup.com/?l=linux-kernel&m=112807065616218&w=2
> >
> >If yes, we already have the manufacturer and model code. The main
> >problem is that the EDID of this display has no sync range (H: 75-75kHz
> >and V: 60-60Hz).  Extending Hsync from 30-75kHz as a fix to the EDID
> >block shouldn't be too hard.
> 
> Yes, that's it! Jeepers, I can't believe that even re-reading the past
> LKML posts (even those!) I couldn't find the EDID info and how we had
> gotten them. I guess I need stronger glasses.
> 
> Wonder why Luca's proposed patch makes the EDID undetectable, now, and
> why can't it be retrieved at a later time via i2c. Timeouts too small?

Still scratching my head :|

Tony,
this is the patch (modulo cosmetic stuff) that I sent to Giuseppe. I
believe it's correct (I cross checked with X.org driver):

diff --git a/drivers/video/nvidia/nv_i2c.c b/drivers/video/nvidia/nv_i2c.c
index b858897..7e64341 100644
--- a/drivers/video/nvidia/nv_i2c.c
+++ b/drivers/video/nvidia/nv_i2c.c
@@ -70,8 +70,6 @@ static int nvidia_gpio_getscl(void *data)
 	if (VGA_RD08(par->PCIO, 0x3d5) & 0x04)
 		val = 1;
 
-	val = VGA_RD08(par->PCIO, 0x3d5);
-
 	return val;
 }
 

Luca
-- 
Non sempre quello che viene dopo e` progresso.
Alessandro Manzoni
