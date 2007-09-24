Return-Path: <linux-kernel-owner+w=401wt.eu-S1764918AbXIXRGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764918AbXIXRGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759939AbXIXRGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:06:33 -0400
Received: from mail0.scram.de ([78.47.204.202]:38874 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759066AbXIXRGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:06:32 -0400
X-Spam-Score: -3.904
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <46F7EE95.1040509@scram.de>
Date: Mon, 24 Sep 2007 19:06:29 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH4/4] [POWERPC] Fix cpm_uart driver
References: <46F6C9DC.90008@scram.de> <46F7DE85.7000401@freescale.com>
In-Reply-To: <46F7DE85.7000401@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood schrieb:
> Jochen Friedrich wrote:
>>
>> In cpm_uart_core, functions cpm_uart_init_bd and cpm_uart_init_scc
>> an offset into DP RAM is calculated by substracting a physical
>> memory constant from an virtual address. This patch fixes the
>> problem by converting the virtual address into a physical
>> first.
>
> Huh?  DPRAM_BASE is a virtual address.  With this patch, you'd be 
> subtracting a virtual address from a physical address.

Thanks for pointing me to it. So the bug is in cpm_uart_cpm1.h assigning 
a physical memory to DPRAM_BASE (at least on ARC=ppc). cpm_uart_cpm2.h 
seems to be correct though. I'll submit a new patch for this.

Thanks,
Jochen
