Return-Path: <linux-kernel-owner+w=401wt.eu-S1761576AbZBMXlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576AbZBMXlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 18:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZBMXlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 18:41:00 -0500
Received: from ozlabs.org ([203.10.76.45]:55073 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbZBMXk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 18:40:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: + work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch  added to -mm tree
Date: Sat, 14 Feb 2009 07:51:15 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, oleg@redhat.com,
       travis@sgi.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org
References: <200902031058.n13AwOoK016719@imap1.linux-foundation.org> <20090203112529.26e6bf76.akpm@linux-foundation.org> <m18wobcrw3.fsf@fess.ebiederm.org>
In-Reply-To: <m18wobcrw3.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902140751.15662.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 February 2009 07:08:36 Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> >
> > Series of four patches:
> >
> > - switch cstate.c frmo work_on_cpu to smp_call_function_single()
> >
> > - ditto acpi-cpufreq.c
> >
> > - ditto mce_amd_64.c
> >
> > The final work_on_cpu() caller is pci_call_probe().  I'd like to find a
> > way of removing that callsite as well, so we can finally remove this
> > turkey but for now, just fix the bugs in it:
> 
> As far as I can tell when we are doing the probes we are in a function
> that can sleep, so we should be able to just call set_cpus_allowed to
> remove the need for work_on_cpu in pci_call_probe.  Possibly with a
> save/restore of the allowed cpus.
> 
> Am I missing something?

Yes.  This is a questionable practice when it's a kernel thread (but not
really a problem), but a definite no-no on a real process.  Userspace is
allowed to change affinity on any process at any time; that's why we need
a real method to replace this meme.

(I'm also getting those cpumask's off the stack for core and x86 code, which
is why I'm hitting them all).

Thanks,
Rusty.
