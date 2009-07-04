Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZGDBm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZGDBm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbZGDBme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:42:34 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3013 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZGDBmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:42:31 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
       "Scott Branden" <sbranden@broadcom.com>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 18:42:10 -0700
Subject: [PATCH v2 0/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 0/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SKWsaBCXX8mTRPCl4vdMThgHDA==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C0D@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506CFE0EG20715738-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Try to submit our code to kernel again. The patchset can be applied to the latest git tree of mainline kernel.
Thanks for all the feedback on our previous submission.

Changelog since v1.

* fixed all coding style related problem found by checkpatch.pl, no errors reported, still some warnings
* use proper indentation formatted by Lindent script
* replace MIN macro definition with in kernel min() function
* fix global name, use proper lower case platform specific name
* split patches into smaller pieces for review

The following is the short stat of the submission.
-----------------------------------------------
commit 2babc1511a7ac97f35e37c992ef47567d2ad99da
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 17:30:51 2009 -0700

    add default configuration
    
    default configuration for bcmring arch.

 arch/arm/configs/bcmring_defconfig |  724 ++++++++++++++++++++++++++++++++++++
 1 files changed, 724 insertions(+), 0 deletions(-)

commit d3f98479bf28324a3472f3f637014a28ffef29ab
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 17:27:16 2009 -0700

    bcmring nand driver
    
    add bcmring umi nand driver
    with hardware ecc support

 drivers/mtd/nand/Kconfig                 |   16 +
 drivers/mtd/nand/Makefile                |    2 +
 drivers/mtd/nand/nand_bcm_umi.c          |  879 ++++++++++++++++++++++++++++++
 drivers/mtd/nand/nand_calculate_ecc512.c |  254 +++++++++
 drivers/mtd/nand/nand_correct_data512.c  |  153 ++++++
 include/linux/mtd/nand_bcm_umi.h         |  235 ++++++++
 include/linux/mtd/nand_ecc512.h          |   26 +
 7 files changed, 1565 insertions(+), 0 deletions(-)

commit 1be0a56b00cff4e5c8115e635751c803e440f80d
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 17:25:12 2009 -0700

    csp dmac package
    
    bcmring dma controller block low level functions

 arch/arm/mach-bcmring/csp/dmac/Makefile       |    1 +
 arch/arm/mach-bcmring/csp/dmac/dmacHw.c       |  940 +++++++++++++++++++++++
 arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c | 1017 +++++++++++++++++++++++++
 3 files changed, 1958 insertions(+), 0 deletions(-)

commit 11d31740c278273b22d9ae32b2c996c9656954d5
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 17:23:46 2009 -0700

    add csp tmr block
    
    bcmring timer block functions,

 arch/arm/mach-bcmring/csp/tmr/Makefile |    1 +
 arch/arm/mach-bcmring/csp/tmr/tmrHw.c  |  576 ++++++++++++++++++++++++++++++++
 2 files changed, 577 insertions(+), 0 deletions(-)

commit daede68e15a5580ae0d68bd7572144d04fec1d36
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 17:11:28 2009 -0700

    csp/chipc code
    
    bcmring chipc block, csp functions including clock freq. setting, chipc
    module init, PLL init, reset functions

 arch/arm/mach-bcmring/csp/chipc/Makefile           |    1 +
 arch/arm/mach-bcmring/csp/chipc/chipcHw.c          |  782 ++++++++++++++++++++
 .../mach-bcmring/csp/chipc/chipcHw_clkreconfig.c   |  248 +++++++
 arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c     |  293 ++++++++
 arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c    |  125 ++++
 arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c      |   64 ++
 6 files changed, 1513 insertions(+), 0 deletions(-)

commit 0bd39d8149f37841be0b24c018f2f9d05129ee71
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 17:11:01 2009 -0700

    mach-bcmring/csp Makefile
    
    add mach-bcmring/csp Makefile

 arch/arm/mach-bcmring/csp/Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

commit 650d9f18f145bae788fb7992c1a9c559132f6a1e
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 17:08:52 2009 -0700

    add mach-bcmring/include/csp header files
    
    add mach-bcmring/include/csp header files, they are function prototypes

 arch/arm/mach-bcmring/include/csp/cache.h  |   35 ++++
 arch/arm/mach-bcmring/include/csp/delay.h  |   36 ++++
 arch/arm/mach-bcmring/include/csp/errno.h  |   32 +++
 arch/arm/mach-bcmring/include/csp/module.h |   32 +++
 arch/arm/mach-bcmring/include/csp/reg.h    |  113 +++++++++++
 arch/arm/mach-bcmring/include/csp/secHw.h  |   65 ++++++
 arch/arm/mach-bcmring/include/csp/stdint.h |   30 +++
 arch/arm/mach-bcmring/include/csp/tmrHw.h  |  263 ++++++++++++++++++++++++
 arch/arm/mach-bcmring/include/csp/uartHw.h |  296 ++++++++++++++++++++++++++++
 9 files changed, 902 insertions(+), 0 deletions(-)

commit d4e2a34763798d42671ab257445b2b5f7e3e1cb9
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 17:07:59 2009 -0700

    include/mach/csp header files
    
    add mach-bcmring/include/mach/csp header files
    most of them are register definitions

 arch/arm/mach-bcmring/include/mach/csp/cap.h       |   63 +
 .../arm/mach-bcmring/include/mach/csp/cap_inline.h |  409 +++++
 .../mach-bcmring/include/mach/csp/chipcHw_def.h    | 1123 +++++++++++++
 .../mach-bcmring/include/mach/csp/chipcHw_inline.h | 1673 ++++++++++++++++++++
 .../mach-bcmring/include/mach/csp/chipcHw_reg.h    |  530 +++++++
 arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h   |  872 ++++++++++
 arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h    |   73 +
 arch/arm/mach-bcmring/include/mach/csp/secHw_def.h |  100 ++
 .../mach-bcmring/include/mach/csp/secHw_inline.h   |   79 +
 .../mach-bcmring/include/mach/csp/uartHw_inline.h  |  361 +++++
 .../arm/mach-bcmring/include/mach/csp/uartHw_reg.h |  169 ++
 11 files changed, 5452 insertions(+), 0 deletions(-)

commit 35fe5c745edbed1e074940f9cef125575a56c6b5
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 17:06:49 2009 -0700

    add header files for mach-bcmring
    
    add other headef files in mach-bcmring/include/mach directory

 arch/arm/mach-bcmring/include/mach/clkdev.h        |    7 +
 arch/arm/mach-bcmring/include/mach/entry-macro.S   |   90 ++++++++++++
 arch/arm/mach-bcmring/include/mach/io.h            |   56 ++++++++
 arch/arm/mach-bcmring/include/mach/irqs.h          |  135 ++++++++++++++++++
 arch/arm/mach-bcmring/include/mach/memory.h        |   45 ++++++
 .../mach-bcmring/include/mach/memory_settings.h    |   67 +++++++++
 arch/arm/mach-bcmring/include/mach/reg_nand.h      |   61 ++++++++
 arch/arm/mach-bcmring/include/mach/reg_umi.h       |  144 ++++++++++++++++++++
 arch/arm/mach-bcmring/include/mach/timex.h         |   25 ++++
 arch/arm/mach-bcmring/include/mach/uncompress.h    |   52 +++++++
 arch/arm/mach-bcmring/include/mach/vmalloc.h       |   32 +++++
 11 files changed, 714 insertions(+), 0 deletions(-)

commit b26374d35d7ffc2fe6512c90fffae59890ed46cb
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 17:04:06 2009 -0700

    add mach-bcmring timer.c
    
    timer helper function, timer hardware register header file

 arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h |   82 ++++++++++++++++++++
 arch/arm/mach-bcmring/include/mach/timer.h         |   77 ++++++++++++++++++
 arch/arm/mach-bcmring/timer.c                      |   62 +++++++++++++++
 3 files changed, 221 insertions(+), 0 deletions(-)

commit 44f251fe10d28ca74bdd98daf2fbe25eb5444c1b
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 17:02:23 2009 -0700

    add mach-bcmring/dma.c
    
    add dma support for bcmring
    add dma register header file

 arch/arm/mach-bcmring/dma.c                        | 2892 ++++++++++++++++++++
 arch/arm/mach-bcmring/include/csp/dmacHw.h         |  596 ++++
 .../mach-bcmring/include/mach/csp/dmacHw_priv.h    |  145 +
 .../arm/mach-bcmring/include/mach/csp/dmacHw_reg.h |  406 +++
 arch/arm/mach-bcmring/include/mach/dma.h           |  826 ++++++
 5 files changed, 4865 insertions(+), 0 deletions(-)

commit 1fd568d97729a0e174508593c04381966347c439
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 16:24:22 2009 -0700

    add mach-bcmring/mm.c
    
    memory map description and init

 arch/arm/mach-bcmring/mm.c |   71 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)

