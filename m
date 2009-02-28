Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbZB1Fy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbZB1Fy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 00:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbZB1FyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 00:54:21 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:33071 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZB1FyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 00:54:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PZVBiXJDv0Xm/Pk7mnmkKE4yXj2f7USRhc8kincpGZJVxO7rD1BdFhLsXATD4pbgXl
         XvXYhkBYkFAkdFQwztbPsGygFWHFBHfNB1+2Xd4p/AN0L1huN9CwAV2DzTIH/pnot3Mg
         AJoIueixWWgc5YFkslLoi/s5QXAeXvg0GM6Eg=
MIME-Version: 1.0
In-Reply-To: <1235797347-1816-1-git-send-email-gustavo@las.ic.unicamp.br>
References: <1235797347-1816-1-git-send-email-gustavo@las.ic.unicamp.br>
Date: Sat, 28 Feb 2009 02:54:16 -0300
X-Google-Sender-Auth: 8cf84e99b0ed8030
Message-ID: <6b53b1990902272154k3cf6416fr68e53119c9a25ee0@mail.gmail.com>
Subject: Re: [PATCH 1/3] bluetooth: add write_lock_bh to __l2cap_chan_link
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 2:02 AM, Gustavo F. Padovan
<gustavo@las.ic.unicamp.br> wrote:
> fix race condition
>
> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
> ---
>  net/bluetooth/l2cap.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
> index ca4d3b4..355f375 100644
> --- a/net/bluetooth/l2cap.c
> +++ b/net/bluetooth/l2cap.c
> @@ -175,12 +175,14 @@ static inline void __l2cap_chan_link(struct l2cap_chan_list *l, struct sock *sk)
>  {
>        sock_hold(sk);
>
> +       write_lock_bh(&l->lock);
>        if (l->head)
>                l2cap_pi(l->head)->prev_c = sk;
>
>        l2cap_pi(sk)->next_c = l->head;
>        l2cap_pi(sk)->prev_c = NULL;
>        l->head = sk;
> +       write_unlock_bh(&l->lock);
>  }
>
>  static inline void l2cap_chan_unlink(struct l2cap_chan_list *l, struct sock *sk)



This patch is wrong, ignore it.


> --
> 1.6.0.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Gustavo F. Padovan

Computer Engineering Student
Institute of Computing - IC
University of Campinas - UNICAMP

email: gustavo@las.ic.unicamp.br
gtalk: gfpadovan@gmail.com
mobile: +55 19 81030803
