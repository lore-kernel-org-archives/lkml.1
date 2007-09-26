Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbXIZGhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbXIZGhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 02:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbXIZGhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 02:37:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbXIZGhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 02:37:01 -0400
Date: Wed, 26 Sep 2007 02:36:54 -0400
From: Chris Snook <csnook@redhat.com>
To: akpm@linux-foundation.org
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] x86_64: make atomic64_t work like atomic_t
Message-ID: <20070926063654.GA11773@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of the greater controversy about the semantics of atomic_t, I think
we can all agree that atomic_t and atomic64_t should have the same semantics.
This is presently not the case on x86_64, where the volatile keyword was
removed from the declaration of atomic_t, but it was not removed from the
declaration of atomic64_t.  The following patch fixes that inconsistency,
without delving into anything more controversial.

From: Chris Snook <csnook@redhat.com>

The volatile keyword has already been removed from the declaration of atomic_t
on x86_64.  For consistency, remove it from atomic64_t as well.

Signed-off-by: Chris Snook <csnook@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>

--- a/include/asm-x86_64/atomic.h	2007-07-08 19:32:17.000000000 -0400
+++ b/include/asm-x86_64/atomic.h	2007-09-13 11:30:51.000000000 -0400
@@ -206,7 +206,7 @@ static __inline__ int atomic_sub_return(
 
 /* An 64bit atomic type */
 
-typedef struct { volatile long counter; } atomic64_t;
+typedef struct { long counter; } atomic64_t;
 
 #define ATOMIC64_INIT(i)	{ (i) }
 
