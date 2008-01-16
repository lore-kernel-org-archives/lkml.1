Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbYAPDcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbYAPDcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbYAPDcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:32:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:55036 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbYAPDcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:32:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VxUJPvMRDA2coRPhuVnf5JWcQvvqy6PdBnGxiiz80J13eihvRR1KO1esWmHkT4EQucEf8EfWP0xfF1Xi+iZQlrDl2CP+rrkekgdACqT4ZLovsQTCdFRP7dYMgPj4KHY9akHe2ODzVh6uRpn8zahTCsXo/eUyK+WsxnbpMjXKapM=
Message-ID: <86802c440801151932o6aaea248w7d1137eaa2ac3579@mail.gmail.com>
Date: Tue, 15 Jan 2008 19:32:17 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: hpet_late_init hang
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"
commit e5ed385fa0d6f35406e3e3ed75e5eb9adeb811df
Author: Balaji Rao <balajirrao@gmail.com>
Date:   Tue Jan 15 16:53:29 2008 +0100

    Assign IRQs to HPET Timers
"
in x86.git

cause my servers hang
after
Calling initcall 0xffffffff80b9a465: hpet_late_init+0x0/0x100()

after reverting that I got:

initcall 0xffffffff80b947d1 ran for 19 msecs: pci_iommu_init+0x0/0x13()
Calling initcall 0xffffffff80b9a465: hpet_late_init+0x0/0x100()
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
initcall 0xffffffff80b9a465: hpet_late_init+0x0/0x100() returned 0.
initcall 0xffffffff80b9a465 ran for 7 msecs: hpet_late_init+0x0/0x100()

           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
      CPU6       CPU7
  0:         86          0          0          0          0          0
         1          0   IO-APIC-edge      timer
  4:          0          0          0          0          0          0
         1        838   IO-APIC-edge      serial
  7:          1          0          0          0          0          0
         0          0   IO-APIC-edge
  8:          0          0          0          0          0          0
         0          0   IO-APIC-edge      rtc0

for mcp55, it should already route hpet to ioapic pin2 or the irq0.

YH
