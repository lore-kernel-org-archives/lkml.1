Return-Path: <linux-kernel-owner+w=401wt.eu-S1750926AbXE1JxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750926AbXE1JxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbXE1JxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:53:09 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:60977 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbXE1JxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:53:07 -0400
Date: Mon, 28 May 2007 11:50:32 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: rae l <crquan@gmail.com>
cc: "David S. Miller" <davem@davemloft.net>,
       Networking Team <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <trivial@kernel.org>
Subject: Re: [PATCH] merge dst_discard in & out into one, this decrements
 the vmlinux image by 21 bytes under i386 arch.
In-Reply-To: <91b13c310705271941n48e266b9vc202b862ad4fabba@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705281150010.11140@yvahk01.tjqt.qr>
References: <91b13c310705271941n48e266b9vc202b862ad4fabba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 28 2007 10:41, rae l wrote:
>
> diff --git a/net/core/dst.c b/net/core/dst.c
> index 764bccb..daa0439 100644
> --- a/net/core/dst.c
> +++ b/net/core/dst.c
> @@ -111,17 +111,14 @@ out:
>      spin_unlock(&dst_lock);
> }
>
> -static int dst_discard_in(struct sk_buff *skb)
> +static int dst_discard(struct sk_buff *skb)
> {
> kfree_skb(skb);
> return 0;
> }
>
> -static int dst_discard_out(struct sk_buff *skb)
> -{
> -       kfree_skb(skb);
> -       return 0;
> -}
> +#define dst_discard_in dst_discard
> +#define dst_discard_out        dst_discard

Uhm, just replace every invocation of dst_discard_in/_out() directly
by dst_discard ... don't add macros for that.


>
> void * dst_alloc(struct dst_ops * ops)
> {
>
>

	Jan
-- 
