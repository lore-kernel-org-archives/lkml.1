Return-Path: <linux-kernel-owner+w=401wt.eu-S1750981AbZHRWEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981AbZHRWEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbZHRWEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:04:10 -0400
Received: from ru.mvista.com ([213.79.90.228]:44056 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750831AbZHRWEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:04:09 -0400
Date: Wed, 19 Aug 2009 02:04:10 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] powerpc/cpm: Remove SPI defines and spi structs
Message-ID: <20090818220410.GA25090@oksana.dev.rtsoft.ru>
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cpm2.h included into spi_mpc8xxx driver, the SPI defines
in the header conflict with defines in the driver.

We don't need them in the header file, so remove them. Plus
remove "struct spi", we'll use a better version in the driver.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/include/asm/cpm1.h |   45 ---------------------------------------
 arch/powerpc/include/asm/cpm2.h |   39 ---------------------------------
 2 files changed, 0 insertions(+), 84 deletions(-)

diff --git a/arch/powerpc/include/asm/cpm1.h b/arch/powerpc/include/asm/cpm1.h
index 7685ffd..81b0119 100644
--- a/arch/powerpc/include/asm/cpm1.h
+++ b/arch/powerpc/include/asm/cpm1.h
@@ -478,51 +478,6 @@ typedef struct iic {
 	char	res2[2];	/* Reserved */
 } iic_t;
 
-/* SPI parameter RAM.
-*/
-typedef struct spi {
-	ushort	spi_rbase;	/* Rx Buffer descriptor base address */
-	ushort	spi_tbase;	/* Tx Buffer descriptor base address */
-	u_char	spi_rfcr;	/* Rx function code */
-	u_char	spi_tfcr;	/* Tx function code */
-	ushort	spi_mrblr;	/* Max receive buffer length */
-	uint	spi_rstate;	/* Internal */
-	uint	spi_rdp;	/* Internal */
-	ushort	spi_rbptr;	/* Internal */
-	ushort	spi_rbc;	/* Internal */
-	uint	spi_rxtmp;	/* Internal */
-	uint	spi_tstate;	/* Internal */
-	uint	spi_tdp;	/* Internal */
-	ushort	spi_tbptr;	/* Internal */
-	ushort	spi_tbc;	/* Internal */
-	uint	spi_txtmp;	/* Internal */
-	uint	spi_res;
-	ushort	spi_rpbase;	/* Relocation pointer */
-	ushort	spi_res2;
-} spi_t;
-
-/* SPI Mode register.
-*/
-#define SPMODE_LOOP	((ushort)0x4000)	/* Loopback */
-#define SPMODE_CI	((ushort)0x2000)	/* Clock Invert */
-#define SPMODE_CP	((ushort)0x1000)	/* Clock Phase */
-#define SPMODE_DIV16	((ushort)0x0800)	/* BRG/16 mode */
-#define SPMODE_REV	((ushort)0x0400)	/* Reversed Data */
-#define SPMODE_MSTR	((ushort)0x0200)	/* SPI Master */
-#define SPMODE_EN	((ushort)0x0100)	/* Enable */
-#define SPMODE_LENMSK	((ushort)0x00f0)	/* character length */
-#define SPMODE_LEN4	((ushort)0x0030)	/*  4 bits per char */
-#define SPMODE_LEN8	((ushort)0x0070)	/*  8 bits per char */
-#define SPMODE_LEN16	((ushort)0x00f0)	/* 16 bits per char */
-#define SPMODE_PMMSK	((ushort)0x000f)	/* prescale modulus */
-
-/* SPIE fields */
-#define SPIE_MME	0x20
-#define SPIE_TXE	0x10
-#define SPIE_BSY	0x04
-#define SPIE_TXB	0x02
-#define SPIE_RXB	0x01
-
 /*
  * RISC Controller Configuration Register definitons
  */
diff --git a/arch/powerpc/include/asm/cpm2.h b/arch/powerpc/include/asm/cpm2.h
index 990ff19..236cfa3 100644
--- a/arch/powerpc/include/asm/cpm2.h
+++ b/arch/powerpc/include/asm/cpm2.h
@@ -654,45 +654,6 @@ typedef struct iic {
 	uint	iic_txtmp;	/* Internal */
 } iic_t;
 
-/* SPI parameter RAM.
-*/
-typedef struct spi {
-	ushort	spi_rbase;	/* Rx Buffer descriptor base address */
-	ushort	spi_tbase;	/* Tx Buffer descriptor base address */
-	u_char	spi_rfcr;	/* Rx function code */
-	u_char	spi_tfcr;	/* Tx function code */
-	ushort	spi_mrblr;	/* Max receive buffer length */
-	uint	spi_rstate;	/* Internal */
-	uint	spi_rdp;	/* Internal */
-	ushort	spi_rbptr;	/* Internal */
-	ushort	spi_rbc;	/* Internal */
-	uint	spi_rxtmp;	/* Internal */
-	uint	spi_tstate;	/* Internal */
-	uint	spi_tdp;	/* Internal */
-	ushort	spi_tbptr;	/* Internal */
-	ushort	spi_tbc;	/* Internal */
-	uint	spi_txtmp;	/* Internal */
-	uint	spi_res;	/* Tx temp. */
-	uint	spi_res1[4];	/* SDMA temp. */
-} spi_t;
-
-/* SPI Mode register.
-*/
-#define SPMODE_LOOP	((ushort)0x4000)	/* Loopback */
-#define SPMODE_CI	((ushort)0x2000)	/* Clock Invert */
-#define SPMODE_CP	((ushort)0x1000)	/* Clock Phase */
-#define SPMODE_DIV16	((ushort)0x0800)	/* BRG/16 mode */
-#define SPMODE_REV	((ushort)0x0400)	/* Reversed Data */
-#define SPMODE_MSTR	((ushort)0x0200)	/* SPI Master */
-#define SPMODE_EN	((ushort)0x0100)	/* Enable */
-#define SPMODE_LENMSK	((ushort)0x00f0)	/* character length */
-#define SPMODE_PMMSK	((ushort)0x000f)	/* prescale modulus */
-
-#define SPMODE_LEN(x)	((((x)-1)&0xF)<<4)
-#define SPMODE_PM(x)	((x) &0xF)
-
-#define SPI_EB		((u_char)0x10)		/* big endian byte order */
-
 /* IDMA parameter RAM
 */
 typedef struct idma {
-- 
1.6.3.3

