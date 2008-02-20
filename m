Return-Path: <linux-kernel-owner+w=401wt.eu-S935408AbYBTQf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935408AbYBTQf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933415AbYBTQTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:19:40 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:46322 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933410AbYBTQTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:19:38 -0500
Date: Wed, 20 Feb 2008 17:19:37 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH 3/8] [NET]: uninline dev_alloc_skb, de-bloats a lot
In-Reply-To: <1203515238-22848-4-git-send-email-ilpo.jarvinen@helsinki.fi>
Message-ID: <Pine.LNX.4.64.0802201651580.26109@fbirervta.pbzchgretzou.qr>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-3-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-4-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 20 2008 15:47, Ilpo Järvinen wrote:
>
>-23668  392 funcs, 104 +, 23772 -, diff: -23668 --- dev_alloc_skb
>
>-static inline struct sk_buff *dev_alloc_skb(unsigned int length)
>-{
>-	return __dev_alloc_skb(length, GFP_ATOMIC);
>-}
>+extern struct sk_buff *dev_alloc_skb(unsigned int length);

Striking. How can this even happen? A callsite which calls

	dev_alloc_skb(n)

is just equivalent to

	__dev_alloc_skb(n, GFP_ATOMIC);

which means there's like 4 (or 8 if it's long) bytes more on the
stack. For a worst case, count in another 8 bytes for push and pop or mov on
the stack. But that still does not add up to 23 kb.
