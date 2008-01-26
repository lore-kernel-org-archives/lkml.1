Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYAZARX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYAZARX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbYAZARD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:17:03 -0500
Received: from smtp.digitalpath.net ([65.164.104.14]:48971 "EHLO
	smtp.digitalpath.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbYAZARB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:17:01 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=digitalpath.net;
  b=n5R4lYoNLEW+rm7hWz8z6YdA8MAY7iijL1ycBlsAlLhoue/I0mEe/t8GHSHZpDmHbv9nKDf8/UHv/kHFEHHO6by/c+AX0MxPI56bVHYxBdBlgvj4OfLbNCkPPe7wjjHD  ;
Message-ID: <1920.65.164.104.9.1201306620.squirrel@webmail.digitalpath.net>
Date: Fri, 25 Jan 2008 16:17:00 -0800 (PST)
Subject: Re: CS5536 mfgpt timer setup register hangs board
From: "Hasan Rashid" <hasan@digitalpath.net>
To: linux-kernel@vger.kernel.org
Cc: "Hasan Rashid" <hasan@digitalpath.net>
Reply-To: hasan@digitalpath.net
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what TinyBios posts
-------------------------------------------
PC Engines ALIX.2 v0.99
640 KB Base Memory
130048 KB Extended Memory

01F0 Master 848A CF 128MB
Phys C/H/S 1002/8/32 Log C/H/S 1002/8/32

BIOS setup:

(9) 9600 baud (2) 19200 baud *3* 38400 baud (5) 57600 baud (1) 115200 baud
*C* CHS mode (L) LBA mode (W) HDD wait (V) HDD slave (U) UDMA enable
(M) MFGPT workaround
(P) late PCI init
*R* Serial console enable
(E) PXE boot enable
(X) Xmodem upload
(Q) Quit

The MFGPT workaround is disabled, and I deleted the workaround code that
came with voyage linux's distribution. Anyhow I will try the fix and see
if that solves my problem.

> On 25/01/08 15:50 -0800, Hasan Rashid wrote:
>>
>> Hi,
>>
>> I have been working on a watchdog timer using the mfgpt on AMD Geode
>> CS5536. I initialize the setup register MFGPT0_SETUP (0x6206) with hex
>> value 0x306 (1100000110b). However, after this first initialization if I
>> ever read/write to the register it hangs the system.
>>
>> I have been through all the documentation, tried several different
>> methods
>> but all the efforts, frustratingly, to no avail.
>>
>> Does anyone have any idea as to why would this be? TIA!
>
> It looks like you are using TinyBIOS.  Make sure that if you are using
> v0.99
> that you do *not* enable the MFGPT workaround.  If you are using an older
> version, then you will need this patch:
>
> http://lkml.org/lkml/2008/1/23/372
>
> And enable mfgptfix on the command line.  There seems to be a problem with
> the MFGPT "workaround" that causes hangs exactly like you are seeing.
>
> Jordan
>
> --
> Jordan Crouse
> Systems Software Development Engineer
> Advanced Micro Devices, Inc.
>
>
>


-- 
Regards,
Hasan Rashid


