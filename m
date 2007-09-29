Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbXI3Lwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbXI3Lwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 07:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbXI3Lw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 07:52:27 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:35621 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753974AbXI3Lw0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 07:52:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xDlgAFHQ0TwfwapDBmaJWuVxApEglNefiIBZpd6iQIV3w9X2BiA54kOqPGxMMg7lVVyDV4OnyfyF5DPp2FnKw5PWZJZ0jraNzLXIDn/JRGaYa3qjCXEDzCQPjh39zoIYIWOK7TNR10HKp+b4IXycVVzVqoyAeybl7Kq/SAKcIM0=  ;
X-YMail-OSG: sdJS9wgVM1n..0nz5L2bRU_WErasagWSP1Ct_mlsHskkuISXNE3nOf3tbTF8puKomnd2l57h6g--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Date: Sun, 30 Sep 2007 05:21:02 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Dinakar Guniguntala <dino@in.ibm.com>,
       cpw@sgi.com, Ingo Molnar <mingo@elte.hu>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
In-Reply-To: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709300521.03356.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 September 2007 20:44, Paul Jackson wrote:
> From: Paul Jackson <pj@sgi.com>
>
> Add a new per-cpuset flag called 'sched_load_balance'.
>
> When enabled in a cpuset (the default value) it tells the kernel
> scheduler that the scheduler should provide the normal load
> balancing on the CPUs in that cpuset, sometimes moving tasks
> from one CPU to a second CPU if the second CPU is less loaded
> and if that task is allowed to run there.

I don't like adding these funny special case sort of things like this.
The user should just be able to specify exactly the partitioning of
tasks required, and cpusets should ask the scheduler to do the best
job of load balancing possible.

I implemented that with my patches to do automatic discovery
of the largest set of disjoint cpusets.

>From there, the problem that cpusets has, is that it lacks a good
way to specify that the machine should be partitioned (IIRC because
stuff defaults to going into the root cpuset which covers all CPUs?).

Instead of adding these "I want the scheduler to do something a bit
vague but hopefully good albeit with some downsides" flags, there
should be a way to say "I want to partition the CPUs like so...", IMO.

Barring that (ie. maybe you always want a root cpuset to cover all
CPUs), then maybe we should retain the spanning sched domains
in order to balance the root cpuset, and add another set of domains
according to cpuset partitioning. This could be entirely transparent
to userspace, I think (using my patch).

Just my opinion. Good to see more thought going into this area, because
it is something that sched-domains can do really well but is underused.
