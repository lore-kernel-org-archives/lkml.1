Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbXFBIva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbXFBIva (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 04:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXFBIvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 04:51:22 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:43403 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbXFBIvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 04:51:22 -0400
Message-ID: <46612F80.2070906@cosmosbay.com>
Date: Sat, 02 Jun 2007 10:51:12 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Mike Richards <mrmikerich@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Missing RAM on x86_64
References: <516d7fa80706012151m32facb87nafb68811c784fa54@mail.gmail.com>
In-Reply-To: <516d7fa80706012151m32facb87nafb68811c784fa54@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 02 Jun 2007 10:51:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Richards a écrit :
> Hi, I appear to be missing quite a bit of RAM on an x86_64 system. I
> have 1GB installed, but 'free' only shows 878MB:
> 
> pokey$ free -m
>             total       used       free     shared    buffers     cached
> Mem:           878        571        306          0         52        332
> -/+ buffers/cache:        186        691
> Swap:         1023          0       1023
> 
> I'm used to seeing a little bit of RAM missing with 32bit systems, but
> 146MB seems a bit much. The part of dmesg that concerns the RAM is
> shown below. Anyone know what's up here? Is this normal for an x86_64
> system?
> 
> Linux version 2.6.20.11 (root@pokey) (gcc version 4.1.2) #1 SMP Thu
> May 24 18:29:52 GMT 2007
> Command line: auto BOOT_IMAGE=2.6.20.11 rw root=801
> BIOS-provided physical RAM map:
> BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> BIOS-e820: 0000000000100000 - 0000000037fd0000 (usable)
> BIOS-e820: 0000000037fd0000 - 0000000037fde000 (ACPI data)
> BIOS-e820: 0000000037fde000 - 0000000038000000 (ACPI NVS)
> BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
> BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)


I would say your BIOS needs an update or some tweakings.

The (usable) parts that it gives to the OS (linux) are :

0000000000000000 - 000000000009fc00
0000000000100000 - 0000000037fd0000

Thats not 1024 MB, but 892 MB

Here is the output on a 16 GB x86_64 machine

BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
  BIOS-e820: 000000007fff0000 - 000000007ffff000 (ACPI data)
  BIOS-e820: 000000007ffff000 - 0000000080000000 (ACPI NVS)
  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 0000000480000000 (usable)

On node 0 totalpages: 2097039
On node 1 totalpages: 2097152

total of 4194078 pages (while exact 16GB should be 4194304 pages)


