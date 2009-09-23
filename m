Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbZIWMAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbZIWMAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZIWMAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:00:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:59150 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752103AbZIWMAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:00:19 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+5H8USeFu5X2pQ1aAGAy1H5r/13ko0spHk9Gp8Ef
	Ass/mAGug02I1Q
Subject: Re: [patch] Re: [perf] Finding uninstalled modules Was Re: mailing
 list for trace users
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, rostedt@goodmis.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <1253705515.7835.41.camel@marge.simson.net>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>
	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>
	 <4AB8BA37.4010305@redhat.com> <20090922201746.GH5216@ghostprotocols.net>
	 <4AB9DCC8.5050603@redhat.com> <1253697658.11461.36.camel@marge.simson.net>
	 <4AB9F08E.1020106@redhat.com>  <1253705515.7835.41.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 14:00:18 +0200
Message-Id: <1253707218.9080.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 13:32 +0200, Mike Galbraith wrote:
> On Wed, 2009-09-23 at 12:55 +0300, Avi Kivity wrote:
> > On 09/23/2009 12:20 PM, Mike Galbraith wrote:
> > >
> > > Yup, brown baggie variety.  Oh darn.
> > >
> > > perf_counter tools: fix brown baggie module symbol loading bug.
> > >
> > > If there are no modules currently loaded, or the last module scanned is not
> > > loaded, dso__load_modules() steps on the value from dso__load_vmlinux(), so
> > > we happily load the kallsyms symbols on top of what we've already loaded.
> > >
> > > Fix that such that the total count of symbols loaded is returned.  Should
> > > module symbol load fail after parsing of vmlinux, is's a hard failure, so
> > > do not silently fall-back to kallsyms.
> > >
> > >    
> > 
> > Still fails, but differently.  Now 'annotate -k ... -m -v -v' doesn't 
> > list vmx_vcpu_run at all, even though it's prominent in 'perf top'.
> 
> Hm.  I just did a record, then report with and without -k -m, and now
> get identical reports with your config (plus some more modules) here.

With your config, I can't even get my e1000 flood pinging friztbox to
show up in perf top without a 70 line monitor.   Mondo overhead.

------------------------------------------------------------------------------
   PerfTop:    3860 irqs/sec  kernel:94.0% [10000Hz instructions],  (all, cpu: 0)
------------------------------------------------------------------------------

             samples    pcnt   kernel function
             _______   _____   _______________

             1702.00 -  5.5% : _spin_lock_irqsave
             1659.00 -  5.3% : add_preempt_count
             1516.00 -  4.9% : sub_preempt_count
             1330.00 -  4.3% : _spin_unlock_irqrestore
             1132.00 -  3.6% : debug_smp_processor_id
              844.00 -  2.7% : find_busiest_group
              639.00 -  2.1% : schedule
              629.00 -  2.0% : get_parent_ip
              586.00 -  1.9% : test_ti_thread_flag
.....

              310.00 -  0.3% : sys_recvmsg
              303.00 -  0.3% : e1000_clean_rx_irq       [e1000e]
              302.00 -  0.3% : raw_sendmsg
              300.00 -  0.3% : e1000_xmit_frame [e1000e]



