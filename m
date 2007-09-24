Return-Path: <linux-kernel-owner+w=401wt.eu-S1762271AbXIXSWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762271AbXIXSWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbXIXSWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:22:39 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:45103 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759065AbXIXSWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:22:38 -0400
Message-ID: <46F80049.2030509@freescale.com>
Date: Mon, 24 Sep 2007 13:22:01 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH4/4] [POWERPC] Fix cpm_uart driver
References: <46F6C9DC.90008@scram.de> <46F7DE85.7000401@freescale.com> <46F7EE95.1040509@scram.de>
In-Reply-To: <46F7EE95.1040509@scram.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
> Scott Wood schrieb:
>> Jochen Friedrich wrote:
>>>
>>> In cpm_uart_core, functions cpm_uart_init_bd and cpm_uart_init_scc
>>> an offset into DP RAM is calculated by substracting a physical
>>> memory constant from an virtual address. This patch fixes the
>>> problem by converting the virtual address into a physical
>>> first.
>>
>> Huh?  DPRAM_BASE is a virtual address.  With this patch, you'd be 
>> subtracting a virtual address from a physical address.
> 
> Thanks for pointing me to it. So the bug is in cpm_uart_cpm1.h assigning 
> a physical memory to DPRAM_BASE (at least on ARC=ppc). cpm_uart_cpm2.h 
> seems to be correct though. I'll submit a new patch for this.

cpmp is a physical address on arch/ppc?
/me looks at arch/ppc/8xx_io/commproc.c

Yikes.  Please don't change cpm_uart_cpm1.h, as it's correct for 
arch/powerpc, and there are numerous other places that assume cpmp is 
virtual (including in the very same function that assigns it a physical 
address).

You could fix arch/ppc if you want, though it may be easier to wait for 
it to die, and insist on identity maps in the meantime. :-)

-Scott
