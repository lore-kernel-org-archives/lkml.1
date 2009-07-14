Return-Path: <linux-kernel-owner+w=401wt.eu-S932121AbZGNVS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbZGNVS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 17:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932100AbZGNVSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 17:18:53 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:41312 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbZGNVSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 17:18:51 -0400
Message-ID: <4A5CF62F.6020102@nortel.com>
Date: Tue, 14 Jul 2009 15:18:39 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, Linux kernel <linux-kernel@vger.kernel.org>
Subject: proper way to reserve a chunk of memory at the top of the kernel?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 21:18:40.0731 (UTC) FILETIME=[A8E942B0:01CA04C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a powerpc board with 512BM of memory.  The BIOS has a chunk of
memory at the top end of physical memory which it does not zero out over
a reboot.

What's the proper way to tell linux that this chunk of physical memory
should be ignored (so that we can access it later without worrying that
Linux will try to allocate it)?  Should I be calling

lmb_reserve(lmb_end_of_DRAM() - size, size);

in early_reserve_mem() or is there a better mechanism?

For comparison, in an older kernel this was done in set_phys_avail(), by
calling mem_pieces_remove(&phys_avail, total_lowmem - size, size, 1);

Thanks,

Chris
