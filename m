Return-Path: <linux-kernel-owner+w=401wt.eu-S1751177AbZHJSyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177AbZHJSyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZHJSyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:54:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39226 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZHJSyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:54:53 -0400
Date: Mon, 10 Aug 2009 21:53:02 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH 1/2] export cpu_tlbstate to modules
Message-ID: <20090810185302.GB13924@redhat.com>
References: <cover.1249930169.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1249930169.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vhost net module wants to do copy to/from user from a kernel thread,
which needs switch_mm (like what fs/aio has).
export cpu_tlbstate to make this possible

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/mm/tlb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 821e970..e33a5f0 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -13,6 +13,7 @@
 
 DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
 			= { &init_mm, 0, };
+EXPORT_PER_CPU_SYMBOL_GPL(cpu_tlbstate);
 
 /*
  *	Smarter SMP flushing macros.
-- 
1.6.2.5

