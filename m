Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbXEOAQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbXEOAQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 20:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbXEOAQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 20:16:08 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756691AbXEOAQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 20:16:06 -0400
Date: Mon, 14 May 2007 17:15:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: mroos@linux.ee, David Miller <davem@davemloft.net>,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: slab hang on boot
Message-Id: <20070514171518.fdca9f8c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705141642350.13606@schroedinger.engr.sgi.com>
References: <Pine.SOC.4.64.0705142133190.17204@math>
	<20070514.151148.45744375.davem@davemloft.net>
	<Pine.LNX.4.64.0705141642350.13606@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 16:46:17 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> -#define KMALLOC_SHIFT_HIGH 25
> +#define KMALLOC_SHIFT_HIGH ((MAX_ORDER + PAGE_SHIFT) =< 25 ? \
> +				MAX_ORDER + PAGE_SHIFT - 1 : 25)

Would prefer to see a lot more parentheses in there.  Who knows what the arch
is using for MAX_ORDER and PAGE_SHIFT.

>  #if !defined(CONFIG_MMU) || NR_CPUS > 512 || MAX_NUMNODES > 256
>  #define KMALLOC_SHIFT_HIGH 20
> @@ -86,6 +87,9 @@ static inline int kmalloc_index(int size
>  	 */
>  	WARN_ON_ONCE(size == 0);
>  
> +	if (size >= (1UL << KMALLOC_SHIFT_HIGH))
> +		return -1;
> +

`size' is `int'.  Deliberately comparing it to an unsigned long seems
unpointful.

Arguably, `size' should be size_t.
