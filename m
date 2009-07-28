Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbZG1HYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbZG1HYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZG1HYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:24:05 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:34864 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbZG1HYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:24:04 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
 breakpoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <20090728001844.GA5147@nowhere>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
	 <1248109687-7808-6-git-send-email-fweisbec@gmail.com>
	 <1248354493.26273.2.camel@twins>
	 <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com>
	 <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere>
	 <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere>
	 <1248538972.5780.25.camel@laptop>  <20090728001844.GA5147@nowhere>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 09:26:40 +0200
Message-Id: <1248766000.6987.2759.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 02:18 +0200, Frederic Weisbecker wrote:
> 
> I still don't understand why it is needed to reserve breakpoints for
> a group of monitored tasks. Once they have registered their breakpoints,
> the number of necessary hardware registers for these will be available
> every time the task is scheduled.

Its possible to create >4 breakpoint counters. We time-share them.

The only constraint we have is that those within a group should be on
the 'PMU' at the same time.

If you have no groups, a single available breakpoint slot should suffice
for any configuration (although more is better), but if you get groups
you have to guarantee your created group can run.

