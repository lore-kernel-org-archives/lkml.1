Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbXDDRsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbXDDRsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXDDRsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:48:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:10681 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbXDDRsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=bdvKPD+gG04uddNW9FNJSqCZqjDJKZVQc3hRZ1XWUcjeXKxvinmALQoK6orp/kcku7Wwt+9puHuqnSACExL82hQO5b66NDLlJWRs180dc9fbhG3f3j4QxJ3c9feAGVLaUUAhcQGI4+6WKcY9CxqGEWmSi4Qx2nL7qwZDDn+9Szk=
Date: Wed, 4 Apr 2007 23:19:44 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-ppp@vger.kernel.org, paulus@samba.org
Subject: [KJ][PATCH]ROUND_UP macro cleanup in drivers/net/ppp_generic.c
Message-ID: <20070404174944.GC9830@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ROUND_UP macro cleanup use DIV_ROUND_UP

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 ppp_generic.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index ef58e41..4b302f3 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -88,8 +88,6 @@ struct ppp_file {
 #define PF_TO_PPP(pf)		PF_TO_X(pf, struct ppp)
 #define PF_TO_CHANNEL(pf)	PF_TO_X(pf, struct channel)
 
-#define ROUNDUP(n, x)		(((n) + (x) - 1) / (x))
-
 /*
  * Data structure describing one ppp unit.
  * A ppp unit corresponds to a ppp network interface device
@@ -1297,7 +1295,7 @@ static int ppp_mp_explode(struct ppp *ppp, struct sk_buff *skb)
 	 */
 	fragsize = len;
 	if (nfree > 1)
-		fragsize = ROUNDUP(fragsize, nfree);
+		fragsize = DIV_ROUND_UP(fragsize, nfree);
 	/* nbigger channels get fragsize bytes, the rest get fragsize-1,
 	   except if nbigger==0, then they all get fragsize. */
 	nbigger = len % nfree;
---
Milind Arun Choudhary
