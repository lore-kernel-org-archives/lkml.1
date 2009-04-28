Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbZD1JwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbZD1JwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbZD1Jv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:51:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51140 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758134AbZD1Jv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:51:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/4] FRV: Don't turn on TIF_SYSCALL_TRACE unconditionally in
	syscall prologue
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, hch@lst.de, roland@redhat.com,
       linux-kernel@vger.kernel.org
Date: Tue, 28 Apr 2009 10:49:41 +0100
Message-ID: <20090428094941.11879.59831.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090428094931.11879.99536.stgit@warthog.procyon.org.uk>
References: <20090428094931.11879.99536.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't turn on TIF_SYSCALL_TRACE unconditionally in syscall prologue in FRV's
entry.S.  This was originally for debugging stuff and should have been removed
a long time ago.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/entry.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index 1da523b..268dfbd 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -886,7 +886,6 @@ system_call:
 	bnc		icc0,#0,__syscall_badsys
 
 	ldi		@(gr15,#TI_FLAGS),gr4
-	ori		gr4,#_TIF_SYSCALL_TRACE,gr4
 	andicc		gr4,#_TIF_SYSCALL_TRACE,gr0,icc0
 	bne		icc0,#0,__syscall_trace_entry
 

