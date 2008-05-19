Return-Path: <linux-kernel-owner+w=401wt.eu-S1763510AbYESUm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763510AbYESUm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762622AbYESUmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:42:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:33321 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762417AbYESUmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:42:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TZfq8Sn97YF9y5NOAsbmwPh9vysW5qLP0/sfV9NMtwJRKTNjqe87HL6kS/EneNTk4nq7INGtzzG7GSO75+rjTxagMxaEVYxvT9iEZ4K+tDZyFnYHToQWENeZ5zPuY/0sSRt3zyQsGlFdqjjM9pm2t2AZd3i5YntWp5paBIcXH6E=
Subject: Re: [PATCH 1/2] bitreversal program
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
Cc: linux-kernel@vger.kernel.org, akinobu.mita@gmail.com
In-Reply-To: <Pine.LNX.4.64.0805191859411.18461@visualserver.org>
References: <Pine.LNX.4.64.0805191859411.18461@visualserver.org>
Content-Type: text/plain
Date: Mon, 19 May 2008 13:42:15 -0700
Message-Id: <1211229736.5915.86.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 19:04 +0200, Soumyadip Das Mahapatra wrote:
> --- a/include/linux/bitrev.h    2008-04-17 08:19:44.000000000 +0530
> +++ b/include/linux/bitrev.h    2008-05-19 21:49:46.000000000 +0530
> @@ -3,11 +3,32 @@
> 
>   #include <linux/types.h>
> 
> -extern u8 const byte_rev_table[256];
> +/**
> + * Here is a generalised bit reversal program
> + * @x: word to get bits reversed
> + * @k: key, explained below
> + * for k = 31, it reverses the bits of word(32 bit)
> + * for k = 24, it reverses the bytes in word
> + * for k = 7, it reverses the bits in every byte without
> + * changing the positions of bytes in a word
> + * and for k = 16 it swaps the left and right halves of a
> + * word
> + */
> 
> -static inline u8 bitrev8(u8 byte)

What about anybody who currently uses bitrev8?

> +static inline u32 gen_bit_rev(u32 x, u32 k)
>   {
> -       return byte_rev_table[byte];
> +       if(k & 1)
> +               x = (x & 0x55555555) << 1 | (x & 0xaaaaaaaa) >> 1;
> +       if(k & 2)
> +               x = (x & 0x33333333) << 2 | (x & 0xcccccccc) >> 2;
> +       if(k & 4)
> +               x = (x & 0x0f0f0f0f) << 4 | (x & 0xf0f0f0f0) >> 4;
> +       if(k & 8)
> +               x = (x & 0x00ff00ff) << 8 | (x & 0xff00ff00) >> 8;
> +       if(k & 16)
> +               x = (x & 0x0000ffff) << 16 | (x & 0xffff0000) >> 16;
> +
> +       return x;
>   }

Why is this better than a single 256 byte table?

Harvey

