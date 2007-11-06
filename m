Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbXKFG5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbXKFG5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 01:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbXKFG4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 01:56:53 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:34381 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbXKFG4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 01:56:52 -0500
Date: Tue, 6 Nov 2007 01:55:12 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Ralf Baechle <ralf@linux-mips.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] MIPS:  Delete now-unreferenced i2c-yosemite.h header file.
Message-ID: <Pine.LNX.4.64.0711060149350.3143@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Given that the corresponding source file i2c-yosemite.c file was
removed in commit daa4a68f901c4d6491baa1a01f5c869a553c3f6c, and that
no one else includes this file, it seems safe to delete it.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/arch/mips/pmc-sierra/yosemite/i2c-yosemite.h b/arch/mips/pmc-sierra/yosemite/i2c-yosemite.h
deleted file mode 100644
index 31c5523..0000000
--- a/arch/mips/pmc-sierra/yosemite/i2c-yosemite.h
+++ /dev/null
@@ -1,96 +0,0 @@
-/*
- *  arch/mips/pmc-sierra/yosemite/i2c-yosemite.h
- *
- *  Copyright (C) 2003 PMC-Sierra Inc.
- *  Author: Manish Lachwani (lachwani@pmc-sierra.com)
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#ifndef __I2C_YOSEMITE_H
-#define __I2C_YOSEMITE_H
-
-/* Read and Write operations to the chip */
-
-#define TITAN_I2C_BASE			0xbb000000	/* XXX Needs to change */
-
-#define	TITAN_I2C_WRITE(offset, data)	\
-					*(volatile unsigned long *)(TITAN_I2C_BASE + offset) = data
-
-#define	TITAN_I2C_READ(offset) *(volatile unsigned long *)(TITAN_I2C_BASE + offset)
-
-
-/* Local constansts*/
-#define TITAN_I2C_MAX_FILTER            15
-#define TITAN_I2C_MAX_CLK               1023
-#define TITAN_I2C_MAX_ARBF              15
-#define TITAN_I2C_MAX_NAK               15
-#define TITAN_I2C_MAX_MASTERCODE        7
-#define TITAN_I2C_MAX_WORDS_PER_RW      4
-#define TITAN_I2C_MAX_POLL		100
-
-/* Registers used for I2C work */
-#define TITAN_I2C_SCMB_CONTROL		0x0180	/* SCMB Control */
-#define TITAN_I2C_SCMB_CLOCK_A		0x0184	/* SCMB Clock A */
-#define TITAN_I2C_SCMB_CLOCK_B		0x0188	/* SCMB Clock B */
-#define	TITAN_I2C_CONFIG		0x01A0	/* I2C Config */
-#define TITAN_I2C_COMMAND		0x01A4	/* I2C Command */
-#define	TITAN_I2C_SLAVE_ADDRESS		0x01A8	/* I2C Slave Address */
-#define TITAN_I2C_DATA			0x01AC	/* I2C Data [15:0] */
-#define TITAN_I2C_INTERRUPTS		0x01BC	/* I2C Interrupts */
-
-/* Error */
-#define	TITAN_I2C_ERR_ARB_LOST		(-9220)
-#define	TITAN_I2C_ERR_NO_RESP		(-9221)
-#define	TITAN_I2C_ERR_DATA_COLLISION	(-9222)
-#define	TITAN_I2C_ERR_TIMEOUT		(-9223)
-#define	TITAN_I2C_ERR_OK		0
-
-/* I2C Command Type */
-typedef enum {
-	TITAN_I2C_CMD_WRITE = 0,
-	TITAN_I2C_CMD_READ = 1,
-	TITAN_I2C_CMD_READ_WRITE = 2
-} titan_i2c_cmd_type;
-
-/* I2C structures */
-typedef struct {
-	int filtera;		/* Register 0x0184, bits 15 - 12 */
-	int clka;		/* Register 0x0184, bits 9 - 0 */
-	int filterb;		/* Register 0x0188, bits 15 - 12 */
-	int clkb;		/* Register 0x0188, bits 9 - 0 */
-} titan_i2c_config;
-
-/* I2C command type */
-typedef struct {
-	titan_i2c_cmd_type type;	/* Type of command */
-	int num_arb;		/* Register 0x01a0, bits 15 - 12 */
-	int num_nak;		/* Register 0x01a0, bits 11 - 8 */
-	int addr_size;		/* Register 0x01a0, bit 7 */
-	int mst_code;		/* Register 0x01a0, bits 6 - 4 */
-	int arb_en;		/* Register 0x01a0, bit 1 */
-	int speed;		/* Register 0x01a0, bit 0 */
-	int slave_addr;		/* Register 0x01a8 */
-	int write_size;		/* Register 0x01a4, bits 10 - 8 */
-	unsigned int *data;	/* Register 0x01ac */
-} titan_i2c_command;
-
-#endif				/* __I2C_YOSEMITE_H */
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
