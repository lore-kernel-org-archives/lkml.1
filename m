Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYAPUTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYAPUTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYAPUT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:19:26 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:31138 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYAPUTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:19:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j13pbkQX48Sd+v7f10bLARdhVE3Pfw2A6oZVmaPpN/5KkvubZqeRgpO6YuJ9JUnMXUV1h5sOEBOEY378q/FS6jJo5Dbu/EzoHUORq39SMxh/158MyeiCuT2GhnCHGoTpijzTiHYRWUymksB9CzGlcZcfwXMldbru/FlN213OqAs=
Message-ID: <19f34abd0801161219oe478b50se13c0710759d581f@mail.gmail.com>
Date: Wed, 16 Jan 2008 21:19:23 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [BISECTED] Re: psmouse.c: GlidePoint at isa0060/serio1/input0 lost sync at byte 1
Cc: linux-input@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Pettersson" <william.pettersson@gmail.com>
In-Reply-To: <20080116142815.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0711141226n60323630rdc4833db0bfb2eeb@mail.gmail.com>
	 <19f34abd0801071224kb9cb121u244b00b274231db0@mail.gmail.com>
	 <d120d5000801110647k4b1fa49ene974898baf745aec@mail.gmail.com>
	 <478CFB56.1030700@gmail.com>
	 <20080115154142.ZZRA012@mailhub.coreip.homeip.net>
	 <20080116104024.ZZRA012@mailhub.coreip.homeip.net>
	 <19f34abd0801160946j2fe1c75ap3617dd125c81008f@mail.gmail.com>
	 <20080116142815.ZZRA012@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 16, 2008 8:33 PM, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Wed, Jan 16, 2008 at 06:46:46PM +0100, Vegard Nossum wrote:
> >
> > I have now tried this patch. I don't see a sync error now, but the
> > button still does not work as expected. Now the scroll down button
> > acts like a middle button instead of scrolling down.
> >
> > I am sorry for the confusion; on my laptop it looks like a single
> > button, but in fact it can be pressed in four different ways (up,
> > down, left, and right). In 2.6.23, pressing left or right, I get the
> > traditional paste functionality. Pressing up or down, it acts like a
> > scroll wheel (up or down). In 2.6.24-rc1, it is the scrolling up/down
> > that causes the lost sync (but the left/right works correctly).
> >
>
> I see. Could you please provide me with another debug log of all
> 4 presses/releases of all the buttons, with the patch applied?
> Do it in the following order please: left, right, middle, up, down.

Ok. Remember, there really is no dedicated middle button (I've been
using left button for this purpose, i.e. pasting in X). Here's the
log. I cannot tell why the first keypress is twice the size of the
rest, maybe I accidentally pressed it twice, though I tried not to.

# left
> drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [121267]
> drivers/input/serio/i8042.c: cf <- i8042 (interrupt, 1, 12) [126078]
> drivers/input/serio/i8042.c: 43 <- i8042 (interrupt, 1, 12) [126081]
> drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [126083]
> drivers/input/serio/i8042.c: 4c <- i8042 (interrupt, 1, 12) [126087]
> drivers/input/serio/i8042.c: 6d <- i8042 (interrupt, 1, 12) [126088]
> drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [126090]
> drivers/input/serio/i8042.c: cf <- i8042 (interrupt, 1, 12) [126447]
> drivers/input/serio/i8042.c: 43 <- i8042 (interrupt, 1, 12) [126450]
> drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [126452]
> drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 1, 12) [126454]
> drivers/input/serio/i8042.c: 6d <- i8042 (interrupt, 1, 12) [126456]
> drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [126460]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [128634]
> drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [128636]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [128737]
> drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [128741]
> drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [129161]
> drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [129267]
> drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 0, 1) [129332]
> drivers/input/serio/i8042.c: 83 <- i8042 (interrupt, 0, 1) [129437]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [130032]
> drivers/input/serio/i8042.c: 4b <- i8042 (interrupt, 0, 1) [130033]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [130518]
> drivers/input/serio/i8042.c: 4b <- i8042 (interrupt, 0, 1) [130521]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [130550]
> drivers/input/serio/i8042.c: 4b <- i8042 (interrupt, 0, 1) [130552]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [130583]
> drivers/input/serio/i8042.c: 4b <- i8042 (interrupt, 0, 1) [130585]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [130614]
> drivers/input/serio/i8042.c: 4b <- i8042 (interrupt, 0, 1) [130616]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [130644]
> drivers/input/serio/i8042.c: 4b <- i8042 (interrupt, 0, 1) [130646]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [130676]
> drivers/input/serio/i8042.c: 4b <- i8042 (interrupt, 0, 1) [130679]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [130708]
> drivers/input/serio/i8042.c: 4b <- i8042 (interrupt, 0, 1) [130710]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [130731]
> drivers/input/serio/i8042.c: cb <- i8042 (interrupt, 0, 1) [130737]
> drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [130992]
> drivers/input/serio/i8042.c: 56 <- i8042 (interrupt, 0, 1) [131098]
> drivers/input/serio/i8042.c: d6 <- i8042 (interrupt, 0, 1) [131274]
> drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 0, 1) [131343]
> drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [131859]

