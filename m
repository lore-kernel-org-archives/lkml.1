Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbZBXTmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbZBXTmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 14:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbZBXTmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 14:42:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50081 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbZBXTmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 14:42:05 -0500
Date: Tue, 24 Feb 2009 20:41:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: check range in reserve_early()
Message-ID: <20090224194146.GA28772@elte.hu>
References: <49A32F40.7080403@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A32F40.7080403@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: cleanup
> 
> one 32bit system report:
> 
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000001c000000 (usable)
>  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
> DMI 2.0 present.
> last_pfn = 0x1c000 max_arch_pfn = 0x100000
> kernel direct mapping tables up to 1c000000 @ 7000-c000
> ...
> RAMDISK: 1bc69000 - 1bfef4fa
> ...
> 0MB HIGHMEM available.
> 448MB LOWMEM available.
>   mapped low ram: 0 - 1c000000
>   low ram: 00000000 - 1c000000
>   bootmap 00002000 - 00005800
> (9 early reservations) ==> bootmem [0000000000 - 001c000000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
>   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
>   #3 [0000400000 - 00009ed14c]    TEXT DATA BSS ==> [0000400000 - 00009ed14c]
>   #4 [001bc69000 - 001bfef4fa]          RAMDISK ==> [001bc69000 - 001bfef4fa]
>   #5 [00009ee000 - 00009f2000]    INIT_PG_TABLE ==> [00009ee000 - 00009f2000]
>   #6 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
>   #7 [0000007000 - 0000007000]          PGTABLE
>   #8 [0000002000 - 0000006000]          BOOTMAP ==> [0000002000 - 0000006000]
> 
> got strange blank entry with PGTABLE
> 
> the reason is init_pg_table is big enough, and zero range is called with
> init_memory_mapping/reserve_early()
> 
> so try to check the range in reserve_early()
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/e820.c |    3 +++
>  1 file changed, 3 insertions(+)

Applied to tip/x86/mm, thanks Yinghai!

	Ingo
