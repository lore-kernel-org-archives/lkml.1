Return-Path: <linux-kernel-owner+w=401wt.eu-S1751224AbXBMJZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbXBMJZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbXBMJZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:25:44 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:41779 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbXBMJZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:25:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KnG59rNGfws/H5s5Tltb6vq4apJ0ayLyGwlMjF+8a3aNFGAhxlY0+iUdwWgPMksc/Wz+9GQIzzdVprVY1EB5I+4olBz/++2BOPuV5bn8jMfwcMHDDhg7BLjfskL8zghdp60ULIkDCe1I/g5fIIY0C9CjRFZP4u2gLCklfNspDhY=
Message-ID: <cb7bb73a0702130125r25ddfe33na48ae673d5ce60ae@mail.gmail.com>
Date: Tue, 13 Feb 2007 10:25:41 +0100
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Luca Tettamanti" <kronos@people.it>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: "James Simmons" <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@osdl.org>, "Dave Airlie" <airlied@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070211181743.GA15801@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
	 <20070130203301.GA15067@dreamland.darkstar.lan>
	 <20070204201713.GA12867@dreamland.darkstar.lan>
	 <cb7bb73a0702041317u4ca2fbabp45cf56526e57c982@mail.gmail.com>
	 <20070205201824.GA13431@dreamland.darkstar.lan>
	 <cb7bb73a0702051328n50c889d9o461ac2bb9f9ea75e@mail.gmail.com>
	 <Pine.LNX.4.64.0702062118450.9224@pentafluge.infradead.org>
	 <20070207234837.GA27822@dreamland.darkstar.lan>
	 <cb7bb73a0702071619p5984c39fs16e3d05c11d45585@mail.gmail.com>
	 <20070211181743.GA15801@dreamland.darkstar.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(some of you might get this mail in double copy , sorry)

On 2/11/07, Luca Tettamanti <kronos@people.it> wrote:
> Sorry for the delay.

Ditto!

It also seemed that my kernel compiling sk1llz had gone AWL, I
couldn't get the newly compiled kernel to run, until I realized the
initrd.img was mislinked. Anyway.

Your patch has an immediately visible effect of reducing snow: it
seems that now that you fixed the access bug the EDID is properly
/not/ used. dmesg | grep nvidiafb now claims the following:

"""

nvidiafb: Device ID: 10de0112
nvidiafb 0000:01:00.0: Unable to read EDID block.
nvidiafb 0000:01:00.0: Unable to read EDID block.
nvidiafb 0000:01:00.0: Unable to read EDID block.

(it actually gave the "I2C probe failed ..." message on console, but
it's not appearing in the dmesg, obviously, since it's a simple
printk)

nvidiafb 0000:01:00.0: Unable to read EDID block.
nvidiafb 0000:01:00.0: Unable to read EDID block.
nvidiafb 0000:01:00.0: Unable to read EDID block.
nvidiafb: CRTC 1 is currently programmed for DFP
nvidiafb: Using DFP on CRTC 1
nvidiafb: Panel size is 1600 x 1200
nvidiafb: Panel is TMDS
nvidiafb: MTRR set to ON
nvidiafb: Flat panel dithering disabled
nvidiafb: PCI nVidia NV11 framebuffer (32MB @ 0xE0000000)

"""

So the EDID still seems to be totally inaccessible (which means I
can't really tell why/when/where it's b0rked).

Finally, as I mentioned, console still has a little snow. It's barely
perceptible in common console usage because the monitor is mostly
black, but can get annoying with fullscreen apps à la mc.

This extra snow *might* be the effect of bandwidth limits Antonino
Daplas was referring to in this lkml message:
http://lkml.org/lkml/2005/10/1/7 but I'll have to enquire on this
further.

-- 
Giuseppe "Oblomov" Bilotta
