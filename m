Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366Ab0BPVSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 16:18:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45645 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab0BPVSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 16:18:47 -0500
Date: Tue, 16 Feb 2010 16:18:37 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: airlied@redhat.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       james.getzendanner@students.olin.edu, stable@kernel.org
Subject: [PATCH] vgaarb: fix "target=default" passing
Message-ID: <20100216211837.GM24051@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Commit 77c1ff3982c6b36961725dd19e872a1c07df7f3b fixed the userspace
pointer dereference, but introduced another bug pointed out by Eugene Teo
in RH bug #564264. Instead of comparing the point we were at in the string,
we instead compared the beginning of the string to "default".

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Reported-by: Eugene Teo <eteo@redhat.com>
---
 drivers/gpu/vga/vgaarb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 24b56dc..2f6cf69 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -961,7 +961,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		remaining -= 7;
 		pr_devel("client 0x%p called 'target'\n", priv);
 		/* if target is default */
-		if (!strncmp(kbuf, "default", 7))
+		if (!strncmp(curr_pos, "default", 7))
 			pdev = pci_dev_get(vga_default_device());
 		else {
 			if (!vga_pci_str_to_vars(curr_pos, remaining,
-- 
1.6.6

