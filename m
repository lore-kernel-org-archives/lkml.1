Return-Path: <linux-kernel-owner+w=401wt.eu-S1161406AbXBZXVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161406AbXBZXVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161405AbXBZXVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:21:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52273
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1161403AbXBZXVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:21:17 -0500
Date: Mon, 26 Feb 2007 15:21:15 -0800 (PST)
Message-Id: <20070226.152115.25475996.davem@davemloft.net>
To: kronos.it@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG][2.6.21] af_key: kernel BUG at net/core/skbuff.c:93
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070226220841.GA7727@dreamland.darkstar.lan>
References: <20070226220841.GA7727@dreamland.darkstar.lan>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luca Tettamanti <kronos.it@gmail.com>
Date: Mon, 26 Feb 2007 23:08:41 +0100

> skb_over_panic: text:f1b8a065 len:16 put:16 head:b1a3ba00 data:b1a3ba00 tail:b1a
> 3ba00 end:b1a3ba90 dev:<NULL>

This panic message doesn't make any sense, it should not have
triggered.  skb_put() calls skb_over_panic() when:

	if (unlikely(skb->tail>skb->end))
		skb_over_panic(skb, len, current_text_addr());

but from the panic message it says:

tail:b1a3ba00
end:b1a3ba90

tail is certainly not greater than end.
