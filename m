Return-Path: <linux-kernel-owner+w=401wt.eu-S936336AbYBCJGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936336AbYBCJGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 04:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759949AbYBCJF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 04:05:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64775 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758803AbYBCJFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 04:05:54 -0500
Message-ID: <47A583B9.3020001@cn.fujitsu.com>
Date: Sun, 03 Feb 2008 17:04:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rami Rosen <ramirose@gmail.com>
CC: David Miller <davem@davemloft.net>, kaber@trash.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [NET_SCHED] Add #ifdef CONFIG_NET_EMATCH in net/sched/cls_flow.c
 (latest git broken build)
References: <eb3ff54b0802030051x604c991fwe11184e25d0a7550@mail.gmail.com>
In-Reply-To: <eb3ff54b0802030051x604c991fwe11184e25d0a7550@mail.gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rami Rosen wrote:
> Hi,
> The 2.6 latest git build was broken when using the following
> configuration options:
> CONFIG_NET_EMATCH=n
> CONFIG_NET_CLS_FLOW=y
> 
> with the following error:
> net/sched/cls_flow.c: In function 'flow_dump':
> net/sched/cls_flow.c:598: error: 'struct tcf_ematch_tree' has no
> member named 'hdr'
> make[2]: *** [net/sched/cls_flow.o] Error 1
> make[1]: *** [net/sched] Error 2
> make: *** [net] Error 2
> 
> 
> see the recent post by Li Zefan:
>   http://www.spinics.net/lists/netdev/msg54434.html
> 
> The reason for this crash is that struct tcf_ematch_tree (net/pkt_cls.h) is
> empty when CONFIG_NET_EMATCH is not defined.
> 
> When CONFIG_NET_EMATCH is defined, the tcf_ematch_tree structure indeed holds
> a struct tcf_ematch_tree_hdr (hdr) as flow_dump() expects.
> 
> This patch adds #ifdef CONFIG_NET_EMATCH in flow_dump to avoid this.
> 
> The patch was build against latest 2.6 git net tree.
> 

The patch works. :)

