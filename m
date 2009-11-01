Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbZKANHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbZKANHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 08:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZKANHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 08:07:11 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:33978 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZKANHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 08:07:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=eRQHDMxfxR5nLKHmzvmfq+aDkjHLpNWmoBRzj7INQZVMXoLuYSJ8mqx7+I3WminQeK
         YBFkrpVqsPFf7kU4eL+0lxhLms3AyKPmWnKwAtmxLTYsny5Ss83iO1Yii5RVaWX29BCE
         08sH62YakgAntDw7QCbQpJMT1NLmLwUNK9xIU=
Message-ID: <4AED8A98.6040205@gmail.com>
Date: Sun, 01 Nov 2009 14:18:16 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Tony Lindgren <tony@atomide.com>" <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] OMAP: Should cs be positive in gpmc_cs_free()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The index `cs' is signed, test whether it is negative before
we release gpmc_cs_mem[cs].

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found by code analysis, is it required?

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 1587682..c892a54 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -378,7 +378,7 @@ EXPORT_SYMBOL(gpmc_cs_request);
 void gpmc_cs_free(int cs)
 {
 	spin_lock(&gpmc_mem_lock);
-	if (cs >= GPMC_CS_NUM || !gpmc_cs_reserved(cs)) {
+	if (cs >= GPMC_CS_NUM || cs < 0 || !gpmc_cs_reserved(cs)) {
 		printk(KERN_ERR "Trying to free non-reserved GPMC CS%d\n", cs);
 		BUG();
 		spin_unlock(&gpmc_mem_lock);
