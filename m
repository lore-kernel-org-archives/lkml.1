Return-Path: <linux-kernel-owner+w=401wt.eu-S1763498AbXKIPfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763498AbXKIPfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 10:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763332AbXKIPeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 10:34:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763352AbXKIPeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 10:34:46 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/6] MTD: Add support for the SST 39VF1601 flash chip [try #5]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Fri, 09 Nov 2007 15:34:42 +0000
Message-ID: <20071109153442.20803.51684.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
References: <20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the SST 39VF1601 flash chip.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/mtd/chips/jedec_probe.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index a67b23b..5074b5e 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -1527,6 +1527,21 @@ static const struct amd_flash_info jedec_table[] = {
                        ERASEINFO(0x1000,256),
                        ERASEINFO(0x1000,256)
                }
+	}, {
+               .mfr_id         = MANUFACTURER_SST,     /* should be CFI */
+               .dev_id         = SST39VF1601,
+               .name           = "SST 39VF1601",
+               .uaddr          = {
+                       [0] = MTD_UADDR_0x5555_0x2AAA,  /* x8 */
+                       [1] = MTD_UADDR_0x5555_0x2AAA   /* x16 */
+               },
+               .DevSize        = SIZE_2MiB,
+               .CmdSet         = P_ID_AMD_STD,
+               .NumEraseRegions= 2,
+               .regions        = {
+                       ERASEINFO(0x1000,256),
+                       ERASEINFO(0x1000,256)
+               }
 
 	}, {
 		.mfr_id		= MANUFACTURER_ST,

