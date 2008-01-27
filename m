Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbYA0Mz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbYA0Mz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYA0Mzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:55:52 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:56374 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbYA0Mzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:55:51 -0500
Date: Sun, 27 Jan 2008 13:55:50 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: monstr@monstr.eu
cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       microblaze <microblaze@localhost.localdomain.monstr.eu>
Subject: Re: [PATCH 03/52] [microblaze] Cpuinfo handling
In-Reply-To: <62a6eb3ffa457cd0c126320a0e46509f06e00511.1201107832.git.monstr@monstr.eu>
Message-ID: <Pine.LNX.4.64.0801271352510.1185@fbirervta.pbzchgretzou.qr>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <34f2199d631406fbdf6b325a164e0d1899a3acb5.1201107832.git.monstr@monstr.eu>
 <14243bf49d44d1dbd6e377813f2635defcb82c4e.1201107832.git.monstr@monstr.eu>
 <01e493efdc1c8cb7ee0d5f8b7c73244e04680e71.1201107832.git.monstr@monstr.eu>
 <739e189a03021d2804f23d0774637a15038098bc.1201107832.git.monstr@monstr.eu>
 <d4eec3db9f6e6e86994444b8035d5e41db3f085b.1201107832.git.monstr@monstr.eu>
 <e445f6b37baf09d6469a0ad4eba189a7ca7ef7c3.1201107832.git.monstr@monstr.eu>
 <807d570db44eeed03e3211b933a207f42cf569f0.1201107832.git.monstr@monstr.eu>
 <990835fa238b139deac273e0573bcf5060e3ee80.1201107832.git.monstr@monstr.eu>
 <993cd20fd7ee4ec891f1354690f93ca62d7871ec.1201107832.git.monstr@monstr.eu>
 <e83ad9fcfb12993d8d20ce6663e563b8b496273e.1201107832.git.monstr@monstr.eu>
 <e22e05ebd297de6f7d5dd0bf2eecf20d6749d571.1201107832.git.monstr@monstr.eu>
 <62a6eb3ffa457cd0c126320a0e46509f06e00511.1201107832.git.monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24 2008 16:03, monstr@monstr.eu wrote:
>+
>+static char family_string[] = CONFIG_XILINX_MICROBLAZE0_FAMILY;
>+static char cpu_ver_string[] = CONFIG_XILINX_MICROBLAZE0_HW_VER;
>+
I have not checked - can mark these const?



>--- /dev/null
>+++ b/arch/microblaze/kernel/cpu/cpuinfo.c
>+
>+static struct cpuinfo the_cpuinfo;
>+struct cpuinfo *cpuinfo = &the_cpuinfo;

Why is this indirection needed?

>+static struct cpu_ver_key the_cpu_ver_lookup[] = {
        ^const?

>+	/* These key value are as per MBV field in PVR0 */
>+	{"5.00.a", 0x01},
>+	{"5.00.b", 0x02},
>+	{"5.00.c", 0x03},
>+	{"6.00.a", 0x04},
>+	{"6.00.b", 0x06},
>+	{"7.00.a", 0x05},
>+	/* FIXME There is no keycode defined in MBV for these versions */
>+	{"2.10.a", 0x10},
>+	{"3.00.a", 0x20},
>+	{"4.00.a", 0x30},
>+	{"4.00.b", 0x40},
>+	{NULL, 0},
>+};
>+struct cpu_ver_key *cpu_ver_lookup =
>+	(struct cpu_ver_key *) the_cpu_ver_lookup;

Again an indirection. And the case, you guessed it, is redundant
(check other code too).

>+/*
>+ * FIXME Not sure if the actual key is defined by Xilinx in the PVR
>+ */
>+static struct family_string_key the_family_string_lookup[] = {
const?

>+	{"virtex2", 0x4},
>+	{"virtex2pro", 0x5},
>+	{"spartan3", 0x6},
>+	{"virtex4", 0x7},
>+	{"virtex5", 0x8},
>+	{"spartan3e", 0x9},
>+	{"spartan3a", 0xa},
>+	{"spartan3an", 0xb},
>+	/* FIXME There is no key code defined for spartan2 */
>+	{"spartan2", 0xf0},
>+	{NULL, 0},
>+};
>+struct family_string_key *family_string_lookup =
>+	(struct family_string_key *) the_family_string_lookup;

Dito.


>+#ifndef _ASM_CPUINFO_H
>+#define _ASM_CPUINFO_H
>+
>+#include <asm/prom.h>
>+
>+extern unsigned long loops_per_jiffy;
>+
>+/* CPU Version and FPGA Family code conversion table type */
>+struct cpu_ver_key {
>+	char *s;
const char *s; if you never modify s.

>+	unsigned k;
>+};
>+
>+struct family_string_key {
>+	char *s;
Dito.

>+	unsigned k;
>+};
>+
