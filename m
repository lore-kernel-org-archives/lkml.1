Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbXITXwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbXITXwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 19:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXITXwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 19:52:25 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:49168 "EHLO
	outbound6-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbXITXwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 19:52:24 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Thu, 20 Sep 2007 17:47:10 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: pommnitz@yahoo.com
cc: cebbert@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Problems with 2.6.23-rc6 on AMD Geode LX800
Message-ID: <20070920234710.GA6504@cosmic.amd.com>
MIME-Version: 1.0
In-Reply-To: <46F2A72E.5010709@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Sep 2007 23:46:52.0053 (UTC)
 FILETIME=[84AD1450:01C7FBE0]
X-WSS-ID: 6AEDD9F457W456470-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:

> On 09/20/2007 08:32 AM, Joerg Pommnitz wrote:
>> Hello all,
>> yesterday I tried to boot a kernel built from the current wireless-dev git
>> tree (ath5k branch)
>> on a MSEP800/A board (see http://www.milesie.co.uk/pdf/MSEP800.pdf). The
>> board
>> contains an AMD Geode LX800 CPU.
>> The wireless-dev tree is up to date with Linus kernel 2.6.23-rc6.
>> 
>> Attached is a photographic screen shot. The EIP value of c0378dd6 seems to
>> correspond with the
>> reserve_bootmem_core from System.map:
>> 
>> c0378d51 t free_bootmem_core
>> c0378da7 T free_bootmem
>> c0378db2 T free_bootmem_node
>> c0378dba t reserve_bootmem_core
>> c0378e14 T reserve_bootmem
>> c0378e1f T reserve_bootmem_node
>>

> Can you post disassembled code for that function?

Its hitting a bug - specifically (from bootmem.c:125):
BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);

I hit this problem on a db800 last week.  It went away with a newer
version of the BIOS, which doesn't help Joerg any, since its a different
board (though I think it is the same BIOS vendor).  Other BIOSes work
just fine with the same kernel image (including known troublemakers like
LinuxBIOS).  I believe that 2.6.22 was good, so some change must
have come along in 2.6.23-pre to cause the pain.  Or, it may have exposed
old breakage in the BIOS that was later repaired.

I'll do the math to figure out whats happening - and I'll check the release
notes to see what changed in the BIOS between the failing and working
version.  If anybody familiar with arch/i386 can think of something
new in the kernel that may have precipitated this, do let me know. :)

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


