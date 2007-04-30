Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbXD3KvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbXD3KvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbXD3KvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:51:12 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:51805 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbXD3KvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:51:10 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: Geode-GX1 processor in 2.6.21
Date: Mon, 30 Apr 2007 12:51:05 +0200
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301251.05697.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I do not understand it, but setting up some chipset features (tweaks) fail on 
Geode GX1.

In arch/i386/kernel/cpu/cyrix.c function geode_configure() tries to enable 
the "suspend on halt power saving feature". This is the line:

	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);

If this register is 0x00 before, it is still 0x00 after this line. If I change 
the line into this:

	ccr2 = getCx86(CX86_CCR2);
	ccr2 |= 0x88;
	setCx86(CX86_CCR2, ccr2);

register ccr2 is 0x88 after the setCx86 call and the power saving feature is 
active (and BTW: the TSC is useless then, because it also stops when the CPU 
runs into a HLT instruction).

setCx86 and getCx86 are macros defined in include/asm-i386/processor.h:

#define getCx86(reg) ({ outb((reg), 0x22); inb(0x23); })

#define setCx86(reg, data) do { \
         outb((reg), 0x22); \
         outb((data), 0x23); \
} while (0)

Maybe the compiler does the wrong thing if someone uses these macros in the 
same instruction?

Regards
Juergen
