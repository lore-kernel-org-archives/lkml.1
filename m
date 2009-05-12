Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbZELAJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbZELAJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZELAJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:09:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841AbZELAJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:09:23 -0400
Date: Mon, 11 May 2009 17:01:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, rth@twiddle.net,
       ralf@linux-mips.org, tiwai@suse.de, dmitry.torokhov@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] move PIT_TICK_RATE to linux/timex.h
Message-Id: <20090511170146.143a1551.akpm@linux-foundation.org>
In-Reply-To: <200905112255.37215.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de>
	<200905112255.37215.arnd@arndb.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 22:55:36 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> PIT_TICK_RATE is currently defined in four architectures,
> but in three different places. While linux/timex.h is not
> the perfect place for it, it is still a reasonable replacement
> for those drivers that traditionally use asm/timex.h to
> get CLOCK_TICK_RATE and expect it to be the PIT frequency.
>
> ...
>
> -#define PIT_TICK_RATE 	1193180UL
> -#define PIT_TICK_RATE		1193182UL
> -#define PIT_TICK_RATE	1193182UL
> -#define PIT_TICK_RATE		1193182
> +#define PIT_TICK_RATE 1193182ul

So the type got changed in arch/x86/include/asm/timex.h.  Did you check
whether that changes anything? I did a quick check and didn't see any
obvious problems..

