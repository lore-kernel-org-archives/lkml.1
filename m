Return-Path: <linux-kernel-owner+w=401wt.eu-S932580AbXHXI7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbXHXI7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 04:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761775AbXHXI7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 04:59:18 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:48184 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761306AbXHXI7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 04:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=pQvc22P+AQto+pe/as9uSbuQQLUbvf3QhcWuioSLlPd+8/xE2OABpekuoanISHC19fwOlUcsdzn9ipArPXvJkWLJVYXAelaArHk6Clffvdv2SI8LhvD2CkS0JifB6VaZr35ZvqJHU5DHEx82YtobAE2hYWzqTZiSIfDSMyRML3A=
Message-ID: <46CE9DC2.8070407@gmail.com>
Date: Fri, 24 Aug 2007 16:58:42 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Question] the precondition of calling alloc_skb()/kfree_skb()?
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all:

I encountered a problem of using sk_buff.

I used 2.4.20 kernel, when burst traffic come, the kernel will complain
a bug report at skbuff.c:316 later:

311 void __kfree_skb(struct sk_buff *skb)
312 {
313 if (skb->list) {
314 printk(KERN_WARNING "Warning: kfree_skb passed an skb still "
315 "on a list (from %p).\n", NET_CALLER(skb));
316 BUG(); /* HERE!!! */
317 }
/* snip some code here */
332 }


I saw the dev_kfree_skb_irq() and dev_kfree_skb_irq(), and how to use
them. even, in fact, we work in pure poll I/O model, so the NIC can not
issue any interrupt.

And, I searched google, there are many similar reports like above, but
almost of them have no reply. I think there may have some unknown thing
while sk_buff API.

Well, I hope know, are there some preconditions of calling alloc_skb()
or *_kfree_skb_*() ? Thank in advanced.

Good luck.

- Yu Li

