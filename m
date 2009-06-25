Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZFYHZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZFYHZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 03:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZFYHZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 03:25:08 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:38576 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752332AbZFYHZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 03:25:07 -0400
Message-ID: <4A432652.9070907@snapgear.com>
Date: Thu, 25 Jun 2009 17:25:06 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, gerg@uclinux.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] m68k: merge the non-mmu and mmu versions of hardirq.h
References: <200906170710.n5H7AxxV009015@localhost.localdomain> <200906170941.44383.arnd@arndb.de> <4A3A4A16.6080307@snapgear.com>
In-Reply-To: <4A3A4A16.6080307@snapgear.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Greg Ungerer wrote:
> Arnd Bergmann wrote:
>> On Wednesday 17 June 2009, Greg Ungerer wrote:
>>> [PATCH] m68k: merge the non-mmu and mmu versions of hardirq.h
>>>
>>> There is nothing different required between the non-mmu and mmu
>>> versions of hardirq.h, so merge them back into a single file.
>>>
>>> Signed-off-by: Greg Ungerer <gerg@uclinux.org>
>>
>> AFAICT this file is also the same in the new asm-generic version, so you
>> could fall back to that directly.
> 
> Indeed it could. It will need a clean out of ack_bad_irq() in
> arch/m68knommu/kernel.irq.c, but otherwise looks good.
> 
> I'll prepare a new patch that uses that.

This turns out not to be as trivial as I first thought.

The include of linux/irq.h in the asm-generic/hardirq.h
causes all sorts of include ordering problems for the m68k
hardirq.h. The m68k hardirq.h includes asm/irq.h instead.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
