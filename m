Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZBJClA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZBJClA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 21:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZBJCkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 21:40:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:50003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZBJCkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 21:40:52 -0500
Message-ID: <4990E90D.30005@kernel.org>
Date: Mon, 09 Feb 2009 18:40:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Morten P.D. Stevens" <mstevens@win-professional.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with	2.6.29-rc3
 on IBM x3400
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com> <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com> <20090209234528.GA862@elte.hu>
In-Reply-To: <20090209234528.GA862@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Morten P.D. Stevens <mstevens@win-professional.com> wrote:
> 
>> Hi,
>>
>> Update:
>>
>> the same issue with a linux 2.6.28.4 kernel.
>>
>> [    0.000000] ------------[ cut here ]------------
>> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404 generic_get_mtrr+0xdf/0x119()
>> [    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
> 
> buggy BIOS most likely. Had the kernel not fixed up the MTRRs you'd have
> a very slow and unhappy system now.

please try:
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 0c0a455..7a359ce 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -397,7 +397,8 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 		tmp |= ~((1<<(hi - 1)) - 1);
 
 		if (tmp != mask_lo) {
-			WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
+			printk(KERN_INFO "mtrr: BIOS set mask_lo: %x should be %x, fixing it up\n", mask_lo, tmp);
+			WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set up an incorrect mask.\n");
 			mask_lo = tmp;
 		}
 	}
