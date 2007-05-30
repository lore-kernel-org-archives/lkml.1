Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbXE3X3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbXE3X3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbXE3X3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:29:21 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:3929 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbXE3X3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:29:21 -0400
Date: Wed, 30 May 2007 17:29:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Case: 7454422: Re: Kernel 2.6.21.3 does not work with 8GB of RAM
 on Intel 965WH motherboards. (FULL DMESG)
In-reply-to: <fa.yz+v/A2zkJKIswF0Y4Mo4FxwnCI@ifi.uio.no>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, crmotherboard@mailbox.cps.intel.com
Message-id: <465E08CD.2080302@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
References: <fa.t8TZNHj4vrYcIs37jScT0oZl02s@ifi.uio.no>
 <fa.nsJ3dX+uNBCD7bTYffkYm0DLnR4@ifi.uio.no>
 <fa.lfTXDj3RBbaCLDUJJFzLVowMlxc@ifi.uio.no>
 <fa.lrZMTvBB9xwYW1mcA0nyYFjB9qY@ifi.uio.no>
 <fa.AIUKY82rbgpQ/AiIxhRL0fahxaQ@ifi.uio.no>
 <fa.yz+v/A2zkJKIswF0Y4Mo4FxwnCI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> That output looked nasty, attaching entries from syslog.
> 
> Justin.

Here's your E820 memory map, from dmesg:

BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
BIOS-e820: 0000000000100000 - 00000000cf58f000 (usable)
BIOS-e820: 00000000cf58f000 - 00000000cf59c000 (reserved)
BIOS-e820: 00000000cf59c000 - 00000000cf653000 (usable)
BIOS-e820: 00000000cf653000 - 00000000cf6a5000 (ACPI NVS)
BIOS-e820: 00000000cf6a5000 - 00000000cf6a8000 (ACPI data)
BIOS-e820: 00000000cf6a8000 - 00000000cf6ef000 (ACPI NVS)
BIOS-e820: 00000000cf6ef000 - 00000000cf6f1000 (ACPI data)
BIOS-e820: 00000000cf6f1000 - 00000000cf6f2000 (usable)
BIOS-e820: 00000000cf6f2000 - 00000000cf6ff000 (ACPI data)
BIOS-e820: 00000000cf6ff000 - 00000000cf700000 (usable)
BIOS-e820: 00000000cf700000 - 00000000d0000000 (reserved)
BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
BIOS-e820: 0000000100000000 - 000000022c000000 (usable)

so the usable memory ranges are:

0-572K
1MB-3317.55MB
3317.60MB-3317.75MB
3318.94MB-3318.945MB
3318.996MB-3319MB
4096MB-8896MB

and the MTRRs (from /proc/mtrr, from private email):

reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
reg04: base=0xcf700000 (3319MB), size=   1MB: uncachable, count=1
reg05: base=0x100000000 (4096MB), size=4096MB: write-back, count=1
reg06: base=0x200000000 (8192MB), size= 512MB: write-back, count=1
reg07: base=0x220000000 (8704MB), size= 128MB: write-back, count=1

so the ranges mapped as cacheable are:

0-3319MB
4096-8832MB

leaving 64MB of memory at the top of RAM uncached. What do you want to
bet that something important (kernel code?) is getting loaded there..

So essentially it's a BIOS problem, it's not setting up the MTRRs
properly in order to map all of RAM as cacheable. As Andi says, complain
to Intel.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

