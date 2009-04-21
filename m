Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZDUXju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZDUXju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 19:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZDUXjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 19:39:41 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:62013 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZDUXjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 19:39:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ICbtqk4P8Y3XWQlcVPdSQYXJsu8LeqYbYuQOyRo3ZCmWwms6Q4QGKnbT3nwX7YbAyT
         +9u2Pir8iJMECsIW1lmbRN5GysuWH7cxu3Epel8SuCH850nMkBGK8E7x4m6rlNsblAQi
         edeTDA4rEpdAif52pASPaehm15wouZEPtP+6Q=
Date: Wed, 22 Apr 2009 01:39:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Re: [PATCH 4/4] trace_workqueue: Add worklet information
Message-ID: <20090421233935.GC6744@nowhere>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49EC1943.8080606@cn.fujitsu.com> <49EC1F99.9030208@cn.fujitsu.com> <20090420113601.GC6081@nowhere> <49ED27EE.8080600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ED27EE.8080600@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 09:57:02AM +0800, Zhaolei wrote:
> Hello, Frederic
> 
> Thanks for your review and advice.
> 
> > 
> > The above test will take the total number of cpus as
> > the last cpu number. This assumption may be false
> > if the possible cpus are not contiguous.
> > 
> > Perhaps you'd better use:
> > 
> > 
> > for_each_possible_cpu(cpu) {
> > 	ret = workqueue_stat_start_cpu(cpu);
> > 	if (ret)
> > 		break;
> > }
> IMHO, this code is to choose first cpu who have workqueue.
> But we need to choose next cpu, may be we need to:
> 
> int nextcpu;
> for_each_possible_cpu(nextcpu) {
> 	/* bypass prev cpus */
> 	if (nextcpu <= cpu)
> 		continue;
> 
> 	ret = workqueue_stat_start_cpu(cpu);
> 	if (ret) {
> 		break;
> 	}
> }
> 
> By looking cpumask.h, for_each_possible_cpu(nextcpu) always make nextcpu
> increase, but if not(in future?), above code is wrong.
> 
> Thanks
> Zhaolei
> 


Ok.

BTW, I've applied your patches in
git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/workqueue

Once I have some time, I will also address Oleg's comments.

