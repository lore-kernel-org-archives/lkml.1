Return-Path: <linux-kernel-owner+w=401wt.eu-S1757697AbYBEK46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbYBEK46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbYBEK4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:56:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39990
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754544AbYBEK4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:56:47 -0500
Date: Tue, 05 Feb 2008 02:57:15 -0800 (PST)
Message-Id: <20080205.025715.84832892.davem@davemloft.net>
To: ramirose@gmail.com
Cc: kaber@trash.net, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] [NET_SCHED] Add #ifdef CONFIG_NET_EMATCH in
 net/sched/cls_flow.c (latest git broken build)
From: David Miller <davem@davemloft.net>
In-Reply-To: <eb3ff54b0802030051x604c991fwe11184e25d0a7550@mail.gmail.com>
References: <eb3ff54b0802030051x604c991fwe11184e25d0a7550@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rami Rosen" <ramirose@gmail.com>
Date: Sun, 3 Feb 2008 10:51:42 +0200

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
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Applied, thanks.
