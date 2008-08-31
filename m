Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYHaQMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYHaQMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 12:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYHaQLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 12:11:37 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54804 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbYHaQLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 12:11:34 -0400
Date: Sun, 31 Aug 2008 19:10:21 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, geert@linux-m68k.org
Subject: [2.6 patch] m68knommu: remove the eLIA support
Message-ID: <20080831161021.GF3695@cs181140183.pp.htv.fi>
References: <20080819134718.GH8852@cs181140183.pp.htv.fi> <48B24E2C.9060703@snapgear.com> <20080825204333.GA13027@cs181140183.pp.htv.fi> <48B77764.6060607@snapgear.com> <20080829070103.GD16462@cs181140183.pp.htv.fi> <48B7D88C.2070804@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48B7D88C.2070804@snapgear.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 09:07:56PM +1000, Greg Ungerer wrote:
>
> Hi Adrian,

Hi Greg,

> Adrian Bunk wrote:
>> On Fri, Aug 29, 2008 at 02:13:24PM +1000, Greg Ungerer wrote:
>...
>>> Only ever a handful where made, and that was in 1999.
>>> I doubt anyone could ever use the PCI interface on it
>>> in any useful way.
>>
>> So I can send a patch to remove the platform?
>
> Yeah, I guess we can add in back in of anyone complains.
> I don't know of any users of it anymore.
>...

Patch below.

> Regards
> Greg

cu
Adrian


<--  snip  -->


Greg Ungerer said about this board:
Only ever a handful where made, and that was in 1999.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68knommu/Kconfig                |    6 ------
 arch/m68knommu/Makefile               |    1 -
 arch/m68knommu/include/asm/system.h   |    2 +-
 arch/m68knommu/platform/5307/config.c |    2 +-
 4 files changed, 2 insertions(+), 9 deletions(-)


diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 15ffd55..f43d50f 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -399,12 +399,6 @@ config M5307C3
 	help
 	  Support for the Motorola M5307C3 board.
 
-config eLIA
-	bool "Moreton Bay eLIA board support"
-	depends on M5307
-	help
-	  Support for the Moreton Bay eLIA board.
-
 config SECUREEDGEMP3
 	bool "SnapGear SecureEdge/MP3 platform support"
 	depends on M5307
diff --git a/arch/m68knommu/Makefile b/arch/m68knommu/Makefile
index b63bbcf..fd0fb30 100644
--- a/arch/m68knommu/Makefile
+++ b/arch/m68knommu/Makefile
@@ -41,7 +41,6 @@ board-$(CONFIG_M5271EVB)	:= M5271EVB
 board-$(CONFIG_M5275EVB)	:= M5275EVB
 board-$(CONFIG_M5282EVB)	:= M5282EVB
 board-$(CONFIG_ELITE)		:= eLITE
-board-$(CONFIG_eLIA)		:= eLIA
 board-$(CONFIG_NETtel)		:= NETtel
 board-$(CONFIG_SECUREEDGEMP3)	:= MP3
 board-$(CONFIG_CLEOPATRA)	:= CLEOPATRA
diff --git a/arch/m68knommu/include/asm/system.h b/arch/m68knommu/include/asm/system.h
index 40f49de..4496c0a 100644
--- a/arch/m68knommu/include/asm/system.h
+++ b/arch/m68knommu/include/asm/system.h
@@ -230,7 +230,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
         jmp 0xf0000400;			\
         ");				\
 })
-#elif defined(CONFIG_NETtel) || defined(CONFIG_eLIA) || \
+#elif defined(CONFIG_NETtel) || \
       defined(CONFIG_SECUREEDGEMP3) || defined(CONFIG_CLEOPATRA)
 #define HARD_RESET_NOW() ({		\
         asm("				\
diff --git a/arch/m68knommu/platform/5307/config.c b/arch/m68knommu/platform/5307/config.c
index 11cff66..724faf0 100644
--- a/arch/m68knommu/platform/5307/config.c
+++ b/arch/m68knommu/platform/5307/config.c
@@ -123,7 +123,7 @@ void __init config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 
-#if defined(CONFIG_NETtel) || defined(CONFIG_eLIA) || \
+#if defined(CONFIG_NETtel) || \
     defined(CONFIG_SECUREEDGEMP3) || defined(CONFIG_CLEOPATRA)
 	/* Copy command line from FLASH to local buffer... */
 	memcpy(commandp, (char *) 0xf0004000, size);

