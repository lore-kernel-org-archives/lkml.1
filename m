Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYKKBsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYKKBsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 20:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYKKBsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 20:48:42 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55106 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbYKKBsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 20:48:42 -0500
Date: Tue, 11 Nov 2008 10:48:39 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] cpuset: update top cpuset's mems after adding a node
Cc: Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0811101222470.1219@chino.kir.corp.google.com>
References: <491828DE.9010505@cn.fujitsu.com> <alpine.DEB.2.00.0811101222470.1219@chino.kir.corp.google.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20081111104419.D5BF.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 10 Nov 2008, Miao Xie wrote:
> 
> > on 2008-11-10 14:56 Yasunori Goto wrote:
> > > Did you test this patch?  Was it OK?
> > 
> > I did it on IA64 just now. Updating top cpuset's mems is fine.
> > But I forgot to update the mems_allowed of every task in top cpuset group.
> > It is difficult to fix it, because I don't know whether updating a memory-bound
> > task's mem_allowed is good or not.
> > 
> 
> There's a fix pending in the mmotm tree that calls 
> cpuset_update_task_memory_state() in the slow path of the page allocator, 
> so if one of these tasks fails to allocate memory, its cached mems_allowed 
> nodemask will be updated to include the new node(s).
> 
> The patch is available at 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/cpusets-update-mems-allowed-in-page-allocator.patch

Ah, OK. This seems reasonable.

Then Miao-san's patch is fine.
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>


Thanks.
-- 
Yasunori Goto 


