Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbYIZMCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbYIZMCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYIZMCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:02:31 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:14625 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbYIZMCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:02:31 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 0/7] traps: x86: irqtrace cleanup and some traps.c unification
Date: Fri, 26 Sep 2008 14:03:01 +0200
Message-Id: <1222430588-29072-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Fri, 26 Sep 2008 14:02:15 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.215; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aparantly the conversion of exceptions from traps to interrupts
and the changes to the irq-tracer on i386 have not given any
trouble, yet? (tip/x86/traps)

This is a small set of patches removing trace_hardirqs_fixup
completely from the code. TRACE_IRQS_OFF is added to the assembly
code instead, where needed.

7/7 is a small unification step between traps_32.c and traps_64.c

Patches were generated against tip/x86/traps.

Greetings,
    Alexander

arch/x86/kernel/entry_64.S |    6 ++++-
arch/x86/kernel/traps_32.c |   55 ++++++++++++-------------------------------
arch/x86/kernel/traps_64.c |   11 ++------
arch/x86/mm/fault.c        |    5 ----
include/asm-x86/irqflags.h |   21 ----------------
5 files changed, 24 insertions(+), 74 deletions(-)
      
