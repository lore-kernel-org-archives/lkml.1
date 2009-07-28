Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZG1HWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZG1HWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZG1HWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:22:09 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:31548 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZG1HWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:22:08 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
 breakpoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: prasad@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <20090728010349.GB5147@nowhere>
References: <1248109687-7808-6-git-send-email-fweisbec@gmail.com>
	 <1248354493.26273.2.camel@twins>
	 <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com>
	 <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere>
	 <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere>
	 <1248538972.5780.25.camel@laptop> <20090725235702.GA5082@in.ibm.com>
	 <1248684817.6987.1573.camel@twins>  <20090728010349.GB5147@nowhere>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 09:24:37 +0200
Message-Id: <1248765877.6987.2754.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 03:03 +0200, Frederic Weisbecker wrote:
> > Thirdly, we can multiplex perf counters beyond their hardware maximum,
> > something you simply cannot do for a debug interface.
> 
> 
> Again, I'm stuck in what you mean by multiplexing here :-)

If you'd create say 16 breakpoint counters, we'd RR them over the 4
available hardware breakpoints (or less when others are taken by someone
else).

Since its all statistics anyway, we can simply scale the event counts up
by the time-share they received.

