Return-Path: <linux-kernel-owner+w=401wt.eu-S1765411AbXJRTjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765411AbXJRTjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbXJRTjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:39:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:50096 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbXJRTi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:38:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:from;
        b=QniVGNXevsYyK2pFozWDo8kGJ1IVh1MmYOF7x1k59920DsIVLZsQrUo7w6sjWxokOIOyJkA4HpDpZNu8tkD9WyqRSXtVPiQuxrX7kedQF2AwW7MvsumyALUjG3BHjpaHRwtxJgSznkf047yIQ6bi/U4sQFLzTlpZUJ5jri17yLY=
Date: Thu, 18 Oct 2007 21:39:04 -0700
To: Paul Mundt <lethal@linux-sh.org>
Cc: linuxsh <linuxsh-dev@lists.sourceforge.net>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: [PATCH / HP6XX] : Add Timer values into HD64461.h
Message-Id: <20071018213904.c0be3b03.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__18_Oct_2007_21_39_04_-0700_x8_W_hW=tABB17qD"
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Thu__18_Oct_2007_21_39_04_-0700_x8_W_hW=tABB17qD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Greetings,

Shortlog:
This patch adds HD64461 Timer adresses & registers to the HD64461 header file (/include/asm-sh/hd64461.h).
The timers (TMU0 & TMU1) can hold 16bit values and auto loads the counter constant when it
reaches zero. Upon reaching zero it generates an interrupt.

Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

diff --git a/include/asm-sh/hd64461.h b/include/asm-sh/hd64461.h
index 342ca55..52fcb7e 100644
--- a/include/asm-sh/hd64461.h
+++ b/include/asm-sh/hd64461.h
@@ -225,9 +225,34 @@
 #define	HD64461_NIRR		(CONFIG_HD64461_IOBASE + 0x5000)
 #define	HD64461_NIMR		(CONFIG_HD64461_IOBASE + 0x5002)
 
-#define	HD64461_IRQBASE		OFFCHIP_IRQ_BASE
-#define	OFFCHIP_IRQ_BASE	64
-#define	HD64461_IRQ_NUM		16
+/* Timer control adresses */
+#define	HD64461_TMU_TCVR1	(CONFIG_HD64461_IOBASE + 0x6000)	/* Timer 1 Constant value register */
+#define	HD64461_TMU_TCVR0	(CONFIG_HD64461_IOBASE + 0x6002)	/* Timer 0 Constant value register */
+#define	HD64461_TMU_TRVR1	(CONFIG_HD64461_IOBASE + 0x6004)	/* Timer 1 Read value register */
+#define	HD64461_TMU_TRVR0	(CONFIG_HD64461_IOBASE + 0x6006)	/* Timer 0 Read value register */
+#define	HD64461_TMU_TCR1	(CONFIG_HD64461_IOBASE + 0x6008)	/* Timer 1 Control register */
+#define	HD64461_TMU_TCR0	(CONFIG_HD64461_IOBASE + 0x600a)	/* Timer 0 Control register */
+#define	HD64461_TMU_TIRR	(CONFIG_HD64461_IOBASE + 0x600c)	/* Timer interrupt request register */
+#define	HD64461_TMU_TER		(CONFIG_HD64461_IOBASE + 0x600e)	/* Timer interrupt enable register */
+
+/* Timer Control Register */
+#define	HD64461_TMU_TCR_ENA	0x08	/* Enable timer output TM0x */
+#define	HD64461_TMU_TCR_SCL1	0x06	/* CKIO */	/* remember that CKIO / 16 = inverted 0x06 */
+#define	HD64461_TMU_TCR_SCL4	0x04	/* CKIO / 4 */
+#define	HD64461_TMU_TCR_SCL8	0x02	/* CKIO / 8 */
+#define	HD64461_TMU_TCR_STRT	0x01	/* start counting TM0x */
+
+/* Timer Interrupt Request Register */
+#define	HD64461_TMU_TIRR_TMU1	0x02	/* Interrupt request from Timer 1 */
+#define	HD64461_TMU_TIRR_TMU0	0x01	/* Interrupt request from Timer 0 */
+
+/* Timer Interrupt Enable Register */
+#define	HD64461_TMU_TIMR_TMU1	0x02	/* Interrupt request from Timer 1 is masked */
+#define	HD64461_TMU_TIMR_TMU0	0x01	/* Interrupt request from Timer 0 is masked */
+
+#define	HD64461_IRQBASE		OFFCHIP_IRQ_BASE	/* After here we can set HD64461 interrupts */
+#define	OFFCHIP_IRQ_BASE	64			/* SuperH 7709 Interrupts */
+#define	HD64461_IRQ_NUM		16			/* Number of HD64461 Interrupts */
 
 #define	HD64461_IRQ_UART	(HD64461_IRQBASE+5)
 #define	HD64461_IRQ_IRDA	(HD64461_IRQBASE+6)

