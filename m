Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbXKAAvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbXKAAvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbXKAAv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:51:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57106
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754845AbXKAAvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:51:25 -0400
Date: Wed, 31 Oct 2007 17:51:24 -0700 (PDT)
Message-Id: <20071031.175124.84905325.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0710311730280.25414@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0710311724490.25361@schroedinger.engr.sgi.com>
	<20071031.172741.192929676.davem@davemloft.net>
	<Pine.LNX.4.64.0710311730280.25414@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Wed, 31 Oct 2007 17:31:12 -0700 (PDT)

> Others may have the same issue.
> 
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/christoph/slab.git allocpercpu
> 
> should get you the whole thing.

This patch fixes build failures with DEBUG_VM disabled.

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 4b167c0..d414703 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -36,7 +36,7 @@
 #ifdef CONFIG_DEBUG_VM
 #define __percpu_disguise(pdata) ((void *)~(unsigned long)(pdata))
 #else
-#define __percpu_disguide(pdata) ((void *)(pdata))
+#define __percpu_disguise(pdata) ((void *)(pdata))
 #endif
 
 /* 
