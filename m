Return-Path: <linux-kernel-owner+w=401wt.eu-S1765022AbXE2UWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765022AbXE2UWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbXE2UWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:22:24 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:60997 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbXE2UWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:22:23 -0400
Date: Tue, 29 May 2007 22:18:05 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Takashi Iwai <tiwai@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Uwe Bugla <uwe.bugla@gmx.de>,
       linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: BUG in 2.6.22-rc2-mm1: Parts of Alsa sound architecture broken
In-Reply-To: <s5hveebziom.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.61.0705292212120.11140@yvahk01.tjqt.qr>
References: <20070524200052.234330@gmx.net> <20070524130921.8dbd3777.akpm@linux-foundation.org>
 <s5hiragopsx.wl%tiwai@suse.de> <20070525102806.77ee9c0c.akpm@linux-foundation.org>
 <s5h1wh4si5l.wl%tiwai@suse.de> <Pine.LNX.4.61.0705261248150.7344@yvahk01.tjqt.qr>
 <s5hveebziom.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 29 2007 18:41, Takashi Iwai wrote:
>
>Well, I find the change of CONFIG_SND to menuconfig is fine, too.
>But CONFIG_SND_PCI_DRIVERS and others don't make much sense to me.
>How is it useful at all?

Hah, I just tell you some of my own experience.
In summer 2003, I bought the last new machine, and it got these
shiny new ports they like to call USB. :)
I did not have much use for it, but I left it on - you never know
what standard next is the big win of the decade. And actually,
it did not took long (well, summer 2005) to get my first USB device.
Still, I am hell as sure I do not have USB-based sound devices
anytime soon, so it would be cool to deactivate the whole usbsound
menu at once. I think I said that in the patch description, did not I?

>Anyway, I'd like to confirm that this really works before merging to
>the ALSA tree.  As Mauro suspected, kconfig seems not working as
>expected...

Unfortunately, there are sometimes non-visible options in menus (the
Networking>QoS menu for example) that, when converted to menuconfig-if-endif,
also get lost when the menuconfig object is deactivated. In case of QoS, this
can break compilation. For most subsystems however, it works alright because
the particular subsystem referencing CONFIG_INVISIBLE_THING is deactivated
anyway and does not get compiled.
Such strange menus (like QoS) have not been menuconfigized so far, it's just
too hard to keep the bits together. As far as other subsystems are concerned,
please give it some testing.


	Jan
-- 
