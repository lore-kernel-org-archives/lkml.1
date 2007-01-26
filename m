Return-Path: <linux-kernel-owner+w=401wt.eu-S1030713AbXAZCyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030713AbXAZCyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 21:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030714AbXAZCyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 21:54:46 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:40663 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030713AbXAZCyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 21:54:45 -0500
Date: Thu, 25 Jan 2007 21:54:41 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Douglas Niehaus <niehaus@eecs.ku.edu>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 02/09] atomic.h : Complete atomic_long operations in asm-generic
Message-ID: <20070126025441.GA13004@Krystal>
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca> <1169741754354-git-send-email-mathieu.desnoyers@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1169741754354-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 21:52:32 up 155 days, 23:59,  4 users,  load average: 0.31, 0.37, 0.40
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As Joe Perches pointed out, 4 casts to (long) are unneeded here.

The *_test functions only return integers, never a long.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -70,28 +70,28 @@ static inline int atomic_long_sub_and_test(long i, atomic_long_t *l)
 {
 	atomic64_t *v = (atomic64_t *)l;
 	
-	return (long)atomic64_sub_and_test(i, v);
+	return atomic64_sub_and_test(i, v);
 }
 
 static inline int atomic_long_dec_and_test(atomic_long_t *l)
 {
 	atomic64_t *v = (atomic64_t *)l;
 	
-	return (long)atomic64_dec_and_test(v);
+	return atomic64_dec_and_test(v);
 }
 
 static inline int atomic_long_inc_and_test(atomic_long_t *l)
 {
 	atomic64_t *v = (atomic64_t *)l;
 	
-	return (long)atomic64_inc_and_test(v);
+	return atomic64_inc_and_test(v);
 }
 
 static inline int atomic_long_add_negative(long i, atomic_long_t *l)
 {
 	atomic64_t *v = (atomic64_t *)l;
 	
-	return (long)atomic64_add_negative(i, v);
+	return atomic64_add_negative(i, v);
 }
 
 static inline long atomic_long_add_return(long i, atomic_long_t *l)
-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
