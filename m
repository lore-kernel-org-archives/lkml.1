Return-Path: <linux-kernel-owner+w=401wt.eu-S1759729AbXHWDjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbXHWDjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXHWDiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:38:52 -0400
Received: from n2.bullet.mail.mud.yahoo.com ([209.191.127.222]:26025 "HELO
	n2.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755194AbXHWDiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:38:51 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 23:38:51 EDT
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 932044.27108.bm@rrr1.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=xgHR2Og3CXvoUBOZzp6p89WnUBayw7SBgSxp9oJn+xBiPhA/ER28lVy6YOxERMwMUO2T2y6ZaHfLCHHITCXmclVrrloOmCGmgCWqzhA1D/L87oATOyMVbD1eCcS7RP0YjW7VOWjQK7i8aN61lU9kTdBZDquZe1Z4o4009dD1Ixw=;
Date: Wed, 22 Aug 2007 20:33:10 -0700 (PDT)
From: Scott Thompson <postfailathushmaildotcom@yahoo.com>
Reply-To: postfail@hushmail.com
Subject: [PATCH 5 of 5 resend ] /drivers/char/watchdog ioremap balancing/ returncode check
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <989872.81202.qm@web44910.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patchset against 2.6.23-rc3.  
corrects missing ioremap return checks and balancing on iounmap calls, integrated changes per list
recommendations on the original set of patches..

Warning -- cleanup handler here may miss additional required cleanup as has occurred on other
portions of ioremap audit.

This patch had been submitted previously but hushmail client caused wordwrap issues, resending
with different mail client.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/char/watchdog/iTCO_wdt.c b/drivers/char/watchdog/iTCO_wdt.c
index cd5a565..f87cac7 100644
--- a/drivers/char/watchdog/iTCO_wdt.c
+++ b/drivers/char/watchdog/iTCO_wdt.c
@@ -621,6 +621,12 @@ static int iTCO_wdt_init(struct pci_dev *pdev,
 		pci_read_config_dword(pdev, 0xf0, &base_address);
 		RCBA = base_address & 0xffffc000;
 		iTCO_wdt_private.gcs = ioremap((RCBA + 0x3410),4);
+		if (!iTCO_wdt_private.gcs) {
+			printk(KERN_ERR PFX "failed to ioremap\n");
+			ret = -ENOMEM;
+			goto out;
+		}
+
 	}
 
 	/* Check chipset's NO_REBOOT bit */


       
____________________________________________________________________________________
Take the Internet to Go: Yahoo!Go puts the Internet in your pocket: mail, news, photos & more. 
http://mobile.yahoo.com/go?refer=1GNXIC


      ____________________________________________________________________________________
Shape Yahoo! in your own image.  Join our Network Research Panel today!   http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 



