Return-Path: <linux-kernel-owner+w=401wt.eu-S1765363AbZLQVS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765363AbZLQVS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765342AbZLQVSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:18:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38420 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbZLQVSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:18:25 -0500
Date: Thu, 17 Dec 2009 21:17:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Wrong size used in dump_mem()
Message-ID: <20091217211759.GB16520@n2100.arm.linux.org.uk>
References: <4B2A9F8E.5080508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2A9F8E.5080508@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 10:15:58PM +0100, Roel Kluin wrote:
> The sizeof the pointed to should be used rather than of the pointer
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Unless I am mistaken?

You are mistaken.  sizeof(array) is the byte size of the array.
sizeof(*array) is the size of one individual object of the array.

The code is correct as is - which is to fill  the entire array with
space characters and then zero the last one.

> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index 3f361a7..5e828fa 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -102,7 +102,7 @@ static void dump_mem(const char *lvl, const char *str, unsigned long bottom,
>  		unsigned long p;
>  		char str[sizeof(" 12345678") * 8 + 1];
>  
> -		memset(str, ' ', sizeof(str));
> +		memset(str, ' ', sizeof(*str));
>  		str[sizeof(str) - 1] = '\0';
>  
>  		for (p = first, i = 0; i < 8 && p < top; i++, p += 4) {
