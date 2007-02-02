Return-Path: <linux-kernel-owner+w=401wt.eu-S1423168AbXBBOWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423168AbXBBOWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423157AbXBBOWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:22:19 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:4305 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423170AbXBBOWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:22:17 -0500
Date: Fri, 2 Feb 2007 15:22:16 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] Add set_fs(USER_DS) to start_thread().
Message-ID: <20070202142216.GC30839@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Add set_fs(USER_DS) to start_thread().

Currently works anyway since search_binary_handler has a
set_fs(USER_DS). But start_thread() is the place where this should be
done. Following all other architectures...

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-s390/processor.h |    3 +++
 1 files changed, 3 insertions(+)

diff -urpN linux-2.6/include/asm-s390/processor.h linux-2.6-patched/include/asm-s390/processor.h
--- linux-2.6/include/asm-s390/processor.h	2007-02-02 14:04:34.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/processor.h	2007-02-02 14:04:42.000000000 +0100
@@ -144,6 +144,7 @@ struct stack_frame {
 #ifndef __s390x__
 
 #define start_thread(regs, new_psw, new_stackp) do {            \
+	set_fs(USER_DS);					\
         regs->psw.mask  = PSW_USER_BITS;                        \
         regs->psw.addr  = new_psw | PSW_ADDR_AMODE;             \
         regs->gprs[15]  = new_stackp ;                          \
@@ -152,12 +153,14 @@ struct stack_frame {
 #else /* __s390x__ */
 
 #define start_thread(regs, new_psw, new_stackp) do {            \
+	set_fs(USER_DS);					\
         regs->psw.mask  = PSW_USER_BITS;                        \
         regs->psw.addr  = new_psw;                              \
         regs->gprs[15]  = new_stackp;                           \
 } while (0)
 
 #define start_thread31(regs, new_psw, new_stackp) do {          \
+	set_fs(USER_DS);					\
 	regs->psw.mask  = PSW_USER32_BITS;			\
         regs->psw.addr  = new_psw;                              \
         regs->gprs[15]  = new_stackp;                           \
