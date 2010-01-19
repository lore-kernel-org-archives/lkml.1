Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591Ab0ASIqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab0ASIqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543Ab0ASIqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:46:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:46354 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab0ASIqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:46:51 -0500
Subject: Re: [PATCH 1/3 v2] perf_event: fix race in
 perf_swevent_get_recursion_context()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B556F66.3070402@cn.fujitsu.com>
References: <4B54654A.4090601@cn.fujitsu.com>
	 <4B5465D8.9070203@cn.fujitsu.com> <4B54662B.4050109@cn.fujitsu.com>
	 <4B556F66.3070402@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 09:46:33 +0100
Message-ID: <1263890793.4283.639.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 16:37 +0800, Xiao Guangrong wrote:
> It only disable preemption in perf_swevent_get_recursion_context(),
> it can't avoid race of hard-irq and NMI since they are nested that
> will re-enter this path and make the recursion value chaotic
> 
> In this patch, we use atomic operation to avoid it and reduce
> cpu_ctx->recursion size, it also make this patch no need disable
> preemption

NAK

