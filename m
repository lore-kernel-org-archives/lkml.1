Return-Path: <linux-kernel-owner+w=401wt.eu-S1761409AbZD3Iwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409AbZD3Iwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZD3IwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:52:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43763 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZD3IwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:52:19 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v2] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime count
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <1241081240.4756.38.camel@laptop>
References: <20090430061806.GC4430@balbir.in.ibm.com> <1241081240.4756.38.camel@laptop>
Message-Id: <20090430175112.D225.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 30 Apr 2009 17:52:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
> > > -		s64 val = percpu_counter_read(&ca->cpustat[i]);
> > > +		s64 val = percpu_counter_sum(&ca->cpustat[i]);
> > >  		val = cputime64_to_clock_t(val);
> > >  		cb->fill(cb, cpuacct_stat_desc[i], val);
> > >  	}
> > 
> > What do the test results look like with this? I'll see if I can find
> > some time to test this patch. On a patch read level this seems much better
> > to me, Peter?
> 
> I don't really fancy percpu_counter_sum() usage. I'm thinking its ok to
> degrate accuracy on larger machines and simply use
> percpu_counter_read().

I have same opinion with peter. Balbir, What do you think?



