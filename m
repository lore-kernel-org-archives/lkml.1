Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbYGHXQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbYGHXQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYGHXOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:41 -0400
Received: from gw.goop.org ([64.81.55.164]:51205 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbYGHXOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 06 of 55] x86_64: adjust exception frame in ia32entry
X-Mercurial-Node: 7153d3e56c9561e6f49fd35aebf4196dafc3384b
Message-Id: <7153d3e56c9561e6f49f.1215554788@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32-bit compat int $0x80 entrypoint needs exception frame
adjustment.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/ia32/ia32entry.S |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -319,6 +319,7 @@
 	/*CFI_REL_OFFSET	rflags,EFLAGS-RIP*/
 	/*CFI_REL_OFFSET	cs,CS-RIP*/
 	CFI_REL_OFFSET	rip,RIP-RIP
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	SWAPGS
 	/*
 	 * No need to follow this irqs on/off section: the syscall


