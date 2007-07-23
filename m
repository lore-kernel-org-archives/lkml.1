Return-Path: <linux-kernel-owner+w=401wt.eu-S1760358AbXGWPlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358AbXGWPlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXGWPl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:41:29 -0400
Received: from sicnat2.emn.fr ([193.54.76.193]:44682 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752796AbXGWPl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:41:28 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dev->priv to netdev_priv(dev), drivers/net/tokenring/
References: <87r6mzmf6q.fsf@wanadoo.fr>
	<Pine.LNX.4.64.0707231712120.32367@fbirervta.pbzchgretzou.qr>
Date: Mon, 23 Jul 2007 17:38:39 +0200
In-Reply-To: <Pine.LNX.4.64.0707231712120.32367@fbirervta.pbzchgretzou.qr>
	(Jan Engelhardt's message of "Mon, 23 Jul 2007 17:13:07 +0200 (CEST)")
Message-ID: <87fy3fjfk0.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> On Jul 23 2007 15:18, Yoann Padioleau wrote:
>>
>>Here is an excerpt of the semantic patch that performs the transformation
>>
>>@@
>>
>>- (T*) dev->priv
>>+ netdev_priv(dev)
>
> Note that dev->priv is a void*, and hence does not need casting.
> So dev->priv may also appear without one.

Yes you are right. I have shown only an excerpt of the semantic patch.
Sorry. There is another rule:

@ rule3 depends on rule1 && !rule1bis @
struct net_device *dev;
@@

- dev->priv
+ netdev_priv(dev)


If you look at my patch there is one such case

-	struct tok_info *ti = dev->priv;
+	struct tok_info *ti = netdev_priv(dev);



