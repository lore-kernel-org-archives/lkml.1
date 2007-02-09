Return-Path: <linux-kernel-owner+w=401wt.eu-S2992437AbXBIRFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992437AbXBIRFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992440AbXBIRFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:05:05 -0500
Received: from tougher.kangaroot.net ([62.213.203.135]:57673 "EHLO
	tougher.kangaroot.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992437AbXBIRFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:05:04 -0500
X-Greylist: delayed 766 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 12:05:03 EST
Date: Fri, 9 Feb 2007 17:52:11 +0100
From: Wouter Paesen <wouter@kangaroot.net>
To: Jaroslav Kysela <perex@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] sound/pci/ca0106: add device attribute to ca0106 devices
Message-ID: <20070209165211.GB15805@tougher.kangaroot.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The ca0106 driver does not install a reference to the pci
device in it's __devinit function.   This will result in a 
missing "device" attribute on the sound devices associated with
this card, which makes hal/libhal ignore the card.

Signed-off-by: Wouter Paesen <wouter@kangaroot.net>
--

--- linux-2.6.20/sound/pci/ca0106/ca0106_main.c.orig	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20/sound/pci/ca0106/ca0106_main.c	        2007-02-09 17:20:37.000000000 +0100
@@ -1455,6 +1455,8 @@ static int __devinit snd_ca0106_create(i
 		snd_ca0106_free(chip);
 		return err;
 	}
+
+	snd_card_set_dev(card, &pci->dev);
 	*rchip = chip;
 	return 0;
 }
