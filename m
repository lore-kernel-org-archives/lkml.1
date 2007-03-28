Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbXC1Dcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbXC1Dcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 23:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXC1Dcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 23:32:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:14848 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbXC1Dcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 23:32:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=S7IyZ+rWwUwDq6ldq8j7uJIH2AfIeCRYmW9q9mn97M/16kgROmen6Tzsj72TyK550yj+KV4SwnZWer1n112fnG8+KoaMnPZ7m+JyUZDalU6Fxl1VUKuQ9/9j3Uy1+M8uF9NuCqE3T8zgcbZD/PcJ+S7P6g7ZZtP8EWxPdygw9ls=
Date: Wed, 28 Mar 2007 09:03:09 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [KJ][PATCH] BIT macro cleanup
Message-ID: <20070328033309.GA9597@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


BIT macro cleanup,now in bitops.h

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---

 arch/ppc/platforms/chestnut.c               |    1 
 drivers/edac/edac_mc.h                      |    2 -
 drivers/i2c/busses/i2c-pxa.c                |   55 ++++++++++++++--------------
 drivers/net/eth16i.c                        |    1 
 drivers/net/meth.h                          |    3 -
 drivers/net/s2io.h                          |    1 
 drivers/net/wireless/hostap/hostap_common.h |    3 -
 drivers/scsi/nsp32.h                        |    4 --
 drivers/scsi/pcmcia/nsp_cs.h                |    1 
 drivers/serial/amba-pl011.c                 |   37 ++++++++----------
 drivers/video/cyber2000fb.c                 |   44 +++++++++++-----------
 fs/select.c                                 |    1 
 include/asm-mips/ip32/crime.h               |    3 -
 include/asm-mips/ip32/mace.h                |    3 -
 include/linux/bitops.h                      |    3 +
 include/linux/input.h                       |    2 -
 include/video/sstfb.h                       |    1 
 include/video/tdfx.h                        |    3 -
 18 files changed, 73 insertions(+), 95 deletions(-)


diff --git a/arch/ppc/platforms/chestnut.c b/arch/ppc/platforms/chestnut.c
index a764ae7..248bfdd 100644
--- a/arch/ppc/platforms/chestnut.c
+++ b/arch/ppc/platforms/chestnut.c
@@ -48,7 +48,6 @@ extern void gen550_progress(char *, unsigned short);
 extern void gen550_init(int, struct uart_port *);
 extern void mv64360_pcibios_fixup(mv64x60_handle_t *bh);
 
-#define BIT(x) (1<<x)
 #define CHESTNUT_PRESERVE_MASK (BIT(MV64x60_CPU2DEV_0_WIN) | \
 				BIT(MV64x60_CPU2DEV_1_WIN) | \
 				BIT(MV64x60_CPU2DEV_2_WIN) | \
diff --git a/drivers/edac/edac_mc.h b/drivers/edac/edac_mc.h
index 713444c..1d8c495 100644
--- a/drivers/edac/edac_mc.h
+++ b/drivers/edac/edac_mc.h
@@ -79,8 +79,6 @@ extern int edac_debug_level;
 
 #endif  /* !CONFIG_EDAC_DEBUG */
 
-#define BIT(x) (1 << (x))
-
 #define PCI_VEND_DEV(vend, dev) PCI_VENDOR_ID_ ## vend, \
 	PCI_DEVICE_ID_ ## vend ## _ ## dev
 
diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 14e83d0..abed806 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -82,7 +82,8 @@ struct bits {
 	const char *set;
 	const char *unset;
 };
-#define BIT(m, s, u)	{ .mask = m, .set = s, .unset = u }
+
+#define INIT_BITS(m, s, u)	{ .mask = m, .set = s, .unset = u }
 
 static inline void
 decode_bits(const char *prefix, const struct bits *bits, int num, u32 val)
