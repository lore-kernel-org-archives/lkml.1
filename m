Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737Ab0AUPze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab0AUPze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565Ab0AUPzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:55:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323Ab0AUPzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:55:32 -0500
Date: Thu, 21 Jan 2010 07:54:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/36] x86/pci: enable pci root res read out for 32bit
 too
In-Reply-To: <1264055303-15123-6-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1001210750140.13231@localhost.localdomain>
References: <1264055303-15123-1-git-send-email-yinghai@kernel.org> <1264055303-15123-6-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jan 2010, Yinghai Lu wrote:
>
>  			printk(KERN_DEBUG "bus: %02x index %x %s: [%llx, %llx]\n",
>  			       busnum, j,
>  			       (res->flags & IORESOURCE_IO)?"io port":"mmio",
> -			       res->start, res->end);
> +			       (u64)res->start, (u64)res->end);

When fixing these kinds of things, please just make it use '%pR' instead.

A simple

	printk(KERN_DEBUG "bus: %02x index %x %pR\n", busnum, j, res);

should do the right thing, printing the resource with nice human-readable 
flags. Including things like 64-bit/prefetching information for memory 
resources etc that the current manual resource printout doesn't do.

		Linus
