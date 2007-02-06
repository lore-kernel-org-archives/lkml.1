Return-Path: <linux-kernel-owner+w=401wt.eu-S965515AbXBFVWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965515AbXBFVWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965518AbXBFVWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:22:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47532 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965515AbXBFVWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:22:05 -0500
Date: Tue, 6 Feb 2007 21:22:00 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
cc: Luca Tettamanti <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
In-Reply-To: <cb7bb73a0702051328n50c889d9o461ac2bb9f9ea75e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702062118450.9224@pentafluge.infradead.org>
References: <ephv35$4i3$1@sea.gmane.org>  <20070128160831.fb51347f.akpm@osdl.org>
  <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com> 
 <20070128162907.370f5476.akpm@osdl.org>  <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
  <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com> 
 <20070130203301.GA15067@dreamland.darkstar.lan>  <20070204201713.GA12867@dreamland.darkstar.lan>
  <cb7bb73a0702041317u4ca2fbabp45cf56526e57c982@mail.gmail.com> 
 <20070205201824.GA13431@dreamland.darkstar.lan>
 <cb7bb73a0702051328n50c889d9o461ac2bb9f9ea75e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On 2/5/07, Luca Tettamanti <kronos@people.it> wrote:
> > get-edid uses the BIOS, while the other two talk directly over the I2C
> > bus.
> > 
> > Try loading i2c-dev (I2C_CHARDEV); With i2cdump[1] you can read the EDID
> > block, which resides at address 0x50:
> > 
> > i2cdump N 0x50 (where N is the bus number)
> > 
> > If you are unshure about bus number try with all the available
> > /dev/i2c-* devices (you may want to unload HW monitor drivers first, so
> > you don't poke at random stuff).
> 
> No luck. i2c-dev and dependencies are loaded
> """ lsmod | grep i2c reports """
> i2c_i801                7404  0
> i2c_isa                 5152  0
> i2c_piix4               8140  0
> i2c_algo_pcf            6180  0
> i2c_algo_pca            5380  0
> i2c_algo_bit            8424  0
> i2c_dev                 8548  0
> i2c_core               19680  7
> i2c_i801,i2c_isa,i2c_piix4,i2c_algo_pcf,i2c_algo_pca,i2c_algo_bit,i2c_dev
> """"
> 
> There is no such thing as /dev/i2c* UNLESS I load nvidiafb. When I
> load that, I get three busses (i2c-0, -1, and -2), but i2cdump N 0x50
> gives me a nice tableau of X's all around, for all values of N. This
> is using kernel 2.6.18-3 stock Debian kernel. I'll keep trying with
> some variations, to see if I can get more sensible information.

There is no stand alone nvidia card i2c driver. Its the issue of sharing 
device interfaces with the same hardware problem again!!! There is a patch 
for DRI and fbdev but it really looks like we need a generic solution.
 
