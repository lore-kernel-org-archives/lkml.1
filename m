Return-Path: <linux-kernel-owner+w=401wt.eu-S934770AbXJSFCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934770AbXJSFCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 01:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760136AbXJSFCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 01:02:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:27526 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbXJSFCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 01:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=HXpTU5j8fbvaTnbH6YOYhLarJ8w9rpXdAH7yikR9/+o/Iy3lEWcqwzgHMEKzPTjDjEsaABRLBgpSh11tf8LeIzBjrT+wutptYn7OokZMyZFbfsk58i5yWDLtFBElFa89xx4YSZOLeXiCBvIIl/KwYtj6RJd1HJ5XPZ5MEXpI2tk=
Date: Fri, 19 Oct 2007 13:00:58 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: bluez-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] bluetooth: hidp core debug code wrong argument fix
Message-ID: <20071019050057.GA8734@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the debug code of the hidp_queue_report function, the "device" variable does not exist, replace it with "session->hid"

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
net/bluetooth/hidp/core.c |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff -upr linux/net/bluetooth/hidp/core.c linux.new/net/bluetooth/hidp/core.c
--- linux/net/bluetooth/hidp/core.c	2007-10-15 14:05:23.000000000 +0800
+++ linux.new/net/bluetooth/hidp/core.c	2007-10-15 14:06:38.000000000 +0800
@@ -247,7 +247,7 @@ static inline int hidp_queue_report(stru
 {
 	struct sk_buff *skb;
 
-	BT_DBG("session %p hid %p data %p size %d", session, device, data, size);
+	BT_DBG("session %p hid %p data %p size %d", session, session->hid, data, size);
 
 	if (!(skb = alloc_skb(size + 1, GFP_ATOMIC))) {
 		BT_ERR("Can't allocate memory for new frame");