# right
> drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [132001]
> drivers/input/serio/i8042.c: ef <- i8042 (interrupt, 1, 12) [135113]
> drivers/input/serio/i8042.c: 43 <- i8042 (interrupt, 1, 12) [135115]
> drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [135118]
> drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 1, 12) [135120]
> drivers/input/serio/i8042.c: 6d <- i8042 (interrupt, 1, 12) [135122]
> drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [135125]
> drivers/input/serio/i8042.c: cf <- i8042 (interrupt, 1, 12) [135401]
> drivers/input/serio/i8042.c: 43 <- i8042 (interrupt, 1, 12) [135403]
> drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [135406]
> drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 1, 12) [135407]
> drivers/input/serio/i8042.c: 6d <- i8042 (interrupt, 1, 12) [135409]
> drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [135412]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [137074]
> drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [137075]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [137215]
> drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [137218]
> drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [137868]
> drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [138009]
> drivers/input/serio/i8042.c: 04 <- i8042 (interrupt, 0, 1) [138056]
> drivers/input/serio/i8042.c: 84 <- i8042 (interrupt, 0, 1) [138163]
> drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [139036]

# up
> drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [139177]
> drivers/input/serio/i8042.c: cf <- i8042 (interrupt, 1, 12) [142763]
> drivers/input/serio/i8042.c: 43 <- i8042 (interrupt, 1, 12) [142764]
> drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 1, 12) [142767]
> drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 1, 12) [142769]
> drivers/input/serio/i8042.c: 6d <- i8042 (interrupt, 1, 12) [142772]
> drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [142774]
> drivers/input/serio/i8042.c: cf <- i8042 (interrupt, 1, 12) [143002]
> drivers/input/serio/i8042.c: 43 <- i8042 (interrupt, 1, 12) [143004]
> drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [143006]
> drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 1, 12) [143008]
> drivers/input/serio/i8042.c: 6d <- i8042 (interrupt, 1, 12) [143012]
> drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [143013]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [143965]
> drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [143968]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [144103]
> drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [144107]
> drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [144556]
> drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [144699]
> drivers/input/serio/i8042.c: 05 <- i8042 (interrupt, 0, 1) [144777]
> drivers/input/serio/i8042.c: 85 <- i8042 (interrupt, 0, 1) [144881]
> drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [145299]

# down
> drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [145406]
> drivers/input/serio/i8042.c: df <- i8042 (interrupt, 1, 12) [146456]
> drivers/input/serio/i8042.c: 43 <- i8042 (interrupt, 1, 12) [146457]
> drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [146460]
> drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 1, 12) [146462]
> drivers/input/serio/i8042.c: 6d <- i8042 (interrupt, 1, 12) [146465]
> drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [146467]
> drivers/input/serio/i8042.c: cf <- i8042 (interrupt, 1, 12) [146596]
> drivers/input/serio/i8042.c: 43 <- i8042 (interrupt, 1, 12) [146599]
> drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [146601]
> drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 1, 12) [146603]
> drivers/input/serio/i8042.c: 6d <- i8042 (interrupt, 1, 12) [146606]
> drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [146609]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [147496]
> drivers/input/serio/i8042.c: 48 <- i8042 (interrupt, 0, 1) [147499]
> drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [147599]
> drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 0, 1) [147604]
> drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [148123]
> drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [148228]
> drivers/input/serio/i8042.c: 06 <- i8042 (interrupt, 0, 1) [148232]
> drivers/input/serio/i8042.c: 86 <- i8042 (interrupt, 0, 1) [148335]
> drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [150325]


Hope this helps :-) And thanks again.

Vegard