commit 22455371f1771769f747db9d735a9856e9d03431
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 16:23:10 2009 -0700

    add mach-bcmring/irq.c
    
    init irq and handler
    add irq controller register file

 arch/arm/mach-bcmring/include/csp/intcHw.h         |   45 ++++
 .../arm/mach-bcmring/include/mach/csp/intcHw_reg.h |  270 ++++++++++++++++++++
 arch/arm/mach-bcmring/irq.c                        |  127 +++++++++
 3 files changed, 442 insertions(+), 0 deletions(-)

commit 2ad360b903637f0ddb87bc7f75d2cf8a47b0ef55
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 16:21:55 2009 -0700

    add mach-bcmring/clock.c clock.h
    
    implement clock set/get disable/enable API

 arch/arm/mach-bcmring/clock.c |  235 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-bcmring/clock.h |   33 ++++++
 2 files changed, 268 insertions(+), 0 deletions(-)

commit bb9f09c2155b1d699530c045af8cd4b44deb5983
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 16:20:47 2009 -0700

    add mach-bcmring/core.c core.h
    
    bcmring timer init, clocksource init, amba init functions

 arch/arm/mach-bcmring/core.c |  348 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-bcmring/core.h |   49 ++++++
 2 files changed, 397 insertions(+), 0 deletions(-)

