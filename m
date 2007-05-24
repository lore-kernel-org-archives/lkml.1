Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbXEXV4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbXEXV4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbXEXVz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:55:58 -0400
Received: from AStrasbourg-253-1-12-113.w81-51.abo.wanadoo.fr ([81.51.227.113]:37485
	"EHLO snowman.cryosphere.shacknet.nu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbXEXVz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:55:57 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 May 2007 17:55:56 EDT
Message-ID: <46560830.2000405@gmx.net>
Date: Thu, 24 May 2007 23:48:32 +0200
From: Jimmy Jazz <Jimmy.Jazz@gmx.net>
Reply-To: Jimmy.Jazz@gmx.net
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Daniel Drake <dsd@gentoo.org>,
       linux list <linux-kernel@vger.kernel.org>
Subject: Re: radeonfb and X800 cards
References: <464BB43D.2020407@gentoo.org> <1179367164.32247.256.camel@localhost.localdomain> <20070517195958.GA6489@dreamland.darkstar.lan> <1179451140.32247.326.camel@localhost.localdomain> <465044FC.30204@gmx.net> <20070522193149.GA15040@dreamland.darkstar.lan>
In-Reply-To: <20070522193149.GA15040@dreamland.darkstar.lan>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti a écrit :
> Il Sun, May 20, 2007 at 02:54:20PM +0200, Jimmy Jazz ha scritto: 
>> @Luca, if i remember well you have a X850, could you please try the
>> patch for me ?
> 
> It does work - sort of; BIOS parsing code is correct. It lacks the
> proper connector detection though (esp. port sharing). ATOM BIOS has a
> different data layout, so this should be added (now radeonfb thinks that
> I've 2 monitors).
> 
> I'll be away this weekend, so I'll try to come up with a patch as soon
> as I return home.
> 
> Luca

Hello,

The fact that you see two monitors doesn't really surprise me  :) .
Also, i'm convinced to move to the mega patch even if i'm not quite sure
all that code is also needed and I know it will unnecessarily increase
the size of the kernel. However, better have much then less. Sure, if
there were any more information on the web about video card
connector/port logic, my knowledge would have been undoubtedly improved.
Anyway, adding (conn->ddc_type == ddc_monid) in the if condition in
radeon_i2c.c works for me as well.

--- /usr/src/model_with-radeon-r400/aty/radeon_i2c.c	2007-04-13
13:35:49.000000000 +0200
+++ radeon_i2c.c	2007-04-13 22:07:16.000000000 +0200
@@ -163,7 +163,7 @@
 		mon_type = MT_NONE;
 		goto done;
 	}
-	if ((edid[EDID_STRUCT_DISPLAY] & 0x80) && (conn->ddc_type == ddc_dvi)) {
+	if ((edid[EDID_STRUCT_DISPLAY] & 0x80) && ((conn->ddc_type == ddc_dvi)
|| (conn->ddc_type == ddc_monid))) {
 		RTRACE("radeonfb: I2C (port %d) ... found TMDS panel\n", conn->ddc_type);
 		mon_type = MT_DFP;
 		goto done;

Thank you for testing the patch.

Jj
