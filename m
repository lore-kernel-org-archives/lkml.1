Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbYFIVLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbYFIVLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbYFIVKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:10:47 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51444 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751393AbYFIVKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:10:46 -0400
Message-Id: <20080609211028.110089743@attica.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 09 Jun 2008 16:10:28 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: [patch 00/11] GRU Driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series of patches adds a driver for the SGI UV GRU. The driver is still
in development but it currently compiles for both x86_64 & IA64. All simple
regression tests pass on IA64. Although features remain to be added, I'd like to
start the process of getting the driver into the kernel. Additional kernel
drivers will depend on services provide by the GRU driver.

The GRU is a hardware resource located in the system chipset. The GRU
contains memory that is mmaped into the user address space. This memory is
used to communicate with the GRU to perform functions such as load/store,
scatter/gather, bcopy, AMOs, etc.  The GRU is directly accessed by user
instructions using user virtual addresses. GRU instructions (ex., bcopy) use
user virtual addresses for operands.

The GRU contains a large TLB that is functionally very similar to processor TLBs.
Because the external contains a TLB with user virtual address, it requires
callouts from the core VM system when certain types of changes are made to
the process page tables. There are several MMUOPS patches currently being
discussed but none has been accepted into the kernel. The GRU driver 
is built using version V18 from Andrea Arcangeli.

--- jack
