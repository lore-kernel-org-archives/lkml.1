Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYGaUIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYGaUIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYGaUIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:08:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49456 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752316AbYGaUIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:08:38 -0400
Date: Thu, 31 Jul 2008 15:08:35 -0500
From: Robin Holt <holt@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] Scale pidhash_shift/pidhash_size up based on
	num_possible_cpus().
Message-ID: <20080731200835.GK9663@sgi.com>
References: <20080731170022.GE9663@sgi.com> <m1prot297c.fsf@frodo.ebiederm.org> <20080731193204.GG9663@sgi.com> <m1iqul25rk.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1iqul25rk.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like so???

I have not tested this yet.

---

Set the upper limit for the pidhash_shift based upon PID_MAX_LIMIT.

Signed-off-by: Robin Holt <holt@sgi.com>


Index: contention_unroll/kernel/pid.c
===================================================================
--- contention_unroll.orig/kernel/pid.c	2008-07-31 11:59:21.154284073 -0500
+++ contention_unroll/kernel/pid.c	2008-07-31 15:07:21.909158788 -0500
@@ -504,7 +504,7 @@ void __init pidhash_init(void)
 	unsigned long megabytes = nr_kernel_pages >> (20 - PAGE_SHIFT);
 
 	pidhash_shift = max(4, fls(megabytes * 4));
-	pidhash_shift = min(12, pidhash_shift);
+	pidhash_shift = min(fls(PID_MAX_LIMIT) - 6, pidhash_shift);
 	pidhash_size = 1 << pidhash_shift;
 
 	printk("PID hash table entries: %d (order: %d, %Zd bytes)\n",
