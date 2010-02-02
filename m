Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0BBMMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 07:12:19 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:56447 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab0BBMMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 07:12:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MA7M9LO4OAmD42vix86WE0OjkxTqxCKvi/Ns4S4hRHmbEX60V2t4YV529Kw+9DA3wL
         +/hgmSTPQCTuUXlPunmsX26P2YBQWzDT61jV4KkRwyL/Y3xtPivxwcA2WEHaR6sxi+M5
         ekxk2GKR8rJA04xN+MjQ4YkTXk7GT/0u9wxRk=
Subject: [PATCH] drivers/acpi/ec.c fix a small memory leak
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, linux ACPI <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       astarikovskiy@suse.de
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 23:12:10 +1100
Message-ID: <1265112730.4804.8.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Plug a very small leak in acpi_ec_ecdt_probe()

Coverity CID: 13319

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com> 

diff --git drivers/acpi/ec.c drivers/acpi/ec.c
index d6471bb..13061dc 100644
--- drivers/acpi/ec.c
+++ drivers/acpi/ec.c
@@ -1009,8 +1009,10 @@ int __init acpi_ec_ecdt_probe(void)
 	/* fall through */
 	}
 
-	if (EC_FLAGS_SKIP_DSDT_SCAN)
+	if (EC_FLAGS_SKIP_DSDT_SCAN) {
+		kfree(saved_ec);
 		return -ENODEV;
+	}
 
 	/* This workaround is needed only on some broken machines,
 	 * which require early EC, but fail to provide ECDT */


