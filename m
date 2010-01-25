Return-Path: <linux-kernel-owner+w=401wt.eu-S1752300Ab0AYXon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab0AYXon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 18:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616Ab0AYXom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 18:44:42 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48364 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0AYXol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 18:44:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: cpuacct: Use bigger percpu counter batch values for stats counters
Cc: kosaki.motohiro@jp.fujitsu.com, Anton Blanchard <anton@samba.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
In-Reply-To: <20100125151404.7b7e6970.akpm@linux-foundation.org>
References: <20100118044142.GS12666@kryten> <20100125151404.7b7e6970.akpm@linux-foundation.org>
Message-Id: <20100126084135.5A9D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 26 Jan 2010 08:44:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 18 Jan 2010 15:41:42 +1100
> Anton Blanchard <anton@samba.org> wrote:
> 
> > When CONFIG_VIRT_CPU_ACCOUNTING and CONFIG_CGROUP_CPUACCT are enabled we can
> > call cpuacct_update_stats with values much larger than percpu_counter_batch.
> > This means the call to percpu_counter_add will always add to the global count
> > which is protected by a spinlock and we end up with a global spinlock in
> > the scheduler.
> 
> When one looks at the end result:

We have about 32 jiffies batch both with or without CONFIG_VIRT_CPU_ACCOUNTING.
Then, The enduser can looks some jiffies after.




