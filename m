Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbZJDSaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbZJDSaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 14:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757653AbZJDSaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 14:30:24 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:35503 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbZJDSaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 14:30:21 -0400
Date: Sun, 4 Oct 2009 20:30:13 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH] xen: Disable stack protector for irq helper
Message-ID: <20091004183013.GA26101@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Stable Kernel <stable@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Xen-devel <xen-devel@lists.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stack protector needs additional registers on x86_32, which are not
saved in calls to the small paravirt interrupt handlers. This leads to
early crashes as registers are overwritten and not saved by the caller
as instructed.

Signed-off-by: Bastian Blank <waldi@debian.org>

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3bb4fc2..ac19398 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -5,9 +5,9 @@
 CFLAGS_REMOVE_irq.o = -pg
 endif
 
-# Make sure early boot has no stackprotector
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_enlighten.o		:= $(nostackp)
+CFLAGS_irq.o			:= $(nostackp)
 CFLAGS_mmu.o			:= $(nostackp)
 
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
-- 
Mind your own business, Spock.  I'm sick of your halfbreed interference.
