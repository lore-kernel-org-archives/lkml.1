Return-Path: <linux-kernel-owner+w=401wt.eu-S933936AbXCUTyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936AbXCUTyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933957AbXCUTyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:54:53 -0400
Received: from gherkin.frus.com ([192.158.254.49]:60984 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933936AbXCUTyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:54:51 -0400
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
To: linux-kernel@vger.kernel.org
Date: Wed, 21 Mar 2007 13:54:50 -0600 (CST)
CC: bunk@stusta.de, jikos@jikos.cz, bzolnier@gmail.com
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070321195450.36D5EDBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I originally wrote:
> Platform is a Dell CPxJ 650GT notebook.  Attempts to boot 2.6.21-rc3
> and -rc4 produce the following console output:
> 
> (apparently normal boot)
> ...
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> PIIX4: IDE controller at PCI slot 0000:00:07.1
> PIIX4: chipset revision 1
> PIIX4: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0x0860-0x0867, BIOS settings: hda:DMA, hdb:pio
>     ide1: BM-DMA at 0x0868-0x086f, BIOS settings: hdc:DMA, hdd:pio
> (hangs here)
> 
> The next two lines of output for 2.6.21-rc2 and earlier are:
> Probing IDE interface ide0...
> hda: TOSHIBA MK3017GAP, ATA DISK drive

After nine iterations of git-bisect --> compile --> reboot over the past
two days, the commit that caused this problem has been identified.

6bb74df481223731af6c7e0ff3adb31f6442cfcd is first bad commit
commit 6bb74df481223731af6c7e0ff3adb31f6442cfcd
Author: john stultz <johnstul@us.ibm.com>
Date:   Mon Mar 5 00:30:50 2007 -0800

    [PATCH] clocksource init adjustments (fix bug #7426)

    This patch resolves the issue found here:
    http://bugme.osdl.org/show_bug.cgi?id=7426

    The basic summary is:
    (omitted for brevity)

    Signed-off-by: John Stultz <johnstul@us.ibm.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: "David S. Miller" <davem@davemloft.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 b259cf01f6ad791a0f58c9956e6e0111cb9aa310 0e8fbf31c0bae9ca6039fc7781b53c12f7a67592 M      arch
:040000 040000 19bd5cf3c55c6b7947ec66b68eab643c99f15bb8 ef8fda0445287e34eeb466985901ca64191b6539 M      drivers
:040000 040000 4f84ad7bdf509ed83efd95d174796f1a6a948b0e 51624663be2fdce8aaeb3b49e188520aa3735d90 M      include
:040000 040000 ef82986d4590fed84b9a128da90e65f7e43f43a9 778d0cf7273d7514b436ca4e91a6948f34694972 M      kernel

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
