Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbZDRHQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbZDRHQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 03:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZDRHQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 03:16:29 -0400
Received: from mail.it-technology.at ([62.99.145.147]:54066 "EHLO
	mail.it-technology.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZDRHQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 03:16:29 -0400
Message-ID: <8472e581ef388a89b5ee8a7ed8dd1fdc.squirrel@webmail.it-technology.at>
In-Reply-To: <200904171641.33546.oliver@neukum.org>
References: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at>
    <200904171641.33546.oliver@neukum.org>
Date: Sat, 18 Apr 2009 09:16:28 +0200 (CEST)
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
From: "Peter Holik" <peter@holik.at>
To: "Oliver Neukum" <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Am Freitag 17 April 2009 16:10:24 schrieb Peter Holik:
>
> +static int intellon_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
> +{
> +       int len;
> +
> +       if (unlikely(skb->len < INTELLON_HEADER_SIZE)) {
> +               deverr(dev, "unexpected tiny rx frame");
> +               return 0;
> +       }
> +
> +       len = (skb->data[skb->len - 2] | (skb->data[skb->len - 1] << 8));
>
> Please use a conversion function.

do you mean

len = le16_to_cpu(skb->data[skb->len - 2] | (skb->data[skb->len - 1] << 8));

> +       } else {
> +               struct sk_buff *skb2;
> +
> +               skb2 = skb_copy_expand(skb,
> +                               INTELLON_HEADER_SIZE,
> +                               need_tail,
> +                               flags);
> +               dev_kfree_skb_any(skb);
> +               if (!skb2)
> +                       return skb2;
>
> If you return NULL in an error case, write it so explicitely.

ok

> +       __skb_push(skb, INTELLON_HEADER_SIZE);
> +
> +       skb->data[0] = pack_len & 0xFF;
> +       skb->data[1] = (pack_len & 0x700) >> 8;
>
> Again, a conversion function is called for.

is this correct

  __le16 *len;
.
.
.
  pack_len &= 0x07ff;

  len = (__le16 *) __skb_push(skb, INT51X1_HEADER_SIZE);
  *len = cpu_to_le16(pack_len);


cu Peter

