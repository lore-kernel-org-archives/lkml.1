Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbYBAUja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbYBAUja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYBAUjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:39:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:35251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYBAUjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:39:22 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Denys Fedoryshchenko" <denys@visp.net.lb>
Subject: Re: kernel panic on 2.6.24/iTCO_wdt not rebooting machine
Date: Fri, 1 Feb 2008 15:39:08 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
References: <20080201151243.M2879@visp.net.lb> <200802011211.42089.lenb@kernel.org> <20080201191048.M59862@visp.net.lb>
In-Reply-To: <20080201191048.M59862@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011539.08393.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008 14:15, Denys Fedoryshchenko wrote:
> 
> On Fri, 1 Feb 2008 12:11:41 -0500, Len Brown wrote
> > 
> > What do you see if you build with CONFIG_HIGH_RES_TIMERS=n
> > 
> > Does it work better if you boot with "acpi=off"?
> > if yes, how about with just pnpacpi=off?
> > 
> > thanks,
> > -Len
> 
> It is not very easy to test. About bug - most probably it is related to third 
> party ESFQ patch, i will drop it and then test more properly when i will be 
> able to make watchdog work fine. But more important i notice - that iTCO_wdt 
> is not working at all. I think hrtimers doesn't change anything on that.
> About testing, i cannot take even small risk now(and near 3-5 days) by 
> changing kernel options, i set now maximum available set of watchdogs, cause 
> there is noone to maintain server, area is unreachable because of snow and 
> bad weather.
> 
> Do you think reasonable to try acpi / pnpacpi with iTCO_wdt to make it work? 
> Maybe just registers addresses or way how TCO watchdog activated changed on 
> this chipset?

yes, i'm wondering if the changes in IO resource reservations
in the PNPACPI layer are interfering with the native driver.

unfortunately, if you boot with acpi=off or pnpacpi=off, you may
run into other, unrelated, issues (or not).

one way to isolate the problem is if you revert these two lines
from their 2.6.24 values to their 2.6.23 values by applying this patch:
---
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 2a6d62c..16b46aa 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -13,8 +13,8 @@
 #include <linux/errno.h>
 #include <linux/mod_devicetable.h>
 
-#define PNP_MAX_PORT		40
-#define PNP_MAX_MEM		12
+#define PNP_MAX_PORT		8
+#define PNP_MAX_MEM		4
 #define PNP_MAX_IRQ		2
 #define PNP_MAX_DMA		2
 #define PNP_NAME_LEN		50
