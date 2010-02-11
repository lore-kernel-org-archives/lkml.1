Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab0BKIo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 03:44:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:55727 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab0BKIo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 03:44:26 -0500
Message-ID: <4B73C4DE.6000507@kernel.org>
Date: Thu, 11 Feb 2010 17:50:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: Andy Isaacson <adi@hexapodia.org>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc6-git regression] idr fix breaks Xorg
References: <20100204012837.GC538@hexapodia.org> <20100204075642.GA28286@hexapodia.org> <4B6A8278.8070001@kernel.org> <89k83a$756q97@azsmga001.ch.intel.com>
In-Reply-To: <89k83a$756q97@azsmga001.ch.intel.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Feb 2010 08:43:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Can you please test the following patch on top of the current
mainline?  Thanks.

diff --git a/lib/idr.c b/lib/idr.c
index 1cac726..0dc7822 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -156,10 +156,12 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
 
 			/* if already at the top layer, we need to grow */
-			if (!(p = pa[l])) {
+			if (id >= 1 << (idp->layers * IDR_BITS)) {
 				*starting_id = id;
 				return IDR_NEED_TO_GROW;
 			}
+			p = pa[l];
+			BUG_ON(!p);
 
 			/* If we need to go up one layer, continue the
 			 * loop; otherwise, restart from the top.

-- 
tejun
