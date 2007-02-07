Return-Path: <linux-kernel-owner+w=401wt.eu-S1161416AbXBGXtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161416AbXBGXtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 18:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161482AbXBGXtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 18:49:04 -0500
Received: from averell.tiscali.it ([213.205.33.55]:44322 "EHLO
	averell.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161416AbXBGXtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 18:49:01 -0500
Date: Thu, 8 Feb 2007 00:48:37 +0100
From: Luca Tettamanti <kronos@people.it>
To: James Simmons <jsimmons@infradead.org>
Cc: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Message-ID: <20070207234837.GA27822@dreamland.darkstar.lan>
References: <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com> <20070128162907.370f5476.akpm@osdl.org> <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com> <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com> <20070130203301.GA15067@dreamland.darkstar.lan> <20070204201713.GA12867@dreamland.darkstar.lan> <cb7bb73a0702041317u4ca2fbabp45cf56526e57c982@mail.gmail.com> <20070205201824.GA13431@dreamland.darkstar.lan> <cb7bb73a0702051328n50c889d9o461ac2bb9f9ea75e@mail.gmail.com> <Pine.LNX.4.64.0702062118450.9224@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702062118450.9224@pentafluge.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Tue, Feb 06, 2007 at 09:22:00PM +0000, James Simmons ha scritto: 
> 
> > On 2/5/07, Luca Tettamanti <kronos@people.it> wrote:
> > > get-edid uses the BIOS, while the other two talk directly over the I2C
> > > bus.
> > > 
> > > Try loading i2c-dev (I2C_CHARDEV); With i2cdump[1] you can read the EDID
> > > block, which resides at address 0x50:
> > > 
> > > i2cdump N 0x50 (where N is the bus number)
> > > 
> > > If you are unshure about bus number try with all the available
> > > /dev/i2c-* devices (you may want to unload HW monitor drivers first, so
> > > you don't poke at random stuff).
> > 
> > No luck. i2c-dev and dependencies are loaded
> > """ lsmod | grep i2c reports """
> > i2c_i801                7404  0
> > i2c_isa                 5152  0
> > i2c_piix4               8140  0
> > i2c_algo_pcf            6180  0
> > i2c_algo_pca            5380  0
> > i2c_algo_bit            8424  0
> > i2c_dev                 8548  0
> > i2c_core               19680  7
> > i2c_i801,i2c_isa,i2c_piix4,i2c_algo_pcf,i2c_algo_pca,i2c_algo_bit,i2c_dev
> > """"
> > 
> > There is no such thing as /dev/i2c* UNLESS I load nvidiafb. When I
> > load that, I get three busses (i2c-0, -1, and -2), but i2cdump N 0x50
> > gives me a nice tableau of X's all around, for all values of N. This
> > is using kernel 2.6.18-3 stock Debian kernel. I'll keep trying with
> > some variations, to see if I can get more sensible information.
> 
> There is no stand alone nvidia card i2c driver. Its the issue of sharing 
> device interfaces with the same hardware problem again!!! 

Nah, nvidiafb registers the I2C busses, you can drive them with whatever
you want through the devices exported by I2C core.
The fact the none of them work makes me think that the EDID is coming
from the BIOS, we do VBE calls in real mode during early kernel setup.

Luca
-- 
Se non sei parte della soluzione, allora sei parte del problema.
