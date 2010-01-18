Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619Ab0ARIfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0ARIfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441Ab0ARIfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:35:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56323 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab0ARIfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:35:10 -0500
Subject: Re: [PATCH] sched: cpuacct: Use bigger percpu counter batch values
 for stats counters
From: Peter Zijlstra <peterz@infradead.org>
To: Anton Blanchard <anton@samba.org>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       akpm@linux-foundation.org, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
In-Reply-To: <20100118082151.GU12666@kryten>
References: <20090512102412.GG6351@balbir.in.ibm.com>
	 <20090512102939.GB11714@elte.hu>
	 <20090512193656.D647.A69D9226@jp.fujitsu.com>
	 <20090716081010.GB3134@in.ibm.com> <20090716083948.GA2950@kryten>
	 <20090820051038.GF21100@kryten> <20100118044142.GS12666@kryten>
	 <1263801079.4283.22.camel@laptop>  <20100118082151.GU12666@kryten>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 09:34:41 +0100
Message-ID: <1263803681.4283.63.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 19:21 +1100, Anton Blanchard wrote:
> Hi Peter,
> 
> > Seems like a good idea, but isn't that batch number rather static? If
> > so, computing it in some init path would save that multiply on the
> > actual accounting path.
> 
> It is mostly static, but percpu_counter_batch does change with hotplug
> operations. Adding a hotplug notifier felt like a lot of work but I was
> worried we have issues if we didn't scale with hotplug add operations.

OK, trading a notifier for a mult might be worth it, we'll see if
someone complains ;-)

Lets got with this for now.

