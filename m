Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbYDNKVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYDNKVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYDNKVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:21:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbYDNKVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:21:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Correctly determine the address of an illegal instruction
To: torvalds@osdl.org, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Mon, 14 Apr 2008 11:20:59 +0100
Message-ID: <20080414102059.1131.55353.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Correctly determine the address of an illegal instruction.  The EPCR0 register
holds this value (masked by EPCR0_PC) if the validity bit is set (masked by
EPCR0_V).  So the test as to whether the contents of the register are usable
should be involve checking the _V bit, not the _PC bits.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/frv/kernel/traps.c b/arch/frv/kernel/traps.c
index 2f7e668..7089c24 100644
--- a/arch/frv/kernel/traps.c
+++ b/arch/frv/kernel/traps.c
@@ -73,7 +73,7 @@ asmlinkage void illegal_instruction(unsigned long esfr1, unsigned long epcr0, un
 		      epcr0, esr0, esfr1);
 
 	info.si_errno	= 0;
-	info.si_addr	= (void *) ((epcr0 & EPCR0_PC) ? (epcr0 & EPCR0_PC) : __frame->pc);
+	info.si_addr	= (void *) ((epcr0 & EPCR0_V) ? (epcr0 & EPCR0_PC) : __frame->pc);
 
 	switch (__frame->tbr & TBR_TT) {
 	case TBR_TT_ILLEGAL_INSTR:

