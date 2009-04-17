Return-Path: <linux-kernel-owner+w=401wt.eu-S1761525AbZDQOlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525AbZDQOlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbZDQOlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:41:15 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:42980 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926AbZDQOlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:41:14 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Peter Holik" <peter@holik.at>
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
Date: Fri, 17 Apr 2009 16:41:32 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at>
In-Reply-To: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904171641.33546.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 17 April 2009 16:10:24 schrieb Peter Holik:

+static int intellon_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
+{
+       int len;
+
+       if (unlikely(skb->len < INTELLON_HEADER_SIZE)) {
+               deverr(dev, "unexpected tiny rx frame");
+               return 0;
+       }
+
+       len = (skb->data[skb->len - 2] | (skb->data[skb->len - 1] << 8));

Please use a conversion function.

+       } else {
+               struct sk_buff *skb2;
+
+               skb2 = skb_copy_expand(skb,
+                               INTELLON_HEADER_SIZE,
+                               need_tail,
+                               flags);
+               dev_kfree_skb_any(skb);
+               if (!skb2)
+                       return skb2;

If you return NULL in an error case, write it so explicitely.

+       __skb_push(skb, INTELLON_HEADER_SIZE);
+
+       skb->data[0] = pack_len & 0xFF;
+       skb->data[1] = (pack_len & 0x700) >> 8;

Again, a conversion function is called for.

	Regards
		Oliver

