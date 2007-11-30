Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbXK3UIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbXK3UIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbXK3UHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:07:51 -0500
Received: from relay1.sgi.com ([192.48.171.29]:46144 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753207AbXK3UHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:07:50 -0500
Date: Fri, 30 Nov 2007 12:07:50 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 3/3] x86_64: Make the x86_32 percpu operations usable on
 x86_64
In-Reply-To: <20071130064400.054191278@sgi.com>
Message-ID: <Pine.LNX.4.64.0711301205190.2340@schroedinger.engr.sgi.com>
References: <20071130064305.459255715@sgi.com> <20071130064400.054191278@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following fix is needed for UP (did not have time to do proper 
testing, some people will get mad at me if I do not get into a vacation 
mode now, be back on the 13th of December):

Fix UP setup

The __per_cpu_start offset is still needed in a UP configuration. There we 
do not relocate the percpu area. So we must subtract __per_cpu_start in
setup64.c. It will be zero if the percpu area is relocated.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/setup64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.24-rc3-mm2/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/arch/x86/kernel/setup64.c	2007-11-30 11:41:23.989455039 -0800
+++ linux-2.6.24-rc3-mm2/arch/x86/kernel/setup64.c	2007-11-30 11:41:47.497905579 -0800
@@ -115,7 +115,7 @@ void __init setup_per_cpu_areas(void)
 		/* Relocate the pda */
 		memcpy(ptr, cpu_pda(i), sizeof(struct x8664_pda));
 		cpu_pda(i) = (struct x8664_pda *)ptr;
-		cpu_pda(i)->data_offset = (unsigned long)ptr;
+		cpu_pda(i)->data_offset = ptr - __per_cpu_start;
 	}
 	/* Fix up pda for this processor .... */
 	pda_init(0);
