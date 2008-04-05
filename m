Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbYDECPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbYDECPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 22:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYDECOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 22:14:51 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:34867 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751073AbYDECOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 22:14:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=gJqfJfIaAL93li+9DrPehBZlrF/PCd2nOuzMC15fuDZXdIESj8AMufFssIRhtgqYO99srbD36CWg22AkfrFpgybZFX35sa91zPilVYaxdSJuNQHCgQxl6xI8jeVHl3izun9yLjcKUg2pzWSDUUahCahPZYZunaTsdYAOsfOQ40c=  ;
X-YMail-OSG: kTesYNUVM1miYVJq0NUn49Xbbvf5BwV9RUFs3tUTyw8Y1cnBirutHGA2SzpGTbsMoYM3Jdld9Q--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 04 Apr 2008 19:15:58 -0700
From: David Brownell <david-b@pacbell.net>
To: akpm@linux-foundation.org
Subject: [patch 2.6.25-rc-mm] don't export gpiochip_reserve (section fix)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080405021558.A1EB0CF63D@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix section warning:
  WARNING: drivers/gpio/built-in.o(__ksymtab_gpl+0xc0): Section mismatch
  in reference from the variable __ksymtab_gpiochip_reserve
  to the function .init.text:gpiochip_reserve()
  The symbol gpiochip_reserve is exported and annotated __init 
  Fix this by removing the __init annotation of gpiochip_reserve or drop the export.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/gpiolib.c |    1 -
 1 file changed, 1 deletion(-)

--- g26.orig/drivers/gpio/gpiolib.c	2008-03-31 13:05:15.000000000 -0700
+++ g26/drivers/gpio/gpiolib.c	2008-03-31 13:05:29.000000000 -0700
@@ -150,7 +150,6 @@ err:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(gpiochip_reserve);
 
 /**
  * gpiochip_add() - register a gpio_chip
