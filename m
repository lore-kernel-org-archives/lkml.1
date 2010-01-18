Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835Ab0ARI0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0ARI0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895Ab0ARI0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:26:12 -0500
Received: from ozlabs.org ([203.10.76.45]:38421 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab0ARI0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:26:10 -0500
Date: Mon, 18 Jan 2010 19:21:51 +1100
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       akpm@linux-foundation.org, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Subject: Re: [PATCH] sched: cpuacct: Use bigger percpu counter batch values
 for stats counters
Message-ID: <20100118082151.GU12666@kryten>
References: <20090512102412.GG6351@balbir.in.ibm.com>
 <20090512102939.GB11714@elte.hu>
 <20090512193656.D647.A69D9226@jp.fujitsu.com>
 <20090716081010.GB3134@in.ibm.com>
 <20090716083948.GA2950@kryten>
 <20090820051038.GF21100@kryten>
 <20100118044142.GS12666@kryten>
 <1263801079.4283.22.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263801079.4283.22.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Peter,

> Seems like a good idea, but isn't that batch number rather static? If
> so, computing it in some init path would save that multiply on the
> actual accounting path.

It is mostly static, but percpu_counter_batch does change with hotplug
operations. Adding a hotplug notifier felt like a lot of work but I was
worried we have issues if we didn't scale with hotplug add operations.

Anton
