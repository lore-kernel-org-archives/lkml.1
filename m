Return-Path: <linux-kernel-owner+w=401wt.eu-S1759730AbZFPQVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730AbZFPQVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbZFPQVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:21:16 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:58210 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbZFPQVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:21:16 -0400
Date: Tue, 16 Jun 2009 11:21:14 -0500
From: Scott Wood <scottwood@freescale.com>
To: Chris Pringle <chris.pringle@oxtel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
Message-ID: <20090616162114.GA5051@loki.buserror.net>
References: <4A37A503.3030209@oxtel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A37A503.3030209@oxtel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 02:58:27PM +0100, Chris Pringle wrote:
> We're developing on a Freescale MPC8272 and are having some nasty  
> problems with PCI bus mastering and data corruption.

What kernel version?  What firmware?  Custom board, or one in upstream
(which one)?

> We have some custom hardware that is bus mastering, reading data from  
> the CPUs memory for it's own use. Most of the time, the data is correct,  
> however occasionally we are seeing data that appears to be from  
> somewhere else in memory (usually memory that has already been read by  
> the PCI device). The problem looks like stale data on the PCI bridge  
> prefetch buffers or a cache coherency problem, but we've been unable to  
> come up with a solution to our problem. It is my understanding that it  
> shouldn't be a cache coherency problem as the CPU cache should be  
> snooped as the data is read from memory. Even if it were an issue, the  
> pci_map_sg* functions should have sorted out any cache coherency issues  
> before the DMA operation started.

Cache coherency on PCI DMA requires that the memory be mapped with the M
attribute on this chip, but that should be happening based on detection of
the core.

Also make sure that you park the bus on PCI and raise its arbitration
priority, as done at the end of fixup_pci in arch/powerpc/boot/cuboot-pq2.c.

BTW, you may want to post to linuxppc-dev@lists.ozlabs.org for
powerpc-specific issues, especially this kind of hardware issue.

-Scott
