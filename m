Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbXF0KpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbXF0KpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 06:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbXF0KpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 06:45:13 -0400
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:3383 "EHLO
	mondriaan.macroscoop.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbXF0KpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 06:45:11 -0400
Message-ID: <46823F71.6060200@macroscoop.nl>
Date: Wed, 27 Jun 2007 12:44:01 +0200
From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jesse Barnes <jesse.barnes@intel.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Andi Kleen <andi@firstfloor.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706251434.43863.jesse.barnes@intel.com>
In-Reply-To: <200706251434.43863.jesse.barnes@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First:
Jesse saved my life by releasing a patch that made my GigaByte Intel G33
based motherboard use all of its 8GB RAM and not be slow as hell.

Then:
GigaByte released a BIOS update that fixed the root of the problem.
I went back from patched vanilla kernel to "official" Fedora kernel.

Now:
Jesse released a new patch and I tried if for fun on 2.6.22-rc6
It looks like the patch is releasing memory rather than trimming it:

Jun 27 12:22:56 corneille kernel: Linux version 2.6.22-rc6 
(pim@corneille) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #1 SMP 
Wed Jun 27 11:41:29 CEST 2007
Jun 27 12:22:56 corneille kernel: Command line: root=LABEL=/ 
console=ttyS0,38400
Jun 27 12:22:56 corneille kernel: BIOS-provided physical RAM map:
Jun 27 12:22:56 corneille kernel:  BIOS-e820: 0000000000000000 - 
000000000009e800 (usable)
Jun 27 12:22:56 corneille kernel:  BIOS-e820: 000000000009f800 - 
00000000000a0000 (reserved)
Jun 27 12:22:56 corneille kernel:  BIOS-e820: 00000000000f0000 - 
0000000000100000 (reserved)
Jun 27 12:22:56 corneille kernel:  BIOS-e820: 0000000000100000 - 
00000000cf5e0000 (usable)
Jun 27 12:22:56 corneille kernel:  BIOS-e820: 00000000cf5e0000 - 
00000000cf5e3000 (ACPI NVS)
Jun 27 12:22:56 corneille kernel:  BIOS-e820: 00000000cf5e3000 - 
00000000cf5f0000 (ACPI data)
Jun 27 12:22:56 corneille kernel:  BIOS-e820: 00000000cf5f0000 - 
00000000cf600000 (reserved)
Jun 27 12:22:56 corneille kernel:  BIOS-e820: 00000000d0000000 - 
00000000e0000000 (reserved)
Jun 27 12:22:56 corneille kernel:  BIOS-e820: 00000000fec00000 - 
0000000100000000 (reserved)
Jun 27 12:22:56 corneille kernel:  BIOS-e820: 0000000100000000 - 
0000000230000000 (usable)
Jun 27 12:22:56 corneille kernel: end_pfn_map = 2293760
Jun 27 12:22:56 corneille kernel: ***************
Jun 27 12:22:56 corneille kernel: **** WARNING: likely BIOS bug
Jun 27 12:22:56 corneille kernel: **** MTRRs don't cover all of memory, 
trimmed -65536 pages
Jun 27 12:22:56 corneille kernel: ***************

I tried the earlier patch as well and it gives the same result.
