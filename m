Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000Ab0AZPEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0AZPEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789Ab0AZPEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:04:35 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:49627 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab0AZPEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:04:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hYjfMjb25WQ8rxPk7zxpxYybaL/bnA3YUkOPe5ldcUDySjxELss7ckhDmXypvQzRVa
         uAJvkWEN4H1yTjdMHn9T3pB0NOnObLFO2IEgBYExgaMvFUXwqaxBH9x5voO2PBf11a/P
         c3TtdF8Km8jKkPTsHz5OvyDwVn5/D9OMK2Eac=
MIME-Version: 1.0
Date: Tue, 26 Jan 2010 20:34:31 +0530
Message-ID: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>
Subject: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
From: Vishal Rao <vishalrao@gmail.com>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, vishalrao@gmail.com,
       linux-kernel@vger.kernel.org, trivial@kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable NCQ usage for Crucial M225 model range of SSDs.

Signed-off-by: Vishal Rao <vishalrao@gmail.com>
Tested-by: Vishal Rao <vishalrao@gmail.com>
Cc: stable@kernel.org

---

Should work with 64, 128 (tested) and 256 GB capacities with any
firmware versions in
drivers/ata/libata-core.c because of ATA errors in dmesg, hangs and
filesystem corruption.

The diff is against linux kernel 2.6.33 rc5 though also meant for
2.6.32 stable series due to multiple distros' proposed long term support.

I've tested on my PC with my Crucial M225 model 128 GB SSD and it works
without the need to specify kernel boot option " libata.force=noncq ".

--- linux-source-2.6.33rc5/drivers/ata/libata-core.c.orig	2010-01-26
08:35:54.117306573 +0530
+++ linux-source-2.6.33rc5/drivers/ata/libata-core.c	2010-01-26
08:35:13.047306938 +0530
@@ -4274,6 +4274,9 @@ static const struct ata_blacklist_entry
 	{ "ST380817AS",		"3.42",		ATA_HORKAGE_NONCQ },
 	{ "ST3160023AS",	"3.42",		ATA_HORKAGE_NONCQ },
 	{ "OCZ CORE_SSD",	"02.10104",	ATA_HORKAGE_NONCQ },
+	{ "CRUCIAL_CT64M225",	NULL,		ATA_HORKAGE_NONCQ },
+	{ "CRUCIAL_CT128M225",	NULL,		ATA_HORKAGE_NONCQ },
+	{ "CRUCIAL_CT256M225",	NULL,		ATA_HORKAGE_NONCQ },

 	/* Seagate NCQ + FLUSH CACHE firmware bug */
 	{ "ST31500341AS",	"SD15",		ATA_HORKAGE_NONCQ |


-- 
"Thou shalt not follow the null pointer for at its end madness and chaos lie."
