Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbZIGDg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbZIGDg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 23:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758722AbZIGDg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 23:36:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35002 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbZIGDgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 23:36:25 -0400
Date: Mon, 7 Sep 2009 13:36:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
       H Hartley Sweeten <hartleys@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: linux-next: manual merge of the mtd tree with the i2c tree
Message-Id: <20090907133621.3b4d4ce3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Today's linux-next merge of the mtd tree got a conflict in
drivers/mtd/mtdcore.c between commit
c6ce12828f9146f12d0654241bcb39523c257c90 ("driver model: constify
attribute groups") from the i2c tree and commit
fca910883324d437a24d447b08f524fa19261a94 ("mtd: make few symbols static")
from the mtd tree.

Just overlapping changes.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/mtdcore.c
index 69007a6,3f559c0..0000000
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@@ -217,7 -217,7 +217,7 @@@ static struct attribute_group mtd_grou
  	.attrs		= mtd_attrs,
  };
  
- const struct attribute_group *mtd_groups[] = {
 -static struct attribute_group *mtd_groups[] = {
++static const struct attribute_group *mtd_groups[] = {
  	&mtd_group,
  	NULL,
  };
