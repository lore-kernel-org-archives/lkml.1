Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab0BMStq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 13:49:46 -0500
Received: from mail.perches.com ([173.55.12.10]:1026 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757676Ab0BMStn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 13:49:43 -0500
Subject: Re: [PATCH 25/35] move round_up/down to kernel.h
From: Joe Perches <joe@perches.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <1265793639-15071-26-git-send-email-yinghai@kernel.org>
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
	 <1265793639-15071-26-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Feb 2010 10:49:40 -0800
Message-ID: <1266086980.16721.837.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 01:20 -0800, Yinghai Lu wrote:
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 1221d23..7f07074 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -44,6 +44,16 @@ extern const char linux_proc_banner[];
[]
> +#define __round_mask(x, y) ((__typeof__(x))((y)-1))
> +#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
> +#define round_down(x, y) ((x) & ~__round_mask(x, y))
> +
>  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))

Having both roundup and round_up in kernel.h is a 
near guarantee for a future incorrect use.

Can't you use a different name for this?

