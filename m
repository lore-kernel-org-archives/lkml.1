Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZB1Vdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZB1Vdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 16:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbZB1Vde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 16:33:34 -0500
Received: from senator.holtmann.net ([87.106.208.187]:45022 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbZB1Vde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 16:33:34 -0500
Subject: Re: [PATCH 1/3] bluetooth: add write_lock_bh to __l2cap_chan_link
From: Marcel Holtmann <marcel@holtmann.org>
To: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1235797347-1816-1-git-send-email-gustavo@las.ic.unicamp.br>
References: <1235797347-1816-1-git-send-email-gustavo@las.ic.unicamp.br>
Content-Type: text/plain
Date: Sat, 28 Feb 2009 22:33:18 +0100
Message-Id: <1235856798.6074.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

> fix race condition
> 
> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
> ---
>  net/bluetooth/l2cap.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
> index ca4d3b4..355f375 100644
> --- a/net/bluetooth/l2cap.c
> +++ b/net/bluetooth/l2cap.c
> @@ -175,12 +175,14 @@ static inline void __l2cap_chan_link(struct l2cap_chan_list *l, struct sock *sk)
>  {
>  	sock_hold(sk);
>  
> +	write_lock_bh(&l->lock);
>  	if (l->head)
>  		l2cap_pi(l->head)->prev_c = sk;
>  
>  	l2cap_pi(sk)->next_c = l->head;
>  	l2cap_pi(sk)->prev_c = NULL;
>  	l->head = sk;
> +	write_unlock_bh(&l->lock);
>  }

a general rule of thumb is that function starting with __ are the ones
that don't use any kind of locking.

Regards

Marcel


