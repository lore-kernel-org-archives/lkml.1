Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbYBYCS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbYBYCS7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 21:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYBYCSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 21:18:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37935 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbYBYCSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 21:18:50 -0500
Message-ID: <47C22568.1010405@zytor.com>
Date: Sun, 24 Feb 2008 18:18:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] Fix alignment of early reservation for EBDA
References: <20080224174605.GA21661@mailshack.com>
In-Reply-To: <20080224174605.GA21661@mailshack.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> Hi Andi,
> 
> My eyes fell on the following table in the boot messages:
> 
> early res: 0 [0-fff] BIOS data page
> early res: 1 [6000-7fff] SMP_TRAMPOLINE
> early res: 2 [200000-374557] TEXT DATA BSS
> early res: 3 [9fc00-a0bff] EBDA
> early res: 4 [8000-afff] PGTABLE
> 
> The memory reserved for the EBDA overflows into the area normally
> reserved for the VGA adaptor. It seems that you wanted to force
> the allocation to cover whole pages, like:
> 
> early res: 3 [9f000-9ffff] EBDA
> 
> This is what this patch implements.
> 
> Is it really necessary to force the allocation to a page boundary?
> 

It is, but that rounding gets done in reserve_bootmem() anyway, so there 
is no need for the arch-specific code to do it.

The 32-bit EBDA code hard-codes a size of 4K, which is probably equally 
wrong; my gut feel is that the right thing to do is to reserve from the 
EBDA up to the 640K mark (some BIOSes use an area like that for SMM 
stuff), possibly with some sanity checking.

	-hpa
