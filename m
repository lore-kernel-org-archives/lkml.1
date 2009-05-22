Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbZEVGPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbZEVGPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZEVGPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:15:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60489 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbZEVGPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:15:14 -0400
Date: Fri, 22 May 2009 16:15:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Neil Horman <nhorman@tuxdriver.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: linux-next: manual merge of the tracing tree with the net tree
Message-Id: <20090522161513.762a2c4b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tracing tree got a conflict in
net/core/net-traces.c between commit
4ea7e38696c7e798c47ebbecadfd392f23f814f9 ("dropmon: add ability to detect
when hardware dropsrxpackets") from the net tree and commit
a8d154b009168337494fbf345671bab74d3e4b8b ("tracing: create automated
trace defines") from the tracing tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/core/net-traces.c
index b07b25b,499a67e..0000000
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@@ -25,9 -23,7 +23,10 @@@
  #include <asm/unaligned.h>
  #include <asm/bitops.h>
  
+ #define CREATE_TRACE_POINTS
+ #include <trace/events/skb.h>
++#include <trace/napi.h>
  
- DEFINE_TRACE(kfree_skb);
  EXPORT_TRACEPOINT_SYMBOL_GPL(kfree_skb);
 +
- DEFINE_TRACE(napi_poll);
 +EXPORT_TRACEPOINT_SYMBOL_GPL(napi_poll);
