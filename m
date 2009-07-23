Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662AbZGWKGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbZGWKGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 06:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZGWKGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 06:06:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37406 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZGWKGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 06:06:37 -0400
Subject: Re: [PATCH v3 3/4] ftrace: add tracepoint for hrtimer
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A6834EA.3070303@cn.fujitsu.com>
References: <4A604E46.5050903@cn.fujitsu.com>
	 <4A605009.8060806@cn.fujitsu.com> <1247827801.15751.4.camel@twins>
	 <4A641BFC.2050508@cn.fujitsu.com> <1248091771.15751.8578.camel@twins>
	 <4A66DDB6.4000700@cn.fujitsu.com> <1248257598.27058.1227.camel@twins>
	 <4A6834EA.3070303@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Jul 2009 12:07:41 +0200
Message-Id: <1248343661.27058.1722.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 18:01 +0800, Xiao Guangrong wrote:
> 
> Peter Zijlstra wrote:
> 
> > OK, so what you want to measure is the time of the actual callback
> > happening (hrtimer_entry) vs that where you would have expected it to
> > happen (hrtimer_start + delay), right?
> > 
> 
> Yes
> 
> > So what's wrong with printing the expected expiration time in the
> > hrtimer_start tracepoint in the cheap clock units?
> > 
> 
> Is "cheap clock units" means jiffies time?

Nah, something like cpu_clock() which is monotonic per-cpu and should
have high resolution where available.
