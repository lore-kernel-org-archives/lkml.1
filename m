Return-Path: <linux-kernel-owner+w=401wt.eu-S934037AbYBNFRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037AbYBNFRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764293AbYBNFOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:14:40 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:8020 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYBNFOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:14:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=I7HyP2w1R5t/7LoNfcv3GDA1wx/MNp6lKw+5gkf46lN0lX8HLX/tqSXfTCp846wy5UgbqdhIrYDAPUiQJlStBjYysLIWpFIwy4Dhwb8BCGIvTTUqBUv5IiCO44Kw8JWl1AHIR4Je3VWqEggIcWEbFLOZrTtCeFKroatOAS/K7i4=
Subject: [PATCH 05/11] ata: replace macro with static inline in libata.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 21:14:18 -0800
Message-Id: <1202966058.2748.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid a metric ton of sparse warnings like:
drivers/ata/pata_ali.c:176:14: warning: symbol '__x' shadows an earlier one
drivers/ata/pata_ali.c:176:14: originally declared here

Due to nesting min_t macro inside max_t macro which both use a __x
identifier internally.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/libata.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index bc5a8d0..2845983 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -764,7 +764,11 @@ struct ata_timing {
 	unsigned short udma;		/* t2CYCTYP/2 */
 };
 
-#define FIT(v, vmin, vmax)	max_t(short, min_t(short, v, vmax), vmin)
+static inline short FIT(short v, short vmin, short vmax)
+{
+	short tmp = min_t(short, v, vmax);
+	return max_t(short, tmp, vmin);
+}
 
 extern const unsigned long sata_deb_timing_normal[];
 extern const unsigned long sata_deb_timing_hotplug[];
-- 
1.5.4.1.1278.gc75be


