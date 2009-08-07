Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZHGRjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZHGRjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbZHGRjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:39:12 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:56088 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbZHGRjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RQ26rHnpQX6amGS5dZaNzqkFhsBIbl/i7JdGBN02OfHRyncRs1swZrShaKj/1qcdGr
         GwcuSMPJeiDq0MMkdUHvNxv9hzuY62K0MK6LmCaetX/npwa3ggUDHMArzEfjUxE6WQaC
         0eUPwTe4fQIlm+VmPMVPCHEjp1PwpApHjU2L4=
Message-ID: <4A7C6795.7070200@gmail.com>
Date: Fri, 07 Aug 2009 19:42:45 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Vrabel <david.vrabel@csr.com>
CC: drzeus@drzeus.cx, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sdio: Read buffer overflow
References: <4A7C4501.7070700@gmail.com> <4A7C5A3D.4090309@csr.com>
In-Reply-To: <4A7C5A3D.4090309@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sdio: avoid buffer underrun when parsing an invalid CISTPL_VERS_1

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Thanks for comments,

diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index 963f293..6636354 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -40,7 +40,7 @@ static int cistpl_vers_1(struct mmc_card *card, struct sdio_func *func,
 			nr_strings++;
 	}
 
-	if (buf[i-1] != '\0') {
+	if (nr_strings < 4) {
 		printk(KERN_WARNING "SDIO: ignoring broken CISTPL_VERS_1\n");
 		return 0;
 	}
