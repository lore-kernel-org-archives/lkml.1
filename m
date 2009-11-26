Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbZKZIS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbZKZIS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759454AbZKZIS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:18:27 -0500
Received: from poutre.nerim.net ([62.4.16.124]:58729 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759453AbZKZIS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:18:26 -0500
Date: Thu, 26 Nov 2009 09:18:29 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: linux-next: i2c tree build warning
Message-ID: <20091126091829.74d3b7ce@hyperion.delvare>
In-Reply-To: <20091126140600.2f55ab0e.sfr@canb.auug.org.au>
References: <20091126140600.2f55ab0e.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, 26 Nov 2009 14:06:00 +1100, Stephen Rothwell wrote:
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> drivers/misc/eeprom/at24.c: In function 'at24_eeprom_read':
> drivers/misc/eeprom/at24.c:230: warning: format '%zd' expects type 'signed size_t', but argument 6 has type 'int'
> 
> Introduced by commit 39bfab2519e6f148f2508d719f9fc5f4581aeefd ("at24: Use
> timeout also for read").

Thanks for reporting. The warning did not show on my 32-bit x86 system,
and I guess it did not show on Wolfram's system either, otherwise we'd
have fixed it.

Does the following patch fix the warning for you?

--- linux-2.6.32-rc8.orig/drivers/misc/eeprom/at24.c	2009-11-26 09:14:45.000000000 +0100
+++ linux-2.6.32-rc8/drivers/misc/eeprom/at24.c	2009-11-26 09:14:15.000000000 +0100
@@ -227,7 +227,7 @@ static ssize_t at24_eeprom_read(struct a
 			if (status == 2)
 				status = count;
 		}
-		dev_dbg(&client->dev, "read %zu@%d --> %zd (%ld)\n",
+		dev_dbg(&client->dev, "read %zu@%d --> %d (%ld)\n",
 				count, offset, status, jiffies);
 
 		if (status == count)

If it does then I'll merge this into Wolfram's patch.

Thanks,
-- 
Jean Delvare
