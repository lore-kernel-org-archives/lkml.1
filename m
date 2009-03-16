Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbZCPWyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbZCPWyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZCPWyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:54:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:36973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbZCPWyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:54:04 -0400
Message-ID: <49BED813.1090405@kernel.org>
Date: Mon, 16 Mar 2009 15:52:03 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.29_rc8] BIOS Bug: CPU MTRRs don't cover all of memory,
 	losing 0MB of RAM.
References: <49BE58BA.1000907@pardus.org.tr> <86802c440903161121s3ba18abaiaa3ccf6847e0eafe@mail.gmail.com> <49BEB3C9.8070705@pardus.org.tr> <49BECBF4.1000508@kernel.org> <49BED5D5.2000801@pardus.org.tr>
In-Reply-To: <49BED5D5.2000801@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ozan Çağlayan wrote:
> Yinghai Lu wrote:
> 
>> please check
>>
>> [PATCH] x86: workaround system with strange var MTRR
>>
> 
> Thanks for your interest.
> 
> Oops is now replaced with a warning after applying the patch on top of tip/master.
that is intended...
> 
> BTW, do that kind of BIOS bugs have a negative impact on the performance of the system?

should not, FIXED MTRR should override VAR MTRR if fixed mtrr is enabled.

> 
> 
> I'm sending the head of dmesg. And also I just noticed that there were MTRR related
> stuff at the tail of the log buffer(with/without the patch). I'm posting them also:
> 
> --
> 
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
>   00000-9FFFF write-back
>   A0000-BFFFF uncachable
>   C0000-FFFFF write-protect
> MTRR variable ranges enabled:
>   0 base 0000000000 mask 0000000000 write-back
>   1 base 00CFF00000 mask FFFFF00000 uncachable
>   2 base 00D0000000 mask FFF0000000 uncachable
>   3 base 00E0000000 mask FFE0000000 uncachable
>   4 base 0000004000 mask FFFFFFF000 uncachable
>   5 base 0000005000 mask FFFFFFF000 uncachable
>   6 base 0000006000 mask FFFFFFF000 uncachable
>   7 base 0000007000 mask FFFFFFF000 uncachable
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>   get_mtrr: cpu0 reg00 base=0000000000 size=0010000000 write-back
>   get_mtrr: cpu0 reg01 base=00000cff00 size=0000000100 uncachable
>   get_mtrr: cpu0 reg02 base=00000d0000 size=0000010000 uncachable
>   get_mtrr: cpu0 reg03 base=00000e0000 size=0000020000 uncachable
>   get_mtrr: cpu0 reg04 base=0000000004 size=0000000001 uncachable
>   get_mtrr: cpu0 reg05 base=0000000005 size=0000000001 uncachable
>   get_mtrr: cpu0 reg06 base=0000000006 size=0000000001 uncachable
>   get_mtrr: cpu0 reg07 base=0000000007 size=0000000001 uncachable
> WARNING: BIOS bug: VAR MTRR contains strange UC entry under 1M, check with your system vendor!
> WARNING: BIOS bug: VAR MTRR contains strange UC entry under 1M, check with your system vendor!
> WARNING: BIOS bug: VAR MTRR contains strange UC entry under 1M, check with your system vendor!
> WARNING: BIOS bug: VAR MTRR contains strange UC entry under 1M, check with your system vendor!

you got four wrong entries

