Return-Path: <linux-kernel-owner+w=401wt.eu-S1765152AbXE2UkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765152AbXE2UkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758931AbXE2UkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:40:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37337 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384AbXE2UkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:40:13 -0400
Subject: Re: BUG in 2.6.22-rc2-mm1: Parts of Alsa sound architecture broken
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>
In-Reply-To: <Pine.LNX.4.61.0705292212120.11140@yvahk01.tjqt.qr>
References: <20070524200052.234330@gmx.net>
	 <20070524130921.8dbd3777.akpm@linux-foundation.org>
	 <s5hiragopsx.wl%tiwai@suse.de>
	 <20070525102806.77ee9c0c.akpm@linux-foundation.org>
	 <s5h1wh4si5l.wl%tiwai@suse.de>
	 <Pine.LNX.4.61.0705261248150.7344@yvahk01.tjqt.qr>
	 <s5hveebziom.wl%tiwai@suse.de>
	 <Pine.LNX.4.61.0705292212120.11140@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 May 2007 17:39:06 -0300
Message-Id: <1180471146.9509.115.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Ter, 2007-05-29 às 22:18 +0200, Jan Engelhardt escreveu:
> On May 29 2007 18:41, Takashi Iwai wrote:
> >
> >Well, I find the change of CONFIG_SND to menuconfig is fine, too.
> >But CONFIG_SND_PCI_DRIVERS and others don't make much sense to me.
> >How is it useful at all?
> 
> Hah, I just tell you some of my own experience.
> In summer 2003, I bought the last new machine, and it got these
> shiny new ports they like to call USB. :)
> I did not have much use for it, but I left it on - you never know
> what standard next is the big win of the decade. And actually,
> it did not took long (well, summer 2005) to get my first USB device.
> Still, I am hell as sure I do not have USB-based sound devices
> anytime soon, so it would be cool to deactivate the whole usbsound
> menu at once. I think I said that in the patch description, did not I?

For me, this seems to be a good idea. Makes clear to users what is
inside each menu, improving their notion on what should be deactivated.

> >Anyway, I'd like to confirm that this really works before merging to
> >the ALSA tree.  As Mauro suspected, kconfig seems not working as
> >expected...
> 
> Unfortunately, there are sometimes non-visible options in menus (the
> Networking>QoS menu for example) that, when converted to menuconfig-if-endif,
> also get lost when the menuconfig object is deactivated. In case of QoS, this
> can break compilation. For most subsystems however, it works alright because
> the particular subsystem referencing CONFIG_INVISIBLE_THING is deactivated
> anyway and does not get compiled.
> Such strange menus (like QoS) have not been menuconfigized so far, it's just
> too hard to keep the bits together. As far as other subsystems are concerned,
> please give it some testing.

Hmm... probably, this is what happened with V4L: there are several
invisible items there for selecting some core items.

In the case of V4L, the problem is that, when the menu item is
activated, sometimes, kconfig doesn't properly honor module/static link
heritage.

 
Cheers,
Mauro

