Return-Path: <linux-kernel-owner+w=401wt.eu-S933430AbXGWBRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430AbXGWBRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbXGWBRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:17:22 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:44743 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754174AbXGWBRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:17:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GNMrbg0p9bEwjgUqSzXemJIs69/vv8N1Z2guqrGODnbrzuMkme19+7BIa4SMovoBx1ja++Y68TiSxMXCiRw94kC2VfVfAYx7M3GVYLOwx1Ecr1Gneqt1chgWVNZFSVK8N2PfksyRzJYIfKoerL+04Juk6Mz0ABtjKZhjdweWuA4=  ;
X-YMail-OSG: CuyME_wVM1naxsBPrLCw4FKYxW9200j8PqHDwuRK7usXi5vuilyvbk2cAZbK0rbt.j9HbqpmvQ--
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: rtc-ds1307.c: array overrun
Date: Sun, 22 Jul 2007 18:17:17 -0700
User-Agent: KMail/1.9.6
Cc: Rodolfo Giometti <giometti@linux.it>, a.zummo@towertech.it,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
References: <20070723004422.GR26212@stusta.de>
In-Reply-To: <20070723004422.GR26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707221817.18338.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2007, Adrian Bunk wrote:
> The Coverity checker spotted the following array overrun
> in drivers/rtc/rtc-ds1307.c:

Typo -- thanks, fix is attached.

========	CUT HERE
Fix a typo turned up by a Coverity check:  referring to the wrong register,
which could cause problems restarting DS1338 RTCs after their oscillator
halted.  (For example, if the backup battery died.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/rtc/rtc-ds1307.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- g26.orig/drivers/rtc/rtc-ds1307.c	2007-07-22 18:10:09.000000000 -0700
+++ g26/drivers/rtc/rtc-ds1307.c	2007-07-22 18:10:21.000000000 -0700
@@ -352,7 +352,7 @@ read_rtc:
 		/* oscillator fault?  clear flag, and warn */
 		if (ds1307->regs[DS1307_REG_CONTROL] & DS1338_BIT_OSF) {
 			i2c_smbus_write_byte_data(client, DS1307_REG_CONTROL,
-					ds1307->regs[DS1337_REG_CONTROL]
+					ds1307->regs[DS1307_REG_CONTROL]
 					& ~DS1338_BIT_OSF);
 			dev_warn(&client->dev, "SET TIME!\n");
 			goto read_rtc;
