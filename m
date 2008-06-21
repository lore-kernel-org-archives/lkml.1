Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbYFUPAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbYFUPAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 11:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbYFUPA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 11:00:26 -0400
Received: from relais.videotron.ca ([24.201.245.36]:8625 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYFUPAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 11:00:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sat, 21 Jun 2008 11:00:04 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: sdio: bad CISTPL_FUNCE error
In-reply-to: <485BCBB3.20405@atmel.com>
Message-id: <alpine.LFD.1.10.0806211045390.2979@xanadu.home>
References: <485BCBB3.20405@atmel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008, Nicolas Ferre wrote:

> Hi Pierre,
> 
> While trying to setup a GPS SDIO card, I experience the following error:
> "mmc0: bad CISTPL_FUNCE size 28 type 1"

Could you apply this patch and see what it shows:

diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index d5e51b1..60ec4d3 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -149,8 +149,9 @@ static int cistpl_funce(struct mmc_card *card, struct sdio_func *func,
 		ret = cistpl_funce_common(card, buf, size);
 
 	if (ret) {
-		printk(KERN_ERR "%s: bad CISTPL_FUNCE size %u "
-		       "type %u\n", mmc_hostname(card->host), size, buf[0]);
+		printk(KERN_ERR "%s: bad %s CISTPL_FUNCE size %u type %u\n",
+		       mmc_hostname(card->host), func ? "function" : "common",
+		       size, buf[0]);
 		return ret;
 	}
 

> I use a combo card but without mirco sd card inserted.
> http://www.spectec.com.tw/sdg810.htm
> 
> Tracing in sdio_cis.c file, I print the tpl_code (line 216).
> I have 3 successive codes : 0xff, 0x21 & 0x22.

Again that would be good to know if/when func is NULL when those are 
parsed.

> Is this a host controller driver issue ?

Most probably not.


Nicolas
