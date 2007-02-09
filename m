Return-Path: <linux-kernel-owner+w=401wt.eu-S2992816AbXBIUqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992816AbXBIUqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 15:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992825AbXBIUqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 15:46:36 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:43562 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992816AbXBIUqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 15:46:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m3DWIya6uAbuyX1UEfdPjOU9R8WAuPoqQ2QN4uJ2N91MUm/+N5YThYSb2/QJjN+CELfoI8zXKkrZKrTcBGMlvYjPQg7o4rXrHCXfXX8qm1HHVBndqyxZm6uhwDHCFnAtW16qWwA52JCnE/gGxS/cG8gYeCXtN36DmPAYBnrrGuo=
Message-ID: <1defaf580702091246i1f49a787g482e25817517d7ed@mail.gmail.com>
Date: Fri, 9 Feb 2007 21:46:33 +0100
From: "Haavard Skinnemoen" <hskinnemoen@gmail.com>
To: "Pavel Pisa" <pisa@cmp.felk.cvut.cz>
Subject: Re: Coding style question
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, "Sascha Hauer" <s.hauer@pengutronix.de>,
       "Pierre Ossman" <drzeus@drzeus.cx>
In-Reply-To: <200702091132.09741.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702091132.09741.pisa@cmp.felk.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/07, Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:

> #define __val2mfld(mask,val) (((mask)&~((mask)<<1))*(val)&(mask))
>
> #define __mfld2val(mask,val) (((val)&(mask))/((mask)&~((mask)<<1)))

Looks a bit similar to the style I tend to use a lot:

/* Bit manipulation macros */
#define MACB_BIT(name)                                  \
        (1 << MACB_##name##_OFFSET)
#define MACB_BF(name,value)                             \
        (((value) & ((1 << MACB_##name##_SIZE) - 1))    \
         << MACB_##name##_OFFSET)
#define MACB_BFEXT(name,value)\
        (((value) >> MACB_##name##_OFFSET)              \
         & ((1 << MACB_##name##_SIZE) - 1))
#define MACB_BFINS(name,value,old)                      \
        (((old) & ~(((1 << MACB_##name##_SIZE) - 1)     \
                    << MACB_##name##_OFFSET))           \
         | MACB_BF(name,value))

where BF stands for bitfield, EXT for extract and INS for insert.

The macros are butt ugly, but code using them is hopefully quite easy
to read (I'm of course not qualified to judge code I wrote myself.)
The somewhat excessive pasting ensures that if you ever switch the
name and value arguments, the compiler will let you know.

Example usage:

macb_writel(bp, REG, MACB_BF(FIELD, value));
regval = macb_readl(bp, REG);
value = MACB_BFEXT(FIELD, regval);

Haavard
