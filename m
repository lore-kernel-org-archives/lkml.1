Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYBAPxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYBAPxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYBAPxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:53:36 -0500
Received: from stinky.trash.net ([213.144.137.162]:51246 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbYBAPxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:53:35 -0500
Message-ID: <47A3407C.8080408@trash.net>
Date: Fri, 01 Feb 2008 16:53:32 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [build bug] net/sched/cls_flow.c:598: error: 'struct	tcf_ematch_tree'
 has no member named 'hdr'
References: <20080201133614.GA14110@elte.hu>
In-Reply-To: <20080201133614.GA14110@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------090208070202020106070901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090208070202020106070901
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> another build bug found via x86.git randconfig testing:
>
>  net/sched/cls_flow.c: In function 'flow_dump':
>  net/sched/cls_flow.c:598: error: 'struct tcf_ematch_tree' has no member named 'hdr'
>
> config attached. Introduced in last night's networking merge i guess.
>   

Oops, thanks Ingo. Attached patch should fix it.



--------------090208070202020106070901
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 28383868d7999539f35ae06666c2dfbde103a1d3
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Feb 1 16:50:44 2008 +0100

    [NET_SCHED]: cls_flow: fix build error with CONFIG_NET_EMATCH=n
    
    Reported by Ingo Molnar:
    
     net/sched/cls_flow.c: In function 'flow_dump':
     net/sched/cls_flow.c:598: error: 'struct tcf_ematch_tree' has no member named 'hdr'
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index 5a7f6a3..f30be74 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -595,10 +595,11 @@ static int flow_dump(struct tcf_proto *tp, unsigned long fh,
 	if (tcf_exts_dump(skb, &f->exts, &flow_ext_map) < 0)
 		goto nla_put_failure;
 
+#ifdef CONFIG_NET_EMATCH
 	if (f->ematches.hdr.nmatches &&
 	    tcf_em_tree_dump(skb, &f->ematches, TCA_FLOW_EMATCHES) < 0)
 		goto nla_put_failure;
-
+#endif
 	nla_nest_end(skb, nest);
 
 	if (tcf_exts_dump_stats(skb, &f->exts, &flow_ext_map) < 0)

--------------090208070202020106070901--
