Return-Path: <linux-kernel-owner+w=401wt.eu-S1759110AbYCDEYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110AbYCDEYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 23:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbYCDEYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 23:24:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42709 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYCDEYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 23:24:34 -0500
Message-ID: <47CCCED4.30607@zytor.com>
Date: Mon, 03 Mar 2008 20:23:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: early_res and find_e820_area for i386?
References: <1204601883.4707.96.camel@caritas-dev.intel.com>
In-Reply-To: <1204601883.4707.96.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> Hi,
> 
> Before bootmem allocator is available, kernel needs allocate memory
> pages such as page table and some NUMA structures. On x86_64, this is
> done by early_res and find_e820_area. On i386, this is done through
> using the memory area after kernel itself which is tracked with
> init_pg_tables_end.
> 
> Is it better to implement early_res and find_e820_area on i386? Can we
> trust E820 table on i386?
> 
> Or we add an early_alloc, which allocate memory from the memory area
> after kernel itself and check the early_res areas and E820 table too.
> 
> BTW: Why not merge e820_32.c and e820_64.c? At least part of them.
> 

What we *should* do, on both i386 and x86-64, is to create a synthetic 
e820 table of any non-e820 information, and then yes, we should merge 
the code.

In other words, we should have an e820 table which reflects what the 
kernel considers true about the memory space.

	-hpa
