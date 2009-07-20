Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbZGTByT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbZGTByT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 21:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZGTByS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 21:54:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:39163 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbZGTByS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 21:54:18 -0400
Subject: Re: proper way to reserve a chunk of memory at the top of the
 kernel?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linuxppc-dev@ozlabs.org, Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4A5CF62F.6020102@nortel.com>
References: <4A5CF62F.6020102@nortel.com>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 11:54:05 +1000
Message-Id: <1248054845.13067.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 15:18 -0600, Chris Friesen wrote:
> I have a powerpc board with 512BM of memory.  The BIOS has a chunk of
> memory at the top end of physical memory which it does not zero out over
> a reboot.
> 
> What's the proper way to tell linux that this chunk of physical memory
> should be ignored (so that we can access it later without worrying that
> Linux will try to allocate it)?  Should I be calling
> 
> lmb_reserve(lmb_end_of_DRAM() - size, size);
> 
> in early_reserve_mem() or is there a better mechanism?

The device-tree blob contains a special "reserve map" in the header,
which automatically turns into calls to lmb_reserve() early during boot,
so putting your special region in that map should be the right way to do
what you want without special code.

> For comparison, in an older kernel this was done in set_phys_avail(), by
> calling mem_pieces_remove(&phys_avail, total_lowmem - size, size, 1);

Cheers,
Ben.

> Thanks,
> 
> Chris
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

