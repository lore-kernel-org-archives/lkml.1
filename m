Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbZGNGdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbZGNGdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 02:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbZGNGdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 02:33:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33422 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbZGNGdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 02:33:11 -0400
Date: Tue, 14 Jul 2009 16:33:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: linux-next: driver-core tree build failure
Message-Id: <20090714163309.f2ee320d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/mtd/mtdcore.c:220: error: expected '{' before 'const'
drivers/mtd/mtdcore.c:227: error: 'mtd_groups' undeclared here (not in a function)

Caused by the update to commit ba87b739a1f5dd545679d886b8d193cdede991cf
("driver model: constify attribute groups").

I have applied the patch below for today.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 14 Jul 2009 16:29:39 +1000
Subject: [PATCH] driver-core: fix for mtd typo

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mtd/mtdcore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 93e6731..05a16be 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -217,7 +217,7 @@ struct attribute_group mtd_group = {
 	.attrs		= mtd_attrs,
 };
 
-struct const attribute_group *mtd_groups[] = {
+const struct attribute_group *mtd_groups[] = {
 	&mtd_group,
 	NULL,
 };
-- 
1.6.3.3