@@ -97,17 +98,17 @@ decode_bits(const char *prefix, const struct bits *bits, int num, u32 val)
 }
 
 static const struct bits isr_bits[] = {
-	BIT(ISR_RWM,	"RX",		"TX"),
-	BIT(ISR_ACKNAK,	"NAK",		"ACK"),
-	BIT(ISR_UB,	"Bsy",		"Rdy"),
-	BIT(ISR_IBB,	"BusBsy",	"BusRdy"),
-	BIT(ISR_SSD,	"SlaveStop",	NULL),
-	BIT(ISR_ALD,	"ALD",		NULL),
-	BIT(ISR_ITE,	"TxEmpty",	NULL),
-	BIT(ISR_IRF,	"RxFull",	NULL),
-	BIT(ISR_GCAD,	"GenCall",	NULL),
-	BIT(ISR_SAD,	"SlaveAddr",	NULL),
-	BIT(ISR_BED,	"BusErr",	NULL),
+	INIT_BITS(ISR_RWM,	"RX",		"TX"),
+	INIT_BITS(ISR_ACKNAK,	"NAK",		"ACK"),
+	INIT_BITS(ISR_UB,	"Bsy",		"Rdy"),
+	INIT_BITS(ISR_IBB,	"BusBsy",	"BusRdy"),
+	INIT_BITS(ISR_SSD,	"SlaveStop",	NULL),
+	INIT_BITS(ISR_ALD,	"ALD",		NULL),
+	INIT_BITS(ISR_ITE,	"TxEmpty",	NULL),
+	INIT_BITS(ISR_IRF,	"RxFull",	NULL),
+	INIT_BITS(ISR_GCAD,	"GenCall",	NULL),
+	INIT_BITS(ISR_SAD,	"SlaveAddr",	NULL),
+	INIT_BITS(ISR_BED,	"BusErr",	NULL),
 };
 
 static void decode_ISR(unsigned int val)
@@ -117,21 +118,21 @@ static void decode_ISR(unsigned int val)
 }
 
 static const struct bits icr_bits[] = {
-	BIT(ICR_START,  "START",	NULL),
-	BIT(ICR_STOP,   "STOP",		NULL),
-	BIT(ICR_ACKNAK, "ACKNAK",	NULL),
-	BIT(ICR_TB,     "TB",		NULL),
-	BIT(ICR_MA,     "MA",		NULL),
-	BIT(ICR_SCLE,   "SCLE",		"scle"),
-	BIT(ICR_IUE,    "IUE",		"iue"),
-	BIT(ICR_GCD,    "GCD",		NULL),
-	BIT(ICR_ITEIE,  "ITEIE",	NULL),
-	BIT(ICR_IRFIE,  "IRFIE",	NULL),
-	BIT(ICR_BEIE,   "BEIE",		NULL),
-	BIT(ICR_SSDIE,  "SSDIE",	NULL),
-	BIT(ICR_ALDIE,  "ALDIE",	NULL),
-	BIT(ICR_SADIE,  "SADIE",	NULL),
-	BIT(ICR_UR,     "UR",		"ur"),
+	INIT_BITS(ICR_START,  "START",	NULL),
+	INIT_BITS(ICR_STOP,   "STOP",		NULL),
+	INIT_BITS(ICR_ACKNAK, "ACKNAK",	NULL),
+	INIT_BITS(ICR_TB,     "TB",		NULL),
+	INIT_BITS(ICR_MA,     "MA",		NULL),
+	INIT_BITS(ICR_SCLE,   "SCLE",		"scle"),
+	INIT_BITS(ICR_IUE,    "IUE",		"iue"),
+	INIT_BITS(ICR_GCD,    "GCD",		NULL),
+	INIT_BITS(ICR_ITEIE,  "ITEIE",	NULL),
+	INIT_BITS(ICR_IRFIE,  "IRFIE",	NULL),
+	INIT_BITS(ICR_BEIE,   "BEIE",		NULL),
+	INIT_BITS(ICR_SSDIE,  "SSDIE",	NULL),
+	INIT_BITS(ICR_ALDIE,  "ALDIE",	NULL),
+	INIT_BITS(ICR_SADIE,  "SADIE",	NULL),
+	INIT_BITS(ICR_UR,     "UR",		"ur"),
 };
 
 static void decode_ICR(unsigned int val)
