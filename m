Return-Path: <linux-kernel-owner+w=401wt.eu-S933158AbXDFVsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbXDFVsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXDFVsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:48:52 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:28411 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933158AbXDFVsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:48:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GGlNTl/0mzDfa4KWINTlMTImPta6Ics7Pf7dQ0/1Mvty/t5ihoa3FKtfK6/9uvR9AudmEQySzdky1ydw2jXZaOY3frTw7v7LOXbUy3wly1fDlVqC9z6WhAUApYeE9PRFh9JuJnNTmunJcgzY94VxvpVfUabTGicNWRPwt02449w=  ;
X-YMail-OSG: s1eCzwoVM1nI9ex5mt50KsATDTtWGeXA9oovjL0ALeqw.Kaq1VhMmEK05lzsogDGsn03O_cI1Q--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc6-git] at91_cf, minor fix
Date: Fri, 6 Apr 2007 14:48:47 -0700
User-Agent: KMail/1.7.1
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061448.47406.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a minor correctness fix:  since the at91_cf driver probe() routine
is in the init section, it should use platform_driver_probe() instead of
leaving that pointer around in the driver struct after init section removal.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
This is a refresh of a patch sent to the linux-pcmcia list on 15-February;
it seems that despite the MAINTAINERS file, that's not the place to send
patches.  (So what good is that list, and why is it in MAINTAINERS?)


Index: at91/drivers/pcmcia/at91_cf.c
===================================================================
--- at91.orig/drivers/pcmcia/at91_cf.c	2007-02-15 18:20:53.000000000 -0800
+++ at91/drivers/pcmcia/at91_cf.c	2007-02-15 18:31:27.000000000 -0800
@@ -360,7 +360,6 @@ static struct platform_driver at91_cf_dr
 		.name		= (char *) driver_name,
 		.owner		= THIS_MODULE,
 	},
-	.probe		= at91_cf_probe,
 	.remove		= __exit_p(at91_cf_remove),
 	.suspend	= at91_cf_suspend,
 	.resume		= at91_cf_resume,
@@ -370,7 +369,7 @@ static struct platform_driver at91_cf_dr
 
 static int __init at91_cf_init(void)
 {
-	return platform_driver_register(&at91_cf_driver);
+	return platform_driver_probe(&at91_cf_driver, at91_cf_probe);
 }
 module_init(at91_cf_init);
 
