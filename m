Return-Path: <linux-kernel-owner+w=401wt.eu-S1762354AbXEVJIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762354AbXEVJIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbXEVJIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:08:37 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:26244 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbXEVJIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:08:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YS+koHwrzxO2j60rB7ONSIrOBDXimJj3P/j4Phxh2B9K7yTr+AG7yjOKUv1BYBqmTim02uMojdpNtN7IwxBBSW4NPPrp0QG5xbjgAUAeyxDckvVRszSNHjVBk4p7LSWMqPEb5rQt80SgxAsyrmNHbjhMeYtpuGMXqD2nGNBXBz0=
Message-ID: <4cefeab80705220208w2200b2f1x1d7a8c7e0c01dfb9@mail.gmail.com>
Date: Tue, 22 May 2007 14:38:35 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Andrey Panin" <pazke@donpac.ru>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] LZO1X de/compression support
Cc: "Richard Purdie" <richard@openedhand.com>
In-Reply-To: <20070518111107.GA27003@pazke.donpac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
	 <20070518111107.GA27003@pazke.donpac.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 5/18/07, Andrey Panin <pazke@donpac.ru> wrote:
> On 138, 05 18, 2007 at 03:28:31PM +0530, Nitin Gupta wrote:
> > +     register const unsigned char *ip;
>
> register keyword is meaningless for today's compiler.

But can we assume that gcc is being used? What if we use compiler for
which it does matter (can't give example for this...)?

>
> > +     unsigned char *op;
> > +     const unsigned char * const in_end = in + in_len;
> > +     const unsigned char * const ip_end = in + in_len - M2_MAX_LEN - 5;
> > +     const unsigned char *ii;
> > +     const unsigned char ** const dict = (const unsigned char **)workmem;
> > +
> > +     op = out;
>
> Why not write this as `unsigned char *op = out;` ?
>

Done.

> Empty if() body ?

No empty if() now.

> > +                     m_off -= 0x4000;
>
> What's this magic number 0x4000 repeated everywhere ? M3_MAX_OFFSET perhaps ?

I don't know :)

> > +#if defined(__LITTLE_ENDIAN)
> > +                             m_pos = op - 1;
> > +                             m_pos -= (*(const unsigned short *)ip) >> 2;
> > +#else
> > +                             m_pos = op - 1;
> > +                             m_pos -= (ip[0] >> 2) + (ip[1] << 6);
> > +#endif
>
> IMHO you could write it this way:
>
> m_pos = op - 1 - (le16_to_cpu(*(const u16 *)ip) >> 2);
>

Shouldn't this be cpu_to_le16() ?


> > +#if defined(__LITTLE_ENDIAN)
> > +                             m_pos -= (*(const unsigned short *)ip) >> 2;
> > +#else
> > +                             m_pos -= (ip[0] >> 2) + (ip[1] << 6);
> > +#endif
>
> m_pos -= le16_to_cpu(*(const u16 *)ip) >> 2;

cpu_to_le16() ?


---
Can you please snip-out irrelevant code parts. It is real pain for
eyes to sneek out your comments otherwise :)


Thanks for your comments.


Cheers,
Nitin
