Return-Path: <linux-kernel-owner+w=401wt.eu-S1762498AbZAQPTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762498AbZAQPTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 10:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbZAQPTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 10:19:43 -0500
Received: from aun.it.uu.se ([130.238.12.36]:62292 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162AbZAQPTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 10:19:42 -0500
Date: Sat, 17 Jan 2009 16:19:35 +0100 (MET)
Message-Id: <200901171519.n0HFJZuf028704@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: mingo@elte.hu
Subject: "eliminate warn_on_slowpath()" change causes many gcc-3.2.3 warnings
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ec5679e513305f1411753e5f5489935bd638af23 "eliminate warn_on_slowpath()"
changed __WARN() to call warn_slowpath() with a NULL value for the format
string parameter. Now every WARN_ON() triggers a warning from gcc-3.2.3:

In file included from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_32.c:7,
                 from arch/x86/kernel/asm-offsets.c:2:
include/linux/gfp.h: In function `allocflags_to_migratetype':
include/linux/gfp.h:104: warning: null format string

Compiling kernel 2.6.29-rc2 with a minimalistic .config for my 486
generates 1767 'null format string' warnings.

warn_slowpath() is declared with attribute((format(printf, 3, 4))),
and gcc-3.2.3 warns if the format string parameter is NULL. gcc-3.3
and newer do not warn in that case.

Since gcc-3.2 is still a supported compiler for the kernel, this is
a regression.

(Just FYI. I don't consider this serious enough to warrant reverting
that cleanup patch or declaring gcc-3.2.3 too old. I can always update
my 486 to gcc-3.3.6 if the warnings start to bug me too much.)

/Mikael