diff --git a/drivers/net/eth16i.c b/drivers/net/eth16i.c
index 93283e3..41853b5 100644
--- a/drivers/net/eth16i.c
+++ b/drivers/net/eth16i.c
@@ -170,7 +170,6 @@ static char *version =
 
 
 /* Few macros */
-#define BIT(a)		       ( (1 << (a)) )
 #define BITSET(ioaddr, bnum)   ((outb(((inb(ioaddr)) | (bnum)), ioaddr)))
 #define BITCLR(ioaddr, bnum)   ((outb(((inb(ioaddr)) & (~(bnum))), ioaddr)))
 
diff --git a/drivers/net/meth.h b/drivers/net/meth.h
index 84960da..da92943 100644
--- a/drivers/net/meth.h
+++ b/drivers/net/meth.h
@@ -28,9 +28,6 @@
 #define RX_BUFFER_OFFSET (sizeof(rx_status_vector)+2) /* staus vector + 2 bytes of padding */
 #define RX_BUCKET_SIZE 256
 
-#undef BIT
-#define BIT(x)	(1UL << (x))
-
 /* For more detailed explanations of what each field menas,
    see Nick's great comments to #defines below (or docs, if
    you are lucky enough toget hold of them :)*/
diff --git a/drivers/net/s2io.h b/drivers/net/s2io.h
index 0de0c65..5aa3be5 100644
--- a/drivers/net/s2io.h
+++ b/drivers/net/s2io.h
@@ -14,6 +14,7 @@
 #define _S2IO_H
 
 #define TBD 0
+#undef BIT
 #define BIT(loc)		(0x8000000000000000ULL >> (loc))
 #define vBIT(val, loc, sz)	(((u64)val) << (64-loc-sz))
 #define INV(d)  ((d&0xff)<<24) | (((d>>8)&0xff)<<16) | (((d>>16)&0xff)<<8)| ((d>>24)&0xff)
diff --git a/drivers/net/wireless/hostap/hostap_common.h b/drivers/net/wireless/hostap/hostap_common.h
index 0162400..429c9dd 100644
--- a/drivers/net/wireless/hostap/hostap_common.h
+++ b/drivers/net/wireless/hostap/hostap_common.h
@@ -3,8 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/if_ether.h>
-
-#define BIT(x) (1 << (x))
+#include <linux/bitops.h>
 
 #define MAC2STR(a) (a)[0], (a)[1], (a)[2], (a)[3], (a)[4], (a)[5]
 #define MACSTR "%02x:%02x:%02x:%02x:%02x:%02x"
