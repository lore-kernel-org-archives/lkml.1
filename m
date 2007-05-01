Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXEAG4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXEAG4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 02:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932903AbXEAG4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 02:56:46 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932819AbXEAG4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 02:56:45 -0400
Date: Mon, 30 Apr 2007 23:56:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 2/4] SoC base drivers: ASIC3 SoC hardware
 definitions
Message-Id: <20070430235642.e576e917.akpm@linux-foundation.org>
In-Reply-To: <516386418.20070501080839@gmail.com>
References: <516386418.20070501080839@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 08:08:39 +0300 Paul Sokolovsky <pmiscml@gmail.com> wrote:

> Hello linux-kernel,
> 
> Intro: This is a header with hardware definitions for ASIC3 chip,
> contributed by HP/Compaq. It is provided as-is, as a vendor-originated
> header.
> ---------
> 
> ipaq-asic3.h: Hardware definitions for ASIC3 chip, found in ~12
> handheld devices from HP/Compaq and HTC.
> 
> Signed-off-by: Paul Sokolovsky <pmiscml@gmail.com>
> 
> 
>  include/asm-arm/hardware/ipaq-asic3.h |  609 +++++++++++++++++++++++++++++++++
>  1 files changed, 609 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-arm/hardware/ipaq-asic3.h b/include/asm-arm/hardware/ipaq-asic3.h
> new file mode 100644
> index 0000000..789bb16
> --- /dev/null
> +++ b/include/asm-arm/hardware/ipaq-asic3.h
> @@ -0,0 +1,609 @@
> +/*
> + *
> + * Definitions for the HTC ASIC3 chip found in several handheld devices 
> + *
> + * Copyright 2001 Compaq Computer Corporation.
> + *
> + * Use consistent with the GNU GPL is permitted,
> + * provided that this copyright notice is
> + * preserved in its entirety in all copies and derived works.
> + *
> + * COMPAQ COMPUTER CORPORATION MAKES NO WARRANTIES, EXPRESSED OR IMPLIED,
> + * AS TO THE USEFULNESS OR CORRECTNESS OF THIS CODE OR ITS
> + * FITNESS FOR ANY PARTICULAR PURPOSE.
> + *
> + * Author: Andrew Christian
> + *
> + */
> +
> +#ifndef IPAQ_ASIC3_H
> +#define IPAQ_ASIC3_H
> +
> +/****************************************************/
> +/* IPAQ, ASIC #3, replaces ASIC #1 */
> +
> +#define IPAQ_ASIC3(_b,s,x,y)					\
> +     (*((volatile s *) (_b + _IPAQ_ASIC3_ ## x ## _Base + (_IPAQ_ASIC3_ ## x ## _ ## y))))
> +#define IPAQ_ASIC3_N(_b,s,x,y,z)					\
> +     (*((volatile s *) (_b + _IPAQ_ASIC3_ ## x ## _ ## y ## _Base + (_IPAQ_ASIC3_ ## x ## _ ## z))))
> +
> +#define IPAQ_ASIC3_GPIO(_b,s,x,y)				\
> +     (*((volatile s *) (_b + _IPAQ_ASIC3_GPIO_ ## x ## _Base + (_IPAQ_ASIC3_GPIO_ ## y))))
> +     
> +#define IPAQ_ASIC3_OFFSET(x,y) (_IPAQ_ASIC3_ ## x ## _Base + _IPAQ_ASIC3_ ## x ## _ ## y)
> +#define IPAQ_ASIC3_GPIO_OFFSET(x,y) (_IPAQ_ASIC3_GPIO_ ## x ## _Base + _IPAQ_ASIC3_GPIO_ ## y)

Oh my eyes.  What are these doing?

The volatiles are a worry - volatile is said to be basically-always-wrong
in-kernel, although we've never managed to document why, and i386
cheerfully uses it in readb() and friends.

Perhaps if you can describe presisely what's going on here, alternatives
might be suggested.


