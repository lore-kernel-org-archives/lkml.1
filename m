Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703Ab0ALSNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0ALSNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591Ab0ALSNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:13:39 -0500
Received: from smtp.nokia.com ([192.100.122.233]:43333 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab0ALSNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:13:37 -0500
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
Subject: [PATCH] vgaarb: fix trylock behaviour accordingly vga_tryget return value
Date: Tue, 12 Jan 2010 19:58:32 +0200
Message-Id: <1263319113-6631-2-git-send-email-tiago.vignatti@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1263319113-6631-1-git-send-email-tiago.vignatti@nokia.com>
References: <1263319113-6631-1-git-send-email-tiago.vignatti@nokia.com>
X-OriginalArrivalTime: 12 Jan 2010 18:12:54.0181 (UTC) FILETIME=[DC3B3550:01CA93B2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henry Zhao <Henry.Zhao@Sun.COM>

Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
---
Henry, can you Signed-off-by there?

 drivers/gpu/vga/vgaarb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 2f6cf69..0f5f64d 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -935,7 +935,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 			goto done;
 		}
 
-		if (vga_tryget(pdev, io_state)) {
+		if (!vga_tryget(pdev, io_state)) {
 			/* Update the client's locks lists... */
 			for (i = 0; i < MAX_USER_CARDS; i++) {
 				if (priv->cards[i].pdev == pdev) {
-- 
1.6.0.4

