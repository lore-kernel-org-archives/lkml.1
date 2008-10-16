Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYJPPdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYJPPdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYJPPdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:33:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:61524 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYJPPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=uw0NZBp8yXuypaoMCf89sTBwUey/d0Lz1RwYCcZuoLElZ9yd49Bcs1DbbEa2SMH2jr
         Gyth+9gKJ6Atzzxu1n9mRg6JZTRx80SgipB952D+b1NgzKEqvSAT8VQBIhOKohN124v6
         wb5npzSlmN7Kn36HFHJhSyNuOmV3zePJcgRHU=
Date: Thu, 16 Oct 2008 16:33:14 +0100
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Martin Mares <mj@ucw.cz>, Andrew Morton <akpm@osdl.org>
Subject: [Patch] kernel/resource.c: fix printk format warnings
Message-ID: <20081016153314.GE13374@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixed the belowing warning:

/home/wangcong/Projects/linux-2.6/kernel/resource.c: In function
'__reserve_region_with_split':
/home/wangcong/Projects/linux-2.6/kernel/resource.c:554: warning:
format '%llx' expects type 'long long unsigned int', but argument 3
has type 'resource_size_t'
/home/wangcong/Projects/linux-2.6/kernel/resource.c:554: warning:
format '%llx' expects type 'long long unsigned int', but argument 4
has type 'resource_size_t'
/home/wangcong/Projects/linux-2.6/kernel/resource.c:554: warning:
format '%llx' expects type 'long long unsigned int', but argument 6
has type 'resource_size_t'
/home/wangcong/Projects/linux-2.6/kernel/resource.c:554: warning:
format '%llx' expects type 'long long unsigned int', but argument 7
has type 'resource_size_t'

Sigend-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Martin Mares <mj@ucw.cz>

---
diff --git a/kernel/resource.c b/kernel/resource.c
index 414d6fc..d218736 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -550,8 +550,10 @@ static void __init __reserve_region_with_split(struct resource *root,
 
 	if (!res) {
 		printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
-			 conflict->name, conflict->start, conflict->end,
-			 name, start, end);
+			 conflict->name, (unsigned long long)conflict->start,
+			 (unsigned long long)conflict->end,
+			 name, (unsigned long long)start,
+			 (unsigned long long)end);
 
 		/* failed, split and try again */
 
