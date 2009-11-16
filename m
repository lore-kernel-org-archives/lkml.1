Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbZKPQho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbZKPQho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 11:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZKPQhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 11:37:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49866 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZKPQhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 11:37:43 -0500
Date: Mon, 16 Nov 2009 16:36:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: [PATCH 2/3] msm: add minimal board file for HTC Dream device
Message-ID: <20091116163659.GB3568@n2100.arm.linux.org.uk>
References: <20091102104949.GA23456@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102104949.GA23456@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 11:49:49AM +0100, Pavel Machek wrote:
> +MACHINE_START(TROUT, "HTC Dream")
> +#ifdef CONFIG_MSM_DEBUG_UART
> +	.phys_io	= MSM_DEBUG_UART_PHYS,
> +	.io_pg_offst	= ((MSM_DEBUG_UART_BASE) >> 18) & 0xfffc,
> +#endif

Why is this ifdef'd?  Two reasons why not to do this:

1. MSM_DEBUG_UART is always defined, so the conditional is pointless

2. the low level page table building code does not expect these to be
   unset (or even set to an invalid value).  Leaving them unset and
   having DEBUG_LL enabled is a recipe to prevent booting.

To put it another way, these two fields aren't optional.
