Return-Path: <linux-kernel-owner+w=401wt.eu-S1764318AbYD3VPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764318AbYD3VPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbYD3VPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:15:04 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1593 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757809AbYD3VPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:15:03 -0400
Subject: Re: [PATCH -next] PNP: fix printk format warnings
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
In-Reply-To: <20080430135608.8b6ee7e0.randy.dunlap@oracle.com>
References: <20080430135608.8b6ee7e0.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 14:07:20 -0700
Message-Id: <1209589640.5041.67.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-30 at 13:56 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> next-20080430/drivers/pnp/pnpbios/rsparser.c:594: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'
> next-20080430/drivers/pnp/pnpbios/rsparser.c:605: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'

resource_size_t can be u64
I think you need %llu/(unsigned long long)

--- next-20080430.orig/drivers/pnp/pnpbios/rsparser.c
+++ next-20080430/drivers/pnp/pnpbios/rsparser.c
@@ -591,7 +591,7 @@ static void pnpbios_encode_irq(struct pn
 	p[1] = map & 0xff;
 	p[2] = (map >> 8) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode irq %d\n", res->start);
+	dev_dbg(&dev->dev, "  encode irq %llu\n", (unsigned long long)res->start);
 }
 
 static void pnpbios_encode_dma(struct pnp_dev *dev, unsigned char *p,
@@ -602,7 +602,7 @@ static void pnpbios_encode_dma(struct pn
 	map = 1 << res->start;
 	p[1] = map & 0xff;
 
-	dev_dbg(&dev->dev, "  encode dma %d\n", res->start);
+	dev_dbg(&dev->dev, "  encode dma %llu\n", (unsigned long long)res->start);
 }
 
 static void pnpbios_encode_port(struct pnp_dev *dev, unsigned char *p,


