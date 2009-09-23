Return-Path: <linux-kernel-owner+w=401wt.eu-S1751403AbZIWKCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbZIWKCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 06:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZIWKCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 06:02:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:59154 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750776AbZIWKCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 06:02:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18cCek8PqUc1XDTzMuVx4VvqFKisG4pYW29pCGNJb
	8ILh8T/H6xCZbY
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
In-Reply-To: <4AB9F08E.1020106@redhat.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>
	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>
	 <4AB8BA37.4010305@redhat.com> <20090922201746.GH5216@ghostprotocols.net>
	 <4AB9DCC8.5050603@redhat.com> <1253697658.11461.36.camel@marge.simson.net>
	 <4AB9F08E.1020106@redhat.com>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 12:02:39 +0200
Message-Id: <1253700159.32478.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 12:55 +0300, Avi Kivity wrote:
> On 09/23/2009 12:20 PM, Mike Galbraith wrote:
> >
> > Yup, brown baggie variety.  Oh darn.
> >
> > perf_counter tools: fix brown baggie module symbol loading bug.
> >
> > If there are no modules currently loaded, or the last module scanned is not
> > loaded, dso__load_modules() steps on the value from dso__load_vmlinux(), so
> > we happily load the kallsyms symbols on top of what we've already loaded.
> >
> > Fix that such that the total count of symbols loaded is returned.  Should
> > module symbol load fail after parsing of vmlinux, is's a hard failure, so
> > do not silently fall-back to kallsyms.
> >
> >    
> 
> Still fails, but differently.  Now 'annotate -k ... -m -v -v' doesn't 
> list vmx_vcpu_run at all, even though it's prominent in 'perf top'.
> 
> In addition to applying your patch I've merged current linus, so that 
> may have introduced the problem.
> 
> If I don't supply -k -m, I get
> 
> $ perf annotate  -v -v vmx_vcpu_run | grep vmx_vcpu
> new symbol: ffffffffa006f596 [0000dead]: vmx_vcpu_run    [kvm_intel], 
> hist: (nil), obj_start: (nil)
> new symbol: ffffffffa007025f [0000dead]: vmx_vcpu_put    [kvm_intel], 
> hist: (nil), obj_start: (nil)
> new symbol: ffffffffa0070bf6 [0000dead]: vmx_vcpu_load    [kvm_intel], 
> hist: (nil), obj_start: (nil)
> new symbol: ffffffffa0070d99 [0000dead]: vmx_vcpu_reset    [kvm_intel], 
> hist: (nil), obj_start: (nil)
> ffffffffa006f596-ffffffffa006fb73 vmx_vcpu_run    [kvm_intel]
>   ffffffffa007025f-ffffffffa007026e vmx_vcpu_put    [kvm_intel]
>   ffffffffa0070bf6-ffffffffa0070d98 vmx_vcpu_load    [kvm_intel]
>   ffffffffa0070d99-ffffffffa0071191 vmx_vcpu_reset    [kvm_intel]
>   Error: symbol 'vmx_vcpu_run' not present amongst the samples.

Yeah, I saw oddities with your config.  I'm rebuilding your config now
with more modules to do more testing.

	-Mike

