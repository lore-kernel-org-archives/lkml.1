Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbXFYUrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbXFYUrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbXFYUrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:47:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39782 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXFYUrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:47:15 -0400
Date: Mon, 25 Jun 2007 13:48:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, ak@suse.de
Subject: [PATCH] mtrr/cyrix: fix sections
Message-Id: <20070625134851.78873cc0.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Are there peculiarities about Cyrix that mean this isn't needed?

main.c::mtrr_add() or mtrr_del() [exported]
calls main.c::mtrr_add_page() or mtrr_del_page() or mtrr_restore() [resume]
calls main.c::set_mtrr()
calls main.c::ipi_handler()
calls main.c::mtrr_if->set_all() == which can be cyrix_set_all

WARNING: arch/i386/kernel/built-in.o(.text+0x8657): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')
WARNING: arch/i386/kernel/built-in.o(.text+0x866b): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')
WARNING: arch/i386/kernel/built-in.o(.text+0x867e): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')
WARNING: arch/i386/kernel/built-in.o(.text+0x8684): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')
WARNING: arch/i386/kernel/built-in.o(.text+0x868a): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/i386/kernel/cpu/mtrr/cyrix.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.22-rc6.orig/arch/i386/kernel/cpu/mtrr/cyrix.c
+++ linux-2.6.22-rc6/arch/i386/kernel/cpu/mtrr/cyrix.c
@@ -233,12 +233,12 @@ typedef struct {
 	mtrr_type type;
 } arr_state_t;
 
-static arr_state_t arr_state[8] __devinitdata = {
+static arr_state_t arr_state[8] = {
 	{0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL},
 	{0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}
 };
 
-static unsigned char ccr_state[7] __devinitdata = { 0, 0, 0, 0, 0, 0, 0 };
+static unsigned char ccr_state[7] = { 0, 0, 0, 0, 0, 0, 0 };
 
 static void cyrix_set_all(void)
 {
