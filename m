Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985Ab0ASSIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab0ASSIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 13:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214Ab0ASSIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 13:08:20 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:59843 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0ASSIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 13:08:19 -0500
Message-ID: <4B55F3EF.9020408@nortel.com>
Date: Tue, 19 Jan 2010 12:03:27 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: issues with kmemleak backport
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2010 18:08:14.0806 (UTC) FILETIME=[5E9A3760:01CA9932]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've backported about 60 kmemleak patches to a modified 2.6.27 in an
attempt to track down a memory leak of about 4MB/hr that we're seeing on
an x86 blade.

For the most part the backport was straightforward, but now booting up
the kernel I see this:

Cannot insert 0xc312b880 into the object search tree (already existing)
Pid: 0, comm: swapper Not tainted 2.6.27-pne #23
 [<c048babd>] create_object+0x21d/0x250
 [<c014172b>] kmemleak_init+0x12a/0x1cf
 [<c012980d>] start_kernel+0x225/0x338
 [<c01293aa>] ? unknown_bootoption+0x0/0x1ed
 [<c0129093>] _sinittext+0x93/0x99
 =======================
Kernel memory leak detector disabled
Object 0xc312b880 (size 340):
  comm "swapper", pid 0, jiffies 4294667296
  min_count = 0
  count = 0
  flags = 0x1
  checksum = 0
  backtrace:
     [<c01415f9>] log_early+0x90/0x98
     [<c08132df>] kmemleak_alloc+0x5f/0x70
     [<c013f1c9>] alloc_bootmem_core+0x2c3/0x2c8
     [<c013f233>] ___alloc_bootmem_nopanic+0x65/0x91
     [<c013f2c8>] ___alloc_bootmem+0x16/0x3c
     [<c013f39e>] __alloc_bootmem+0x12/0x14
     [<c0147c43>] con_init+0x8a/0x22d
     [<c01474c4>] console_init+0x19/0x27
     [<c01297b6>] start_kernel+0x1ce/0x338
     [<c0129093>] _sinittext+0x93/0x99
     [<ffffffff>] 0xffffffff


Have you got any suggestions as to how I should deal with this?

Thanks,
Chris
