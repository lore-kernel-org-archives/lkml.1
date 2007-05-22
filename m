Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbXEVVCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbXEVVCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763012AbXEVVCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:02:36 -0400
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:40330 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762960AbXEVVCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:02:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sEwn+9b0s9uo+G/GNADYx2hMFGLpd14pPliFIQVAk38qeXyCzqzPMSpWrnaJblkOUAFeg1pyxGemt85xAkwRUmFxgQbNHR37Ydvpdgy7ExRwecyehQw8TAFNvfjNpRanzhKhZo+S72kTExpem0wAFVYKk4Io7BCwFPIZ0oEqkzg=  ;
X-YMail-OSG: uri7s3AVM1mdcM10QmjsMTiNeO33hRx3vHF5jwJ6KWxwf1Gi_2QwOI9sq1aIwy3C0i02bkE5Lg--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.22-rc2-git] omap_uwire: SPI_CPHA mode bugfix
Date: Tue, 22 May 2007 13:58:31 -0700
User-Agent: KMail/1.9.6
Cc: Tony Lindgren <tony@atomide.com>, imre.deak@solidboot.com,
       spi-devel-general@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221358.32467.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Deak <imre.deak@solidboot.com>

The omap_uwire controller driver handles SPI_CPHA incorrectly;
It should mean:

  CPHA=0 ... sample at leading edge of clock
  CPHA=1 ... sample at trailing edge of clock

This bug has been masked by inverse bugs in layered drivers;
and was uncovered by running some of them on non-OMAP hardware.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- o26.orig/drivers/spi/omap_uwire.c	2007-05-22 07:49:52.000000000 -0700
+++ o26/drivers/spi/omap_uwire.c	2007-05-22 08:02:03.000000000 -0700
@@ -358,11 +358,11 @@ static int uwire_setup_transfer(struct s
 	switch (spi->mode & (SPI_CPOL | SPI_CPHA)) {
 	case SPI_MODE_0:
 	case SPI_MODE_3:
-		flags |= UWIRE_WRITE_RISING_EDGE | UWIRE_READ_FALLING_EDGE;
+		flags |= UWIRE_WRITE_FALLING_EDGE | UWIRE_READ_RISING_EDGE;
 		break;
 	case SPI_MODE_1:
 	case SPI_MODE_2:
-		flags |= UWIRE_WRITE_FALLING_EDGE | UWIRE_READ_RISING_EDGE;
+		flags |= UWIRE_WRITE_RISING_EDGE | UWIRE_READ_FALLING_EDGE;
 		break;
 	}
 
