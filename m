Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZIWOw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZIWOw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZIWOw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:52:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:60189 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750752AbZIWOw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:52:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/svP81ZT7ssLtn3LPQDIzImzMXWgEARoGGyn+oBv
	QPpyd0wygjRFIt
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
In-Reply-To: <4ABA3321.9090503@redhat.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>
	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>
	 <4AB8BA37.4010305@redhat.com> <20090922201746.GH5216@ghostprotocols.net>
	 <4AB9DCC8.5050603@redhat.com> <1253697658.11461.36.camel@marge.simson.net>
	 <4AB9F08E.1020106@redhat.com> <1253705515.7835.41.camel@marge.simson.net>
	 <4ABA1B75.7040900@redhat.com>  <4ABA1E3B.40800@redhat.com>
	 <1253713800.7816.15.camel@marge.simson.net>  <4ABA2A0B.1010103@redhat.com>
	 <1253714972.7816.23.camel@marge.simson.net>  <4ABA3321.9090503@redhat.com>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 16:52:28 +0200
Message-Id: <1253717548.7816.34.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 17:39 +0300, Avi Kivity wrote:
> On 09/23/2009 05:09 PM, Mike Galbraith wrote:
> >
> >> Mine says:
> >>
> >>     kernel/arch/x86/kvm/kvm.ko:
> >>     kernel/arch/x86/kvm/kvm-intel.ko: kernel/arch/x86/kvm/kvm.ko
> >>
> >> Which is reasonable for /lib/modules/2.6.31, not for a source directory.
> >>      
> > Yup, there's the problem.  The code assumes that the path to modules.dep
> > and the path stored in modules.dep will agree.
> >
> > Wants some robustification.
> >    
> 
> The trace shows modules.dep was picked up from /lib/modules/2.6.31, so 
> if it continued that and picked up the modules from the same place, 
> everything would work.  Why does it try to pick up the modules from cwd?

I don't know where that cwd is coming from off the top of my head.

The symbol loading code reads the path stored in modules.dep, and chops
at ':'.

> >>      open("kernel/arch/x86/kvm/kvm-intel.ko", O_RDONLY) = -1 ENOENT (No
...
> Mine says:
> 
>    kernel/arch/x86/kvm/kvm.ko:
>    kernel/arch/x86/kvm/kvm-intel.ko: kernel/arch/x86/kvm/kvm.ko

	-Mike

