Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab0CCIXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 03:23:05 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42654 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0CCIXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 03:23:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=vkahoyrcbCA6Fb0MTrbPuwh9bCZWHphMsp898sLdi6H+iuF+MI0YWTlTmbSyR+th97
         rZEQ7yuGMf4Ch/u1lEYOZ5FSV00ecfO/i1I7/01KK0Rbo5QFsS3LYBQfNBdkNdjc1rgl
         HxVuYS/uU36KJsVRKHdyH0L1XZOOxXwxD4UPU=
Date: Wed, 3 Mar 2010 11:22:41 +0300
From: Dan Carpenter <error27@gmail.com>
To: netdev@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yang Hongyang <yanghy@cn.fujitsu.com>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] cassini: fix off by one
Message-ID: <20100303082241.GA32640@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, netdev@vger.kernel.org,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yang Hongyang <yanghy@cn.fujitsu.com>,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are only 6 link_modes.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index 7cbcfb0..9bd155e 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -5072,7 +5072,7 @@ static int __devinit cas_init_one(struct pci_dev *pdev,
 	INIT_WORK(&cp->reset_task, cas_reset_task);
 
 	/* Default link parameters */
-	if (link_mode >= 0 && link_mode <= 6)
+	if (link_mode >= 0 && link_mode < 6)
 		cp->link_cntl = link_modes[link_mode];
 	else
 		cp->link_cntl = BMCR_ANENABLE;
