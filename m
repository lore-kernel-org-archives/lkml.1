Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbYA3DAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbYA3DAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYA3C77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:59:59 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42758 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbYA3C76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:59:58 -0500
Date: Wed, 30 Jan 2008 11:59:43 +0900 (JST)
Message-Id: <20080130.115943.85421886.usui@mxm.nes.nec.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, magnus.damm@gmail.com
Subject: Re: [PATCH] Fix NUMA emulation for x86_64
From: Minoru Usui <usui@mxm.nes.nec.co.jp>
In-Reply-To: <20080125104107.GS23708@elte.hu>
References: <20080125.171613.41631926.usui@mxm.nes.nec.co.jp>
	<20080125104107.GS23708@elte.hu>
X-fingerprint: 588C 0511 30A4 1BE0 551B  7210 8433 0B28 D5CC 723D
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> ">" == Ingo Molnar <mingo@elte.hu> writes:

    >> * Minoru Usui <usui@mxm.nes.nec.co.jp> wrote:

    >> I found a small bug of NUMA emulation code for x86_64. 
    >> (CONFIG_NUMA_EMU) If machine is non-NUMA, find_node_by_addr() should 
    >> return NUMA_NO_NODE, but current implementation code returns existent 
    >> maximum NUMA node number + 1. This is not existent NUMA node number.
    >> 
    >> However, this behaviour does not affect NUMA emulation fortunately, 
    >> because acpi_fake_nodes() that is caller of find_node_by_addr() gets 
    >> pxm (proximity domain) by node_to_pxm() from non-existent NUMA node 
    >> number that was returned by find_node_by_addr(). node_to_pxm() returns 
    >> PXM_INVAL that means illegal or non-existent NUMA node number.

    >> thanks, i have applied your fix to x86.git.

    >> It seems this does not need to be backported to v2.6.24.1 because 
    >> node_to_pxm() masked the bad effects of this bug, right?

    >> 	Ingo

I think this bug is not urgency.
If you mean that it's not necessary to release 2.6.24.1 only for this
bug, I think so.
