Return-Path: <linux-kernel-owner+w=401wt.eu-S1762144AbXKNAVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762144AbXKNAVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762083AbXKNATK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:19:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761590AbXKNATF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:19:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/9] MTD: Add support for the SST 39VF1601 flash chip [try #6]
To: torvalds@osdl.org, akpm@linux-foundation.org, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Wed, 14 Nov 2007 00:18:57 +0000
Message-ID: <20071114001857.27662.88156.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk>
References: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the SST 39VF1601 flash chip.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/mtd/chips/jedec_probe.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index a67b23b..75fbdcf 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -1527,7 +1527,21 @@ static const struct amd_flash_info jedec_table[] = {
                        ERASEINFO(0x1000,256),
                        ERASEINFO(0x1000,256)
                }
-
+	}, {
+		.mfr_id		= MANUFACTURER_SST,     /* should be CFI */
+		.dev_id		= SST39VF1601,
+		.name		= "SST 39VF1601",
+		.uaddr		= {
+			[0] = MTD_UADDR_0x5555_0x2AAA,  /* x8 */
+			[1] = MTD_UADDR_0x5555_0x2AAA   /* x16 */
+		},
+		.DevSize	= SIZE_2MiB,
+		.CmdSet		= P_ID_AMD_STD,
+		.NumEraseRegions = 2,
+		.regions	= {
+			ERASEINFO(0x1000, 256),
+			ERASEINFO(0x1000, 256)
+		}
 	}, {
 		.mfr_id		= MANUFACTURER_ST,
 		.dev_id		= M29F800AB,

