Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbXIAKcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbXIAKcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 06:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbXIAKcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 06:32:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53451 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbXIAKcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 06:32:04 -0400
Message-ID: <46D93FA0.1000307@garzik.org>
Date: Sat, 01 Sep 2007 06:32:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Grant Wilson <grant.wilson@zen.co.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: Linux 2.6.23-rc5 - oops
References: <alpine.LFD.0.999.0708312343440.27951@evo.linux-foundation.org> <20070901101110.038835c2@worthy.swandive.local>
In-Reply-To: <20070901101110.038835c2@worthy.swandive.local>
Content-Type: multipart/mixed;
 boundary="------------080108060405020307070401"
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080108060405020307070401
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Grant Wilson wrote:
> Get an oops when booting this kernel:
[...]
> Using git-bisect the faulty commit is
> 
> bad: [43a98f05d99205687ddf74089e79a8312c8c5f90] ata_piix: implement IOCFG bit18 quirk

Good work bisecting!  I love git-bisect :)

The attached patch should fix things, let me know if it does not.

	Jeff



--------------080108060405020307070401
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index e40c94f..3b8bf18 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -955,7 +955,8 @@ static int piix_broken_suspend(void)
 				DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE M500"),
 			},
 		},
-		{ }
+
+		{ }	/* terminate list */
 	};
 	static const char *oemstrs[] = {
 		"Tecra M3,",
@@ -1187,6 +1188,8 @@ static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
 				DMI_MATCH(DMI_PRODUCT_NAME, "M570U"),
 			},
 		},
+
+		{ }	/* terminate list */
 	};
 	u32 iocfg;
 

--------------080108060405020307070401--
