Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbZLWA1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbZLWA1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 19:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZLWA1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 19:27:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:49511 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbZLWA1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 19:27:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,438,1257148800"; 
   d="scan'208";a="525596119"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/3] async_tx: expand async raid6 test to cover ioatdma corner
	case
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: maciej.sosnowski@intel.com, Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 Dec 2009 17:26:01 -0700
Message-ID: <20091223002600.32335.55048.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
References: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add explicit 11 and 12 disks cases to exercise the 0 < src_cnt % 8 < 3
corner case in the ioatdma driver.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/async_tx/raid6test.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index 3ec27c7..f84f6b4 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -214,6 +214,13 @@ static int raid6_test(void)
 		err += test(4, &tests);
 	if (NDISKS > 5)
 		err += test(5, &tests);
+	/* the 11 and 12 disk cases are special for ioatdma (p-disabled
+	 * q-continuation without extended descriptor)
+	 */
+	if (NDISKS > 12) {
+		err += test(11, &tests);
+		err += test(12, &tests);
+	}
 	err += test(NDISKS, &tests);
 
 	pr("\n");

