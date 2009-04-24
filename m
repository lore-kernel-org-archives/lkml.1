Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZDXBq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZDXBq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 21:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZDXBqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 21:46:21 -0400
Received: from [65.98.92.6] ([65.98.92.6]:2132 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbZDXBqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 21:46:20 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Apr 2009 21:46:20 EDT
Message-Id: <0483452db22e72f57289e63fcf097120d94c2a37.1240533480.git@localhost>
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Thu, 23 Apr 2009 17:03:43 -0700
Subject: [PATCH 0/3] MIPS: Extend plat_* abstractions, cache support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am upgrading an SoC to the 2.6.29.1 kernel from an earlier version,
and in the process I am switching over the old board support
customizations to use the newer, cleaner plat_* functions.  I found two
cases where the plat_* functions did not provide enough information,
so I had to modify the API:

plat_unmap_dma_mem() - Our handler needs to know the size and direction
of the DMA mapping.  This information is not encoded in the DMA address,
so it needed to be passed in explicitly.

plat_dma_addr_to_phys() - The bus<->physical address mappings differ
based on which bus is being used.  It is not always possible to infer
which bus is being used from the bus address alone, so I added a
"struct device" to the function definition.

Also, our MIPS core uses 64-byte D$ lines, so I needed to generate the
corresponding blast* functions.

These patches apply against the linux-mips.org GIT tree.
