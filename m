Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbXGDQfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbXGDQfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 12:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbXGDQff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 12:35:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:62196 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbXGDQfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 12:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=NYhFRSNeXiqBBk+/s9aJV/Swzbn1IsWHTqwd3nN1uxY3Nc5kbynMwIaea1felxiF/C+CZopdYAmllaNJRXJ5QH2AhNRC35z0pEL2/k4mcrCtgBDBq4bTLHut16LgiLv+VMkunMz02rnQWnTOhf1C8Ylv/EKT+o6s5gcIH6FyPmg=
Date: Thu, 5 Jul 2007 00:37:41 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: rolandd@cisco.com, mshefty@ichips.intel.com, halr@voltaire.com
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [-mm Patch] INFINIBAND: check the return value of kmalloc
Message-ID: <20070704163741.GA2510@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Don't forget to check the return value of kmalloc().

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

Index: linux-2.6.22-rc6-mm1/drivers/infiniband/hw/cxgb3/iwch_provider.c
===================================================================
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c	2007-06-29 13:18:20.000000000 +0800
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c	2007-07-04 23:17:02.000000000 +0800
@@ -1166,6 +1166,10 @@
 	dev->ibdev.iwcm =
 	    (struct iw_cm_verbs *) kmalloc(sizeof(struct iw_cm_verbs),
 					   GFP_KERNEL);
+	if (!dev->ibdev.iwcm) {
+		ret = -1;
+		goto bail1;
+	}
 	dev->ibdev.iwcm->connect = iwch_connect;
 	dev->ibdev.iwcm->accept = iwch_accept_cr;
 	dev->ibdev.iwcm->reject = iwch_reject_cr;
