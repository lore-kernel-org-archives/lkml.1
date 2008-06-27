Return-Path: <linux-kernel-owner+w=401wt.eu-S1764157AbYF0VUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764157AbYF0VUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758378AbYF0VUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:20:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:40096 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbYF0VUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:20:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kY+1gw/WvOvUfCOMwtSDa3PXM0ijJuu/crxxmq5RBZR3osE4TtYvm1nOtkefVTfZv0
         x84ByPoEsFpJ8oMPcb/o+QGAkqIYHS7xPhL6efuyIqGq6xi8pHg02SPF9Mf0YP+GM6Mj
         9TeHby/dytLmZuTB26pWZsL+JyEns7oqZy5WM=
Message-ID: <965f530d0806271420y7ffebd40xb9b2f9a035206932@mail.gmail.com>
Date: Fri, 27 Jun 2008 16:20:10 -0500
From: "Kiran Kotla" <kotlakiran@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: setting ICSK_CA_PRIV_SIZE larger than 16 * sizeof(u32)
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20080627.023046.193703830.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <965f530d0806270137y19c36638yc6ae0a1d4bfa63e7@mail.gmail.com>
	 <20080627.023046.193703830.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi david,

Thank you very much for your response. I am new to this forum and not
sure if I could include you in my reply.

Well, we tried our best to reduce the size of our private variables.

The major consumers of space however are two arrays of 32 bit integers
each of size '8', which are used to estimate drop probability and
early congestion response probability (our protocol specific), which
cannot be reduced to be 16 bit integers and further the size of the
array cannot be reduced to some value lesser without degrading the
estimation of drop probability.

I guess the only way left is to have a trade-off between the
performance of our protocol and size of the array.

In any case, I was wondering if still there is a way to increase the
size of the blob, though we would not to increase the size of blob to
get our protocol running in the kernel.

Thanks again!
Kiran

On Fri, Jun 27, 2008 at 4:30 AM, David Miller <davem@davemloft.net> wrote:
> From: "Kiran Kotla" <kotlakiran@gmail.com>
> Date: Fri, 27 Jun 2008 03:37:59 -0500
>
> [ Changed linux-net to netdev.  linux-net is for user questions,
>  netdev is for development discussion... ]
>
>> The only other option we have to get the kernel running with our
>> protocol is to reduce the number of private variables and this is not
>> possible without affecting the behavior of our protocol.
>
> I severely doubt this.  25 32-bit state variables is just way
> over the top.
>
> Don't give up so easily.  Maybe some values can be 16-bit instead
> of 32-bit.
>
> Perhaps pairs of two odd-sized values can be encoded into a single
> 32-bit (one is 7 bits, the other is <= 25 bits).
>
> Get creative.
>
> I'm going to be very much an asshole about making that blob any
> bigger, because it means every single socket in the kernel will get
> bigger even if they don't use your congestion control algorithm.
>
