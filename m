Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbXFASPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbXFASPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763006AbXFASO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:14:56 -0400
Received: from lucidpixels.com ([75.144.35.66]:56921 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762985AbXFASOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:14:54 -0400
Date: Fri, 1 Jun 2007 14:14:54 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
Subject: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the
 kernel realize the BIOS has problems and re-map appropriately?
Message-ID: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; format=flowed
Content-ID: <Pine.LNX.4.64.0706011410132.3716@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Dear Customer,

Thank you for contacting Intel(R) Technical Support.

After reviewing the email history on this case, we have the following suggestions/comments:

Note before continuing: Debian* Linux Operating System is not an officially, validated, tested Operating System for the Intel(R) Desktop Board DG965WH (see http://downloadcenter.intel.com/Product_Filter.aspx?ProductID=2375); moreover, we do confirm that "on a system that has 8 GB of system memory installed, it is not possible to use all of the installed memory due to system address space being allocated for other system critical functions." [qtd. on page 43 of the Technical Product Specification (see http://download.intel.com/design/motherbd/wh/D5600801US.pdf)].  Thus, the following suggestions are provided AS IS; we cannot guarantee the problem would be fixed afterwards:

1. Try updating the BIOS to the most current version (1687):

http://downloadcenter.intel.com/filter_results.aspx?strTypes=all&ProductID=2375&OSFullName=OS+Independent&lang=eng&strOSs=38&submit=Go%21

Note: Once the update is done, please, restart the system and repeat the following:

Press <F9> to restore BIOS default settings.  Reset any customized BIOS settings. Clear all DMI event logs, which are located in the Advanced/Event Log Configuration section of the BIOS Setup utility.  Press <F10> to save the new settings and reboot the system.


2. If the problem continues, please, ensure the brand and part# of the memory modules are listed among the tested memory lists (see http://developer.intel.com/design/motherbd/wh/wh_mem.htm#1).


------------

Before I upgraded to 8GB, I used to upgrade my BIOS everytime a new 
version came out, however, once I upgraded past 1666P I also noticed this 
problem even with 4GB of memory, I tried to downgrade back to 1666P and it 
corrupted the BIOS/failed and I had to wait 1-2 weeks for the RMA process, 
1 week to get there, 1-3 days for analysis etc, they do ship two-day 
shipping back to you however..

Per Robert's response, this is the fix I will be using as Intel wants me 
to upgrade the BIOS to the defaults, which could potentially cause another 
motherboard failure. I'll stick with the mem= option.  I need to read up 
on the E820 memory map.

How come the kernel does not automatically map the memory correctly and 
then put a message in syslog/dmesg: Only using 7.7GB because your BIOS is 
using 64MB for other purposes, re-mapping kernel into higher memory..

Any comments?


Per Robert below:

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

