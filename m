Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbZKFWGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbZKFWGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759993AbZKFWGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:06:03 -0500
Received: from kroah.org ([198.145.64.141]:39787 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759963AbZKFWF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:52 2009
Message-Id: <20091106215952.613942748@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Samuel Ortiz <samuel@sortiz.org>,
       "David S. Miller" <davem@davemloft.net>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: [20/30] irda: Add irda_skb_cb qdisc related padding
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=irda-add-irda_skb_cb-qdisc-related-padding.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Samuel Ortiz <samuel@sortiz.org>

commit 69c30e1e7492192f882a3fc11888b320fde5206a upstream.

We need to pad irda_skb_cb in order to keep it safe accross dev_queue_xmit()
calls. This is some ugly and temporary hack triggered by recent qisc code
changes.
Even though it fixes bugzilla.kernel.org bug #11795, it will be replaced by a
proper fix before 2.6.29 is released.

Signed-off-by: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/irda/irda_device.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/net/irda/irda_device.h
+++ b/include/net/irda/irda_device.h
@@ -135,9 +135,11 @@ struct dongle_reg {
 
 /* 
  * Per-packet information we need to hide inside sk_buff 
- * (must not exceed 48 bytes, check with struct sk_buff) 
+ * (must not exceed 48 bytes, check with struct sk_buff)
+ * The default_qdisc_pad field is a temporary hack.
  */
 struct irda_skb_cb {
+	unsigned int default_qdisc_pad;
 	magic_t magic;       /* Be sure that we can trust the information */
 	__u32   next_speed;  /* The Speed to be set *after* this frame */
 	__u16   mtt;         /* Minimum turn around time */


