Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbYCTNp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbYCTNp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 09:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYCTNpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 09:45:12 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:54872 "EHLO
	outbound5-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636AbYCTNpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 09:45:10 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JY17FW-02-WUU-01
Message-ID: <47E26A5D.40401@amd.com>
Date: Thu, 20 Mar 2008 14:45:01 +0100
From: Peter Oruba <peter.oruba@amd.com>
Organization: AMD (OSRC)
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Laurent GUERBY <laurent@guerby.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG: soft lockup detected on Phenom with Debian 2.6.24-4
References: <1205013615.15075.409.camel@localhost>	 <1205678588.15075.563.camel@localhost> <1206015619.15075.666.camel@localhost>
In-Reply-To: <1206015619.15075.666.camel@localhost>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2008 13:43:06.0050 (UTC) FILETIME=[537A3220:01C88A90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent,

you may have triggered the L2 eviction bug (E298).

Please try

hexdump -s 0xc0010015 -n 8 -C /dev/cpu/0/msr

Output is little-endian, so the left-most byte must have bit 3 enabled meaning 
TLB caching is disabled.

-Peter

Laurent GUERBY schrieb:
> On Sun, 2008-03-16 at 15:43 +0100, Laurent GUERBY wrote:
>> On Sat, 2008-03-08 at 23:00 +0100, Laurent GUERBY wrote:
>>> Hi,
>>>
>>> I have a system with an "AMD64 Phenom 9500" quad core cpu, 4GB RAM,
>>> "ASUS M3A32 MVP Deluxe wifi" motherboard with latest vendor BIOS
>>> (0801).
>>>
>>> I tried stock debian etch kernel (Debian 2.6.18.dfsg.1-18etch1),
>>> machine
>>> froze with no message, debian etch backport kernel same, and then
>>> Debian 2.6.24-4 from unstable and I got some messages: machine
>>> is not frozen but some userland processes are (ps says "Dl" state
>>> with child in "Zs" state) and "events/3" is taking 100% cpu
>>> according to top:
>>>
>>>    18 root      15  -5     0    0    0 R  100  0.0  74:59.46
>>> events/3  
>>>
>>> Got to the same state with ubuntu hardy 2.6.24-8-server kernel. All
>>> kernels are untainted, no X running anyway.
>>>
>>> It takes a few hours of doing some stuff, in my case bootstraping or
>>> testing GCC at -j 4, and then the problem happens.
>> On 2.6.24-1-amd64 (Debian 2.6.24-4) I got a slightly different
>> backtrace in /var/log/messages after a few hours of stressing the
>> machine with compilations, see below. The given process
>> was stuck and unkillable.
>>
>> Any idea on what to do/try?
> 
> I changed motherboard and went for a (way cheaper but older) ASUS M2A-VM
> with is based on the AMD 690G chipset with the exact same
> kernel/phenom/memory/disk/box and installed the latest vendor BIOS
> (1604). It took longer (25 hours) to get a stuck and unkillable process
> but it did happen, but I got nothing in /var/log/kern.log this time.
> 
> In order to rule out a motherboard or memory issue I bought an Athlon X2
> 4400+ EE and put in replacement of the phenom with the exact same
> kenel/memory/disk/box and my stress test has been running for 72 hours
> without any issue so far.
> 
> So in the end it seems to be a problem specific to phenom 9500 with the
> linux kernel.
> 
> Did anyone succeed in getting a stable linux box based on a phenom 9500
> processor ? "Stable" defined as being able to survive a few days
> compiling at -j4 (this is for the GCC compile farm after all :).
> 
> If so I'm interested by the exact motherboard/bios version/kernel
> version/distro used.
> 
> As proposed in my first email, ssh root access is possible to my machine
> (with either motherboard).
> 
> Thanks in advance,
> 
> Laurent
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
            |           AMD Saxony Limited Liability Company & Co. KG
  Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
  System    |                  Register Court Dresden: HRA 4896
  Research  |              General Partner authorized to represent:
  Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
            | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

