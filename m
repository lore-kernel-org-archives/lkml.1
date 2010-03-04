Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0CDVgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:36:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40289 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab0CDVgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:36:46 -0500
Date: Thu, 4 Mar 2010 21:36:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Koeller <thomas@koeller.dyndns.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: DMA using data buffer vmapped in kernel space
Message-ID: <20100304213634.GH13417@n2100.arm.linux.org.uk>
References: <201003042211.28569.thomas@koeller.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003042211.28569.thomas@koeller.dyndns.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 10:11:08PM +0100, Thomas Koeller wrote:
> I do not understand the purpose of the failing check. The virt_addr_valid()
> macro checks whether its argument is below high_memory. But why would the
> virtual address of a DMA data buffer matter at all? After all, the pages
> are resident, so I cannot see any problem here. Can anybody explain?

Cache maintainence is done using virtual addresses for L1, and
physical addresses for L2.  There's the need for virtual addresses
to be translatable to physical addresses, which is only true for
the kernel direct mapped region (pages between PAGE_OFFSET and
high_memory).