diff --git a/drivers/scsi/nsp32.h b/drivers/scsi/nsp32.h
index a976e81..9779c5a 100644
--- a/drivers/scsi/nsp32.h
+++ b/drivers/scsi/nsp32.h
@@ -68,10 +68,6 @@ static char * nsp32_model[] = {
 typedef u32 u32_le;
 typedef u16 u16_le;
 
-/*
- * MACRO
- */
-#define BIT(x)      (1UL << (x))
 
 /*
  * BASIC Definitions
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index 9102cbd..0a3e2d1 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -26,7 +26,6 @@
 /************************************
  * Some useful macros...
  */
-#define BIT(x)      (1L << (x))
 
 /* SCSI initiator must be ID 7 */
 #define NSP_INITIATOR_ID  7
diff --git a/drivers/serial/amba-pl011.c b/drivers/serial/amba-pl011.c
index 44639e7..dfff378 100644
--- a/drivers/serial/amba-pl011.c
+++ b/drivers/serial/amba-pl011.c
@@ -53,6 +53,9 @@
 #include <asm/io.h>
 #include <asm/sizes.h>
 
+#define SETBITS(data,mask)    (data |= mask)
+#define CLRBITS(data,mask)    (data &= ~mask)
+
 #define UART_NR			14
 
 #define SERIAL_AMBA_MAJOR	204
@@ -262,15 +265,11 @@ static unsigned int pl01x_get_mctrl(struct uart_port *port)
 	unsigned int result = 0;
 	unsigned int status = readw(uap->port.membase + UART01x_FR);
 
-#define BIT(uartbit, tiocmbit)		\
-	if (status & uartbit)		\
-		result |= tiocmbit
+	result |= (status & UART01x_FR_DCD) ? TIOCM_CAR  : 0 ;
+	result |= (status & UART01x_FR_DSR) ? TIOCM_DSR  : 0 ;
+	result |= (status & UART01x_FR_CTS) ? TIOCM_CTS  : 0 ;
+	result |= (status & UART011_FR_RI)  ? TIOCM_RNG  : 0 ;
 
-	BIT(UART01x_FR_DCD, TIOCM_CAR);
-	BIT(UART01x_FR_DSR, TIOCM_DSR);
-	BIT(UART01x_FR_CTS, TIOCM_CTS);
-	BIT(UART011_FR_RI, TIOCM_RNG);
-#undef BIT
 	return result;
 }
 
@@ -281,18 +280,16 @@ static void pl011_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 	cr = readw(uap->port.membase + UART011_CR);
 
-#define	BIT(tiocmbit, uartbit)		\
-	if (mctrl & tiocmbit)		\
-		cr |= uartbit;		\
-	else				\
-		cr &= ~uartbit
-
-	BIT(TIOCM_RTS, UART011_CR_RTS);
-	BIT(TIOCM_DTR, UART011_CR_DTR);
-	BIT(TIOCM_OUT1, UART011_CR_OUT1);
-	BIT(TIOCM_OUT2, UART011_CR_OUT2);
-	BIT(TIOCM_LOOP, UART011_CR_LBE);
-#undef BIT
+       (mctrl & TIOCM_RTS)  ?
+               SETBITS(cr, UART011_CR_DTR)  : CLRBITS(cr, UART011_CR_DTR);
+       (mctrl & TIOCM_DTR)  ?
+               SETBITS(cr, UART011_CR_DTR)  : CLRBITS(cr, UART011_CR_DTR);
+       (mctrl & TIOCM_OUT1) ?
+               SETBITS(cr, UART011_CR_OUT1) : CLRBITS(cr, UART011_CR_OUT1);
+       (mctrl & TIOCM_OUT2) ?
+               SETBITS(cr, UART011_CR_OUT2) : CLRBITS(cr, UART011_CR_OUT2);
+       (mctrl & TIOCM_LOOP) ?
+               SETBITS(cr, UART011_CR_LBE)  : CLRBITS(cr, UART011_CR_LBE);
 
 	writew(cr, uap->port.membase + UART011_CR);
 }
