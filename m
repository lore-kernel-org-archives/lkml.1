Return-Path: <linux-kernel-owner+w=401wt.eu-S1763835AbXEVVDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763835AbXEVVDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbXEVVCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:02:37 -0400
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:40336 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762990AbXEVVCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:02:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ySfYplN2lCKdnH3IojqEvLeWOPthGDxyTx1N4K1ZjNm8zdApupC+flVMMDowV3MXO+AGZwNBwgrsWC/bqfI9M2QoAp+ktDLoids5EFjdBX1KdkIaRwWpzpduBAaMs5MVGAs6D8tGVGBzGC61UZ9i3nmwweURueDU32GhBR4YUDI=  ;
X-YMail-OSG: m6HqrKoVM1nMu_gqlLX3UqwSx4PIMSvpfSNsEMSDNk.Ha5BOLmiMjOV4LTsEQI1VRy2AHmBCJqgieOrMNolaQNbkPeoXLNQqDzQRK0j_vcaxJvBAm8odydMGhYz68A--
From: David Brownell <david-b@pacbell.net>
To: Dmitry Torokhov <dtor@mail.ru>, Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.22-rc2-git] ads7846: SPI_CPHA mode bugfix
Date: Tue, 22 May 2007 13:59:11 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz,
       Semih Hazar <semih.hazar@indefia.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Tony Lindgren <tony@atomide.com>, imre.deak@solidboot.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221359.12410.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Semih Hazar <semih.hazar@indefia.com>

In commit [1] the SPI mode is set to 1, but it should be 0.  As stated
in the commit, ads784x samples the data on the rising edge.  SPI mode 1
samples on the falling edge [2] though.

The root cause of this is a bug in the omap_uwire code, which treats
CPHA=1 incorrectly; so these two bugs cancel each other out on one
of the main regression test platforms for this driver.

[1] kernel.org GIT 7937e86a70235e1584486654687dc9908a11e00a
[2] http://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

---
 drivers/input/touchscreen/ads7846.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- g26.orig/drivers/input/touchscreen/ads7846.c	2007-05-20 21:08:30.000000000 -0700
+++ g26/drivers/input/touchscreen/ads7846.c	2007-05-20 21:08:54.000000000 -0700
@@ -847,7 +847,7 @@ static int __devinit ads7846_probe(struc
 	 * may not.  So we stick to very-portable 8 bit words, both RX and TX.
 	 */
 	spi->bits_per_word = 8;
-	spi->mode = SPI_MODE_1;
+	spi->mode = SPI_MODE_0;
 	err = spi_setup(spi);
 	if (err < 0)
 		return err;
