Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZKLSs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZKLSs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZKLSs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:48:26 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:15515 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbZKLSsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:48:23 -0500
Subject: [PATCH 08/11] cciss: Remove unnecessary check in scan_thread
To: axboe@kernel.dk, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, achiang@hp.com,
       brace@beardog.cce.hp.com
Date: Thu, 12 Nov 2009 12:49:50 -0600
Message-ID: <20091112184950.23389.43425.stgit@beardog.cce.hp.com>
In-Reply-To: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
References: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: Remove unnecessary check in scan_thread

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 23c2910..42eaddb 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3386,13 +3386,11 @@ static int scan_thread(void *data)
 			h->busy_scanning = 1;
 			mutex_unlock(&scan_mutex);
 
-			if (h) {
-				rebuild_lun_table(h, 0, 0);
-				complete_all(&h->scan_wait);
-				mutex_lock(&scan_mutex);
-				h->busy_scanning = 0;
-				mutex_unlock(&scan_mutex);
-			}
+			rebuild_lun_table(h, 0, 0);
+			complete_all(&h->scan_wait);
+			mutex_lock(&scan_mutex);
+			h->busy_scanning = 0;
+			mutex_unlock(&scan_mutex);
 		}
 	}
 

