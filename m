Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbZKDCnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbZKDCnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZKDCnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:43:24 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:41841 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbZKDCnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:43:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=iRCOftC2tFpGEbbMRwfKcHNcCzSut732UbDJZQyBfJlqpDPPkGQ1Is+wni7JtCfce+
         z8ddwkxxQ9/vP2ApF8/Mlo+rbqNf/E/BkyveDtWoRonfXd/4VsmprQx+XTHEah/CkjiQ
         WbyXxiQRHPkugeraUafg/y7tkZytHREO1J6Ak=
Subject: [PATCH] mm/ksm.c: Fix compile warnings
From: askb <askb23@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Nov 2009 08:11:42 +0530
Message-Id: <1257302502.14838.19.camel@linux-k65f.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found the compiler warning on linux-next:

mm/ksm.c: In function ‘ksm_scan_thread’:
mm/ksm.c:1083: warning: ‘page2[0u]’ may be used uninitialized in this
function
mm/ksm.c:1083: note: ‘page2[0u]’ was declared here


fix for the above warning:

Signed-off-by: Anil SB <askb23@gmail.com>

diff --git a/mm/ksm.c b/mm/ksm.c
index bef1af4..2ea0fd3 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1080,7 +1080,7 @@ static void stable_tree_append(struct rmap_item
*rmap_item,
  */
static void cmp_and_merge_page(struct page *page, struct rmap_item
*rmap_item)
{
- struct page *page2[1];
+ struct page *page2[1] = {NULL};
struct rmap_item *tree_rmap_item;
unsigned int checksum;
int err;

Thanks


