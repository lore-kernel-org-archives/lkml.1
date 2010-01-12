Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689Ab0ALSNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0ALSNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591Ab0ALSNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:13:37 -0500
Received: from smtp.nokia.com ([192.100.122.233]:43331 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab0ALSNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:13:36 -0500
From: Tiago Vignatti <tiago.vignatti@nokia.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Paulo R. Zanoni" <przanoni@gmail.com>, Henry Zhao <Henry.Zhao@Sun.COM>,
       Andy Getzendanner <james.getzendanner@students.olin.edu>,
       Brad Spengler <spender@grsecurity.net>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>
Subject: [PATCH] vgaarb: fix typo deference when copying from userspace
Date: Tue, 12 Jan 2010 19:58:31 +0200
Message-Id: <1263319113-6631-1-git-send-email-tiago.vignatti@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 12 Jan 2010 18:12:47.0125 (UTC) FILETIME=[D8068C50:01CA93B2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brad Spengler <spender@grsecurity.net>

libpciaccess is not triggering such code though.

Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
---
Andy Getzendanner tried to fix this, but he seems did a wrong approach:
http://marc.info/?l=linux-kernel&m=126112173704466

Andy: please test (and put your tag review!) this one instead. Thanks.

 drivers/gpu/vga/vgaarb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 1ac0c93..2f6cf69 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -961,7 +961,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		remaining -= 7;
 		pr_devel("client 0x%p called 'target'\n", priv);
 		/* if target is default */
-		if (!strncmp(buf, "default", 7))
+		if (!strncmp(curr_pos, "default", 7))
 			pdev = pci_dev_get(vga_default_device());
 		else {
 			if (!vga_pci_str_to_vars(curr_pos, remaining,
-- 
1.6.0.4