diff --git a/drivers/video/cyber2000fb.c b/drivers/video/cyber2000fb.c
index 7a6eeda..f21b20f 100644
--- a/drivers/video/cyber2000fb.c
+++ b/drivers/video/cyber2000fb.c
@@ -550,7 +550,7 @@ cyber2000fb_decode_crtc(struct par_info *hw, struct cfb_info *cfb,
 {
 	u_int Htotal, Hblankend, Hsyncend;
 	u_int Vtotal, Vdispend, Vblankstart, Vblankend, Vsyncstart, Vsyncend;
-#define BIT(v,b1,m,b2) (((v >> b1) & m) << b2)
+#define BITMASK(v,b1,m,b2) (((v >> b1) & m) << b2)
 
 	hw->crtc[13] = hw->pitch;
 	hw->crtc[17] = 0xe3;
@@ -570,13 +570,13 @@ cyber2000fb_decode_crtc(struct par_info *hw, struct cfb_info *cfb,
 
 	Hblankend   = (Htotal - 4*8) >> 3;
 
-	hw->crtc[3] = BIT(Hblankend,  0, 0x1f,  0) |
-		      BIT(1,          0, 0x01,  7);
+	hw->crtc[3] = BITMASK(Hblankend,  0, 0x1f,  0) |
+		      BITMASK(1,          0, 0x01,  7);
 
 	Hsyncend    = (var->xres + var->right_margin + var->hsync_len) >> 3;
 
-	hw->crtc[5] = BIT(Hsyncend,   0, 0x1f,  0) |
-		      BIT(Hblankend,  5, 0x01,  7);
+	hw->crtc[5] = BITMASK(Hsyncend,   0, 0x1f,  0) |
+		      BITMASK(Hblankend,  5, 0x01,  7);
 
 	Vdispend    = var->yres - 1;
 	Vsyncstart  = var->yres + var->lower_margin;
@@ -591,20 +591,20 @@ cyber2000fb_decode_crtc(struct par_info *hw, struct cfb_info *cfb,
 	Vblankend   = Vtotal - 10;
 
 	hw->crtc[6]  = Vtotal;
-	hw->crtc[7]  = BIT(Vtotal,     8, 0x01,  0) |
-			BIT(Vdispend,   8, 0x01,  1) |
-			BIT(Vsyncstart, 8, 0x01,  2) |
-			BIT(Vblankstart,8, 0x01,  3) |
-			BIT(1,          0, 0x01,  4) |
-	        	BIT(Vtotal,     9, 0x01,  5) |
-			BIT(Vdispend,   9, 0x01,  6) |
-			BIT(Vsyncstart, 9, 0x01,  7);
-	hw->crtc[9]  = BIT(0,          0, 0x1f,  0) |
-		        BIT(Vblankstart,9, 0x01,  5) |
-			BIT(1,          0, 0x01,  6);
+	hw->crtc[7]  = BITMASK(Vtotal,     8, 0x01,  0) |
+			BITMASK(Vdispend,   8, 0x01,  1) |
+			BITMASK(Vsyncstart, 8, 0x01,  2) |
+			BITMASK(Vblankstart,8, 0x01,  3) |
+			BITMASK(1,          0, 0x01,  4) |
+	        	BITMASK(Vtotal,     9, 0x01,  5) |
+			BITMASK(Vdispend,   9, 0x01,  6) |
+			BITMASK(Vsyncstart, 9, 0x01,  7);
+	hw->crtc[9]  = BITMASK(0,          0, 0x1f,  0) |
+		        BITMASK(Vblankstart,9, 0x01,  5) |
+			BITMASK(1,          0, 0x01,  6);
 	hw->crtc[10] = Vsyncstart;
-	hw->crtc[11] = BIT(Vsyncend,   0, 0x0f,  0) |
-		       BIT(1,          0, 0x01,  7);
+	hw->crtc[11] = BITMASK(Vsyncend,   0, 0x0f,  0) |
+		       BITMASK(1,          0, 0x01,  7);
 	hw->crtc[12] = Vdispend;
 	hw->crtc[15] = Vblankstart;
 	hw->crtc[16] = Vblankend;
@@ -616,10 +616,10 @@ cyber2000fb_decode_crtc(struct par_info *hw, struct cfb_info *cfb,
 	 * 4=LINECOMP:10 5-IVIDEO 6=FIXCNT
 	 */
 	hw->crtc_ofl =
-		BIT(Vtotal,     10, 0x01,  0) |
-		BIT(Vdispend,   10, 0x01,  1) |
-		BIT(Vsyncstart, 10, 0x01,  2) |
-		BIT(Vblankstart,10, 0x01,  3) |
+		BITMASK(Vtotal,     10, 0x01,  0) |
+		BITMASK(Vdispend,   10, 0x01,  1) |
+		BITMASK(Vsyncstart, 10, 0x01,  2) |
+		BITMASK(Vblankstart,10, 0x01,  3) |
 		EXT_CRT_VRTOFL_LINECOMP10;
 
 	/* woody: set the interlaced bit... */
diff --git a/fs/select.c b/fs/select.c
index fe0893a..4bbe8ed 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -180,7 +180,6 @@ get_max:
 	return max;
 }
 
-#define BIT(i)		(1UL << ((i)&(__NFDBITS-1)))
 #define MEM(i,m)	((m)+(unsigned)(i)/__NFDBITS)
 #define ISSET(i,m)	(((i)&*(m)) != 0)
 #define SET(i,m)	(*(m) |= (i))
diff --git a/include/asm-mips/ip32/crime.h b/include/asm-mips/ip32/crime.h
index a13702f..7c36b0e 100644
--- a/include/asm-mips/ip32/crime.h
+++ b/include/asm-mips/ip32/crime.h
@@ -17,9 +17,6 @@
  */
 #define CRIME_BASE	0x14000000	/* physical */
 
-#undef BIT
-#define BIT(x)	(1UL << (x))
-
 struct sgi_crime {
 	volatile unsigned long id;
 #define CRIME_ID_MASK			0xff
diff --git a/include/asm-mips/ip32/mace.h b/include/asm-mips/ip32/mace.h
index 990082c..d08d7c6 100644
--- a/include/asm-mips/ip32/mace.h
+++ b/include/asm-mips/ip32/mace.h
@@ -17,9 +17,6 @@
  */
 #define MACE_BASE	0x1f000000	/* physical */
 
-#undef BIT
-#define BIT(x) (1UL << (x))
-
 /*
  * PCI interface
  */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 638165f..1db7815 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -8,6 +8,9 @@
  */
 #include <asm/bitops.h>
 
+#define BIT(nr)	(1UL << ((nr) % BITS_PER_LONG))
+#define LLBIT(nr) (1ULL << (nr))
+
 static __inline__ int get_bitmask_order(unsigned int count)
 {
 	int order;
diff --git a/include/linux/input.h b/include/linux/input.h
index bde65c8..5ea8f65 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -908,9 +908,9 @@ struct ff_effect {
 #include <linux/fs.h>
 #include <linux/timer.h>
 #include <linux/mod_devicetable.h>
+#include <linux/bitops.h>
 
 #define NBITS(x) (((x)/BITS_PER_LONG)+1)
-#define BIT(x)	(1UL<<((x)%BITS_PER_LONG))
 #define LONG(x) ((x)/BITS_PER_LONG)
 
 #define INPUT_KEYCODE(dev, scancode) ((dev->keycodesize == 1) ? ((u8*)dev->keycode)[scancode] : \
diff --git a/include/video/sstfb.h b/include/video/sstfb.h
index baa163f..b52f073 100644
--- a/include/video/sstfb.h
+++ b/include/video/sstfb.h
@@ -68,7 +68,6 @@
 #  define print_var(X,Y...)
 #endif
 
-#define BIT(x)		(1ul<<(x))
 #define POW2(x)		(1ul<<(x))
 
 /*
diff --git a/include/video/tdfx.h b/include/video/tdfx.h
index c1cc94b..ac6d0f1 100644
--- a/include/video/tdfx.h
+++ b/include/video/tdfx.h
@@ -77,9 +77,6 @@
 
 #define COMMAND_3D      (0x00200000 + 0x120)
 
-/* register bitfields (not all, only as needed) */
-
-#define BIT(x) (1UL << (x))
 
 /* COMMAND_2D reg. values */
 #define TDFX_ROP_COPY        0xcc     // src
-- 
Milind Arun Choudhary
