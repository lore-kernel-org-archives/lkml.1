Return-Path: <linux-kernel-owner+w=401wt.eu-S1750963AbZHRVWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963AbZHRVWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbZHRVWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:22:35 -0400
Received: from aun.it.uu.se ([130.238.12.36]:56014 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZHRVWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:22:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19083.7062.710265.941247@pilspetsen.it.uu.se>
Date: Tue, 18 Aug 2009 23:22:30 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: completely hide parts of the partition table from Windows?
Cc: Andries Brouwer <aeb@cwi.nl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BIOS on my laptop clips disk capacities to 128GB. There's no BIOS
update or BIOS setup option to fix this. Passing libata.ignore_hpa=1
allows the Linux kernel to access larger disks, so Linux does work Ok
with larger disks.

However, the laptop dual-boots Windows (for work-related stuff), and
Windows has a major problem: if any entry in the msdos partition table
refers to a sector above the BIOS 128GB limit, the Windows kernel
crashes and reboots early in its boot sequence. The type of the
partition doesn't matter, the fact that it describes an area above
the stupid BIOS limit is enough to trigger the crash.

So what I'm looking for is some sub-partition table format with the
following two properties:
1. resides in an msdos partition entry of a type that Windows does
   not inspect (for whatever extended partitions or Apple/BSD/Sun
   stuff that Windows may have been taught to recognize)
2. the locations and sizes of the sub-partitions are NOT limited by
   the parent msdos partition entry

I've looked at the code in fs/partitions/msdos.c, and it seems that
most of the extended/BSD/Sun formats don't give me property #2 above.

The minix and Unixware format parsers look like they ignore the parent
msdos partion entry boundaries, but I'm not sure if that's by design
or just sloppy coding.

Any recommendations? If no existing partition table format is suitable
for my use case then I'm perfectly willing to invent a simple new format
and add the corresponding parser to the kernel.

/Mikael
