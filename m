Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbZFHJSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbZFHJSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 05:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZFHJSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 05:18:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52121 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbZFHJSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 05:18:34 -0400
Message-ID: <4A2CD77F.7080609@cn.fujitsu.com>
Date: Mon, 08 Jun 2009 17:18:55 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: davem@davemloft.net
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, mingo@elte.hu,
       Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] ftrace: change the export format of trace_kfree_skb()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %pf instead of %p to output the function's address, use 0x%04X instead
of %u to output the skb's protocol

Before patch:

          <idle>-0     [000] 60144.542521: kfree_skb: skbaddr=de7b8240 protocol=2048 location=c1365429
          <idle>-0     [000] 60164.488153: kfree_skb: skbaddr=da66f900 protocol=2048 location=c1365429
          <idle>-0     [000] 60193.493933: kfree_skb: skbaddr=deaeb480 protocol=4 location=c134ec25
          <idle>-0     [000] 60253.118421: kfree_skb: skbaddr=de7c4900 protocol=4 location=c134ec25
          
After patch:

            bash-2587  [001] 97685.781173: kfree_skb: skbaddr=deb9cc00 protocol=0x0000 location=netlink_unicast
            bash-2587  [000] 97686.501121: kfree_skb: skbaddr=df9bb840 protocol=0x0000 location=netlink_unicast
          <idle>-0     [000] 97696.200184: kfree_skb: skbaddr=df741240 protocol=0x0800 location=ip_rcv
          <idle>-0     [000] 97696.200198: kfree_skb: skbaddr=dfb3de40 protocol=0x0800 location=ip_rcv

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/skb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
 mode change 100644 => 100755 include/trace/events/skb.h

diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
old mode 100644
new mode 100755
index 1e8fabb..a58bef8
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -30,7 +30,7 @@ TRACE_EVENT(kfree_skb,
 		__entry->location = location;
 	),
 
-	TP_printk("skbaddr=%p protocol=%u location=%p",
+	TP_printk("skbaddr=%p protocol=0x%04X location=%pf",
 		__entry->skbaddr, __entry->protocol, __entry->location)
 );
 
-- 
1.6.1.2