> e820 update range: 00000000cff00000 - 0000000100000000 (usable) ==> (reserved)
> init_memory_mapping: 0000000000000000-00000000379fe000
>  0000000000 - 0000200000 page 4k
>  0000200000 - 0037800000 page 2M
>  0037800000 - 00379fe000 page 4k
> ...
> ...
> ...
> ...
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> ADDRCONF(NETDEV_UP): eth1: link is not ready
>   get_mtrr: cpu0 reg00 base=0000000000 size=0010000000 write-back
>   get_mtrr: cpu0 reg01 base=00000cff00 size=0000000100 uncachable
>   get_mtrr: cpu0 reg02 base=00000d0000 size=0000010000 uncachable
>   get_mtrr: cpu0 reg03 base=00000e0000 size=0000020000 uncachable
>   get_mtrr: cpu0 reg04 base=0000000004 size=0000000001 uncachable
>   get_mtrr: cpu0 reg05 base=0000000005 size=0000000001 uncachable
>   get_mtrr: cpu0 reg06 base=0000000006 size=0000000001 uncachable
>   get_mtrr: cpu0 reg07 base=0000000007 size=0000000001 uncachable
>   get_mtrr: cpu0 reg00 base=0000000000 size=0010000000 write-back
>   get_mtrr: cpu0 reg01 base=00000cff00 size=0000000100 uncachable
>   get_mtrr: cpu0 reg02 base=00000d0000 size=0000010000 uncachable
>   get_mtrr: cpu0 reg03 base=00000e0000 size=0000020000 uncachable
>   get_mtrr: cpu0 reg04 base=0000000004 size=0000000001 uncachable
>   get_mtrr: cpu0 reg05 base=0000000005 size=0000000001 uncachable
>   get_mtrr: cpu0 reg06 base=0000000006 size=0000000001 uncachable
>   get_mtrr: cpu0 reg07 base=0000000007 size=0000000001 uncachable
> bnx2: eth1 NIC Copper Link is Up, 1000 Mbps full duplex, receive & transmit flow control ON
> ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
>   get_mtrr: cpu0 reg00 base=0000000000 size=0010000000 write-back
>   get_mtrr: cpu0 reg01 base=00000cff00 size=0000000100 uncachable
>   get_mtrr: cpu0 reg02 base=00000d0000 size=0000010000 uncachable
>   get_mtrr: cpu0 reg03 base=00000e0000 size=0000020000 uncachable
>   get_mtrr: cpu0 reg04 base=0000000004 size=0000000001 uncachable
>   get_mtrr: cpu0 reg05 base=0000000005 size=0000000001 uncachable
>   get_mtrr: cpu0 reg06 base=0000000006 size=0000000001 uncachable
>   get_mtrr: cpu0 reg07 base=0000000007 size=0000000001 uncachable
>   get_mtrr: cpu0 reg00 base=0000000000 size=0010000000 write-back
>   get_mtrr: cpu0 reg01 base=00000cff00 size=0000000100 uncachable
>   get_mtrr: cpu0 reg02 base=00000d0000 size=0000010000 uncachable
>   get_mtrr: cpu0 reg03 base=00000e0000 size=0000020000 uncachable
>   get_mtrr: cpu0 reg04 base=0000000004 size=0000000001 uncachable
>   get_mtrr: cpu0 reg05 base=0000000005 size=0000000001 uncachable
>   get_mtrr: cpu0 reg06 base=0000000006 size=0000000001 uncachable
>   get_mtrr: cpu0 reg07 base=0000000007 size=0000000001 uncachable
>   get_mtrr: cpu0 reg00 base=0000000000 size=0010000000 write-back
>   get_mtrr: cpu0 reg01 base=00000cff00 size=0000000100 uncachable
>   get_mtrr: cpu0 reg02 base=00000d0000 size=0000010000 uncachable
>   get_mtrr: cpu0 reg03 base=00000e0000 size=0000020000 uncachable
>   get_mtrr: cpu0 reg04 base=0000000004 size=0000000001 uncachable
>   get_mtrr: cpu0 reg05 base=0000000005 size=0000000001 uncachable
>   get_mtrr: cpu0 reg06 base=0000000006 size=0000000001 uncachable
>   get_mtrr: cpu0 reg07 base=0000000007 size=0000000001 uncachable
>   get_mtrr: cpu0 reg00 base=0000000000 size=0010000000 write-back
> mtrr: type mismatch for d8000000,4000000 old: write-back new: write-combining
>   get_mtrr: cpu0 reg00 base=0000000000 size=0010000000 write-back
>   get_mtrr: cpu0 reg01 base=00000cff00 size=0000000100 uncachable
>   get_mtrr: cpu0 reg02 base=00000d0000 size=0000010000 uncachable
>   get_mtrr: cpu0 reg03 base=00000e0000 size=0000020000 uncachable
>   get_mtrr: cpu0 reg04 base=0000000004 size=0000000001 uncachable
>   get_mtrr: cpu0 reg05 base=0000000005 size=0000000001 uncachable
>   get_mtrr: cpu0 reg06 base=0000000006 size=0000000001 uncachable
>   get_mtrr: cpu0 reg07 base=0000000007 size=0000000001 uncachable
> 

you may try MTRR cleanup
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1

it should clear the strange entries and find some spare one for your driver that need ...
it will get some performance improvement.

or talk to your system vendor to get a new BIOS.

YH
