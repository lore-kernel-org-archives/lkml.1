Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbXIIUbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbXIIUbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759545AbXIIUZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:25:55 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60765 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759473AbXIIUZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:25:54 -0400
Date: Sun, 9 Sep 2007 22:26:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make do_try_to_free_pages() static
Message-ID: <20070909202601.GA3563@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc3-mm1:
>...
> +memory-controller-add-per-container-lru-and-reclaim-v7.patch
>...
>  memory containment
>...

do_try_to_free_pages() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
23781fa6792c518c8581ceeaf08db251574e8430 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b34b29d..9104cf8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1248,8 +1248,8 @@ static unsigned long shrink_zones(int priority, struct zone **zones,
  * holds filesystem locks which prevent writeout this might not work, and the
  * allocation attempt will fail.
  */
-unsigned long do_try_to_free_pages(struct zone **zones, gfp_t gfp_mask,
-					struct scan_control *sc)
+static unsigned long do_try_to_free_pages(struct zone **zones, gfp_t gfp_mask,
+					  struct scan_control *sc)
 {
 	int priority;
 	int ret = 0;