--Multipart=_Thu__18_Oct_2007_21_39_04_-0700_x8_W_hW=tABB17qD
Content-Type: application/octet-stream;
 name="hp6xx-hd64461.h-tmu-values.patch"
Content-Disposition: attachment;
 filename="hp6xx-hd64461.h-tmu-values.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvYXNtLXNoL2hkNjQ0NjEuaCBiL2luY2x1ZGUvYXNtLXNoL2hk
NjQ0NjEuaAppbmRleCAzNDJjYTU1Li41MmZjYjdlIDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS1z
aC9oZDY0NDYxLmgKKysrIGIvaW5jbHVkZS9hc20tc2gvaGQ2NDQ2MS5oCkBAIC0yMjUsOSArMjI1
LDM0IEBACiAjZGVmaW5lCUhENjQ0NjFfTklSUgkJKENPTkZJR19IRDY0NDYxX0lPQkFTRSArIDB4
NTAwMCkKICNkZWZpbmUJSEQ2NDQ2MV9OSU1SCQkoQ09ORklHX0hENjQ0NjFfSU9CQVNFICsgMHg1
MDAyKQogCi0jZGVmaW5lCUhENjQ0NjFfSVJRQkFTRQkJT0ZGQ0hJUF9JUlFfQkFTRQotI2RlZmlu
ZQlPRkZDSElQX0lSUV9CQVNFCTY0Ci0jZGVmaW5lCUhENjQ0NjFfSVJRX05VTQkJMTYKKy8qIFRp
bWVyIGNvbnRyb2wgYWRyZXNzZXMgKi8KKyNkZWZpbmUJSEQ2NDQ2MV9UTVVfVENWUjEJKENPTkZJ
R19IRDY0NDYxX0lPQkFTRSArIDB4NjAwMCkJLyogVGltZXIgMSBDb25zdGFudCB2YWx1ZSByZWdp
c3RlciAqLworI2RlZmluZQlIRDY0NDYxX1RNVV9UQ1ZSMAkoQ09ORklHX0hENjQ0NjFfSU9CQVNF
ICsgMHg2MDAyKQkvKiBUaW1lciAwIENvbnN0YW50IHZhbHVlIHJlZ2lzdGVyICovCisjZGVmaW5l
CUhENjQ0NjFfVE1VX1RSVlIxCShDT05GSUdfSEQ2NDQ2MV9JT0JBU0UgKyAweDYwMDQpCS8qIFRp
bWVyIDEgUmVhZCB2YWx1ZSByZWdpc3RlciAqLworI2RlZmluZQlIRDY0NDYxX1RNVV9UUlZSMAko
Q09ORklHX0hENjQ0NjFfSU9CQVNFICsgMHg2MDA2KQkvKiBUaW1lciAwIFJlYWQgdmFsdWUgcmVn
aXN0ZXIgKi8KKyNkZWZpbmUJSEQ2NDQ2MV9UTVVfVENSMQkoQ09ORklHX0hENjQ0NjFfSU9CQVNF
ICsgMHg2MDA4KQkvKiBUaW1lciAxIENvbnRyb2wgcmVnaXN0ZXIgKi8KKyNkZWZpbmUJSEQ2NDQ2
MV9UTVVfVENSMAkoQ09ORklHX0hENjQ0NjFfSU9CQVNFICsgMHg2MDBhKQkvKiBUaW1lciAwIENv
bnRyb2wgcmVnaXN0ZXIgKi8KKyNkZWZpbmUJSEQ2NDQ2MV9UTVVfVElSUgkoQ09ORklHX0hENjQ0
NjFfSU9CQVNFICsgMHg2MDBjKQkvKiBUaW1lciBpbnRlcnJ1cHQgcmVxdWVzdCByZWdpc3RlciAq
LworI2RlZmluZQlIRDY0NDYxX1RNVV9URVIJCShDT05GSUdfSEQ2NDQ2MV9JT0JBU0UgKyAweDYw
MGUpCS8qIFRpbWVyIGludGVycnVwdCBlbmFibGUgcmVnaXN0ZXIgKi8KKworLyogVGltZXIgQ29u
dHJvbCBSZWdpc3RlciAqLworI2RlZmluZQlIRDY0NDYxX1RNVV9UQ1JfRU5BCTB4MDgJLyogRW5h
YmxlIHRpbWVyIG91dHB1dCBUTTB4ICovCisjZGVmaW5lCUhENjQ0NjFfVE1VX1RDUl9TQ0wxCTB4
MDYJLyogQ0tJTyAqLwkvKiByZW1lbWJlciB0aGF0IENLSU8gLyAxNiA9IGludmVydGVkIDB4MDYg
Ki8KKyNkZWZpbmUJSEQ2NDQ2MV9UTVVfVENSX1NDTDQJMHgwNAkvKiBDS0lPIC8gNCAqLworI2Rl
ZmluZQlIRDY0NDYxX1RNVV9UQ1JfU0NMOAkweDAyCS8qIENLSU8gLyA4ICovCisjZGVmaW5lCUhE
NjQ0NjFfVE1VX1RDUl9TVFJUCTB4MDEJLyogc3RhcnQgY291bnRpbmcgVE0weCAqLworCisvKiBU
aW1lciBJbnRlcnJ1cHQgUmVxdWVzdCBSZWdpc3RlciAqLworI2RlZmluZQlIRDY0NDYxX1RNVV9U
SVJSX1RNVTEJMHgwMgkvKiBJbnRlcnJ1cHQgcmVxdWVzdCBmcm9tIFRpbWVyIDEgKi8KKyNkZWZp
bmUJSEQ2NDQ2MV9UTVVfVElSUl9UTVUwCTB4MDEJLyogSW50ZXJydXB0IHJlcXVlc3QgZnJvbSBU
aW1lciAwICovCisKKy8qIFRpbWVyIEludGVycnVwdCBFbmFibGUgUmVnaXN0ZXIgKi8KKyNkZWZp
bmUJSEQ2NDQ2MV9UTVVfVElNUl9UTVUxCTB4MDIJLyogSW50ZXJydXB0IHJlcXVlc3QgZnJvbSBU
aW1lciAxIGlzIG1hc2tlZCAqLworI2RlZmluZQlIRDY0NDYxX1RNVV9USU1SX1RNVTAJMHgwMQkv
KiBJbnRlcnJ1cHQgcmVxdWVzdCBmcm9tIFRpbWVyIDAgaXMgbWFza2VkICovCisKKyNkZWZpbmUJ
SEQ2NDQ2MV9JUlFCQVNFCQlPRkZDSElQX0lSUV9CQVNFCS8qIEFmdGVyIGhlcmUgd2UgY2FuIHNl
dCBIRDY0NDYxIGludGVycnVwdHMgKi8KKyNkZWZpbmUJT0ZGQ0hJUF9JUlFfQkFTRQk2NAkJCS8q
IFN1cGVySCA3NzA5IEludGVycnVwdHMgKi8KKyNkZWZpbmUJSEQ2NDQ2MV9JUlFfTlVNCQkxNgkJ
CS8qIE51bWJlciBvZiBIRDY0NDYxIEludGVycnVwdHMgKi8KIAogI2RlZmluZQlIRDY0NDYxX0lS
UV9VQVJUCShIRDY0NDYxX0lSUUJBU0UrNSkKICNkZWZpbmUJSEQ2NDQ2MV9JUlFfSVJEQQkoSEQ2
NDQ2MV9JUlFCQVNFKzYpCg==

--Multipart=_Thu__18_Oct_2007_21_39_04_-0700_x8_W_hW=tABB17qD--
