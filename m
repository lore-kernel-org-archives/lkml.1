Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbZEVGPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbZEVGPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZEVGPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:15:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60497 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbZEVGPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:15:18 -0400
Date: Fri, 22 May 2009 16:15:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Neil Horman <nhorman@tuxdriver.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: linux-next: manual merge of the tracing tree with the net tree
Message-Id: <20090522161519.97c8968b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tracing tree got a conflict in
net/core/drop_monitor.c between commit
4ea7e38696c7e798c47ebbecadfd392f23f814f9 ("dropmon: add ability to detect
when hardware dropsrxpackets") from the net tree and commit
ad8d75fff811a6a230f7f43b05a6483099349533 ("tracing/events: move trace
point headers into include/trace/events") from the tracing tree.

I fixed it up (see below) and can carry the fix as necessary.  I suspect
that trace/napi.h should eventually go into trace/events as well.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/core/drop_monitor.c
index a6c2ac2,b75b6ce..0000000
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@@ -22,10 -22,8 +22,10 @@@
  #include <linux/timer.h>
  #include <linux/bitops.h>
  #include <net/genetlink.h>
 +#include <net/netevent.h>
  
- #include <trace/skb.h>
+ #include <trace/events/skb.h>
 +#include <trace/napi.h>
  
  #include <asm/unaligned.h>
  
