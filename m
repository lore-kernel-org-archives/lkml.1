Return-Path: <linux-kernel-owner+w=401wt.eu-S1765744AbYAaUOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765744AbYAaUOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 15:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759110AbYAaUNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 15:13:54 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50369 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833AbYAaUNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 15:13:53 -0500
Date: Thu, 31 Jan 2008 22:14:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: x86: Why have __copy_from_user_ll_nocache* been exported?
Message-ID: <20080131201430.GA9375@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A commit that does nothing except for adding two unused EXPORT_SYMBOL's.

Without any rationale why they should be exported.

And that from a person who on the other hand wants to introduce
(and tries to force on other people) deprecation periods for unused 
EXPORT_SYMBOL's.

Can we please get this reverted quickly?

TIA
Adrian


commit 914c82694cadbab511f2aee8a59c89be2938bace
Author: Andrew Morton <akpm@osdl.org>
Date:   Wed Jan 30 23:27:57 2008 +0100

    x86: export copy_from_user_ll_nocache[_nozero]
    
    Cc: Neil Brown <neilb@cse.unsw.edu.au>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 8bab2b2..9c4ffd5 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -817,6 +817,7 @@ unsigned long __copy_from_user_ll_nocache(void *to, const void __user *from,
 #endif
 	return n;
 }
+EXPORT_SYMBOL(__copy_from_user_ll_nocache);
 
 unsigned long __copy_from_user_ll_nocache_nozero(void *to, const void __user *from,
 					unsigned long n)
@@ -831,6 +832,7 @@ unsigned long __copy_from_user_ll_nocache_nozero(void *to, const void __user *fr
 #endif
 	return n;
 }
+EXPORT_SYMBOL(__copy_from_user_ll_nocache_nozero);
 
 /**
  * copy_to_user: - Copy a block of data into user space.


