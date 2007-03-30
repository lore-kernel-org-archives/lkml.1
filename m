Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbXC3IAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbXC3IAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 04:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbXC3IAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 04:00:23 -0400
Received: from mail.dsa-ac.de ([62.112.80.99]:34359 "EHLO mail.dsa-ac.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbXC3IAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 04:00:22 -0400
X-Greylist: delayed 1681 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2007 04:00:21 EDT
Date: Fri, 30 Mar 2007 09:32:17 +0200 (CEST)
From: Guennadi Liakhovetski <gl@dsa-ac.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [git patches] net driver fixes
In-Reply-To: <460BB03F.6040003@garzik.org>
Message-ID: <Pine.LNX.4.63.0703300922490.534@pcgl.dsa-ac.de>
References: <20070323065742.GA17613@havoc.gtf.org> <Pine.LNX.4.60.0703232254170.5971@poirot.grange>
 <460BB03F.6040003@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007, Jeff Garzik wrote:

> Guennadi Liakhovetski wrote:
>> Jeff, might be worth getting the sk_buff leak fix in ppp from 
>> http://www.spinics.net/lists/netdev/msg27706.html in 2.6.21 too?
>> 
>> Don't know how important it is for stable. It was present in 2.6.18 too.
>
> Can you resend the patch to me, please?
>
> Easier for the system to apply than the URL...

Sure, attached below. I think, though, this patch is already in someone's 
tree. Andrew has applied it to -mm under the name

ppp-dont-leak-an-sk_buff-on-interface-destruction.patch

but then dropped with the reasoning "This patch was dropped because it was 
merged into mainline or a subsystem tree". So, maybe it is now in Samuel's 
IrDA tree. Samuel?So, maybe all you have to do is to pull it from his 
tree.

Thanks
Guennadi
---------------------------------
Guennadi Liakhovetski, Ph.D.
DSA Daten- und Systemtechnik GmbH
Pascalstr. 28
D-52076 Aachen
Germany

Don't leak an sk_buff on interface destruction.

Signed-off-by: G. Liakhovetski <gl@dsa-ac.de>

--- a/drivers/net/ppp_generic.c	2007-03-23 13:04:04.000000000 +0100
+++ b/drivers/net/ppp_generic.c	2007-03-23 13:05:29.000000000 +0100
@@ -2544,6 +2544,9 @@
  	ppp->active_filter = NULL;
  #endif /* CONFIG_PPP_FILTER */

+	if (ppp->xmit_pending)
+		kfree_skb(ppp->xmit_pending);
+
  	kfree(ppp);
  }