commit 8e210728566d73fbb25b48de611d786d9fb1ddf3
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 16:18:06 2009 -0700

    add arch/arm/mach-bcmring/arch.c
    
    bcmring support in arch.c, add machine description, init_machine
    function
    
    add cfg_global header files
    
    add include/mach/csp/mm_*.h header files for memory map and io address
    
    add include/mach/system.h and include/mach/hardware.h

 arch/arm/mach-bcmring/arch.c                       |  174 ++++++++++++++++++++
 arch/arm/mach-bcmring/include/cfg_global.h         |   16 ++
 arch/arm/mach-bcmring/include/cfg_global_defines.h |   51 ++++++
 arch/arm/mach-bcmring/include/mach/csp/mm_addr.h   |  101 +++++++++++
 arch/arm/mach-bcmring/include/mach/csp/mm_io.h     |  160 ++++++++++++++++++
 arch/arm/mach-bcmring/include/mach/hardware.h      |   62 +++++++
 arch/arm/mach-bcmring/include/mach/system.h        |   54 ++++++
 7 files changed, 618 insertions(+), 0 deletions(-)

commit 075b11bdfff8ee13d9f3c4208e1a1c89b0d8d1ed
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 14:34:18 2009 -0700

    add mach-bcmring Kconfig/Makefile/Makefile.boot
    
    bcmring Kconfig option
    Makefile and Makefile.boot

 arch/arm/mach-bcmring/Kconfig       |   21 +++++++++++++++++++++
 arch/arm/mach-bcmring/Makefile      |    8 ++++++++
 arch/arm/mach-bcmring/Makefile.boot |    6 ++++++
 3 files changed, 35 insertions(+), 0 deletions(-)

commit 1b449f6b7b8634f2ade5b2459c44f45a53566a06
Author: Leo Chen <leochen@broadcom.com>
Date:   Fri Jul 3 14:31:10 2009 -0700

    add bcmring support in arch/arm/Kconfg and Makefile
    
    add ARCH_BCMRING Kconfig option
    add entry in Makefile

 arch/arm/Kconfig  |   14 ++++++++++++++
 arch/arm/Makefile |    1 +
 2 files changed, 15 insertions(+), 0 deletions(-)

-------- 
Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


