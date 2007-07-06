Return-Path: <linux-kernel-owner+w=401wt.eu-S1761697AbXGFGMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761697AbXGFGMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 02:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbXGFGMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 02:12:20 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:36796 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756677AbXGFGMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 02:12:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=s1JetL6y5hUfOeOiB2mpHj8cC5aEzSfTg3WOQAgMOIUkDenLecJWHHxpxkGJ2++j3Jo52HyUep+XIJIu3ke9vDOfLC+kqax+TfSa/AO0g8RRrNBhnulo7AG9YFy1Izt7iMv+QgKpdZS2MYmq29+6RnkXP1iVI00c2qKmRrkN488=  ;
X-YMail-OSG: _X2KTa0VM1nttiIfo6y3j.D8pTo_jao.hyqkBJSeIaLl.uXPMAkZ1_Z2K98hSP0TdSu_MMwjLg--
Message-ID: <468DDD3A.6010308@yahoo.com.au>
Date: Fri, 06 Jul 2007 16:12:10 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
References: <20070705215152.GA4865@Krystal>
In-Reply-To: <20070705215152.GA4865@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Thread Migration Preemption
> 
> This patch adds the ability to protect critical sections from migration to
> another CPU without disabling preemption.
> 
> This will be useful to minimize the amount of preemption disabling for the -rt
> patch. It will help leveraging improvements brought by the local_t types in
> asm/local.h (see Documentation/local_ops.txt). Note that the updates done to
> variables protected by migration_disable must be either atomic or protected from
> concurrent updates done by other threads.
> 
> Typical use:
> 
> migration_disable();
> local_inc(&__get_cpu_var(&my_local_t_var));
> migration_enable();
> 
> Which will increment the variable atomically wrt the local CPU.
> 
> Comments (such as how to integrate this in the already almost full
> preempt_count) are welcome.

This seems like way too much stuff to add just for this type of thing. Why
not just disable and reenable preempt? Surely local_inc is not going to take
so long that disabling preemption matters.

The task struct is not something we should just be carefree putting crap
into because it is seemingly free :(

-- 
SUSE Labs, Novell Inc.
