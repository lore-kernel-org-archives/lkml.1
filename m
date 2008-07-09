Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbYGIMjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbYGIMjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYGIMje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:39:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47450 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbYGIMjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:39:33 -0400
Date: Wed, 9 Jul 2008 14:39:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>,
       Virtualization <virtualization@lists.linux-foundation.org>,
       Xen devel <xen-devel@lists.xensource.com>,
       Thomas Friebel <thomas.friebel@amd.com>, Avi Kivity <avi@qumranet.com>
Subject: [patch] x86: paravirt spinlocks, modular build fix  (was: Re:
	[PATCH RFC 0/4] Paravirtual spinlocks)
Message-ID: <20080709123905.GA16340@elte.hu>
References: <20080707190749.299430659@goop.org> <20080709122852.GA30579@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709122852.GA30579@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


another small fixlet.

	Ingo

----------------->
commit 0ea0f032767f41fb0a9586ab6acb5c1408ef16c5
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 9 14:39:15 2008 +0200

    x86: paravirt spinlocks, modular build fix
    
    fix:
    
      MODPOST 408 modules
    ERROR: "pv_lock_ops" [net/dccp/dccp.ko] undefined!
    ERROR: "pv_lock_ops" [fs/jbd2/jbd2.ko] undefined!
    ERROR: "pv_lock_ops" [drivers/media/common/saa7146_vv.ko] undefined!
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 6aa8aed..3edfd7a 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -472,6 +472,7 @@ struct pv_lock_ops pv_lock_ops = {
 	.spin_unlock = __ticket_spin_unlock,
 #endif
 };
+EXPORT_SYMBOL_GPL(pv_lock_ops);
 
 EXPORT_SYMBOL_GPL(pv_time_ops);
 EXPORT_SYMBOL    (pv_cpu_ops);
