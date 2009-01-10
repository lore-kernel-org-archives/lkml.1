Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033AbZAJFRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbZAJFRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 00:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbZAJFRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 00:17:12 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:53019 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZAJFRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 00:17:12 -0500
Message-ID: <49682F42.8070304@oracle.com>
Date: Fri, 09 Jan 2009 21:16:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: akorolev@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: mtd/lpddr/qinfo_probe.c needs lpddr_cmds to be compiled
References: <20090110021641.GA26951@orion>
In-Reply-To: <20090110021641.GA26951@orion>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49682F45.0007:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov wrote:
> drivers/built-in.o: In function `lpddr_probe':
> drivers/mtd/lpddr/qinfo_probe.c:215:
> undefined reference to `lpddr_cmdset'
> 
> # CONFIG_MTD_LPDDR is not set
> CONFIG_MTD_QINFO_PROBE=y
> --

This patch has been posted, just needs to be merged (hint):
---


Signed-off-by: Alexey Korolev <akorolev@infradead.org>
---
diff --git a/drivers/mtd/lpddr/Kconfig b/drivers/mtd/lpddr/Kconfig
index acd4ea9..5a401d8 100644
--- a/drivers/mtd/lpddr/Kconfig
+++ b/drivers/mtd/lpddr/Kconfig
@@ -12,6 +12,7 @@ config MTD_LPDDR
 	  DDR memories, intended for battery-operated systems.
 
 config MTD_QINFO_PROBE
+	depends on MTD_LPDDR
 	tristate "Detect flash chips by QINFO probe"
 	help
 	    Device Information for LPDDR chips is offered through the Overlay


