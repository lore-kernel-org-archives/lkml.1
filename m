Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbZKKTdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbZKKTdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758594AbZKKTdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:33:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39602 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758532AbZKKTdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:33:14 -0500
Date: Wed, 11 Nov 2009 19:32:57 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: linux-arm-kernel@lists.infradead.org,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] 2eca40a8 breaks StrongARM compilation
Message-ID: <20091111193257.GA14775@n2100.arm.linux.org.uk>
References: <20091111192315.GA29757@rainbow>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111192315.GA29757@rainbow>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 10:23:15PM +0300, Dmitry Artamonow wrote:
> Commit 2eca40a8 which went into 2.6.32-rc6 breaks compilation
> for ipaq h3600 and probably other SA1100 machines when CONFIG_CPU_FREQ
> is unset:

I'm aware, I have a very large patch which fixes SA1100, but there's
other ARM machine classes which are similarly broken.

We've been around this loop before, where a change like this was
introduced and reverted.  The kernel community seems set to constantly
repeat the same old mistakes time and time again.

> +#ifdef CONFIG_CPU_FREQ
>  	pcd = get_pcd(var->pixclock, cpufreq_get(0));
> +#else
> +	pcd = get_pcd(var->pixclock, 206400);
> +#endif

This is just not acceptable, and could lead to LCD panel damage due
to wrong timings - not all platforms boot at 206.4MHz.  Given that
it's far better that the kernel be obviously broken than silently
wrong while causing hardware damage.

