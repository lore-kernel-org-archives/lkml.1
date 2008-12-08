Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbYLHGIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbYLHGIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 01:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYLHGIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 01:08:14 -0500
Received: from ozlabs.org ([203.10.76.45]:57349 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbYLHGIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 01:08:13 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 1/2] kvm: use modern cpumask primitives, no cpumask_t on stack
Date: Mon, 8 Dec 2008 16:38:07 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: "kvm-devel" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <200812072125.14416.rusty@rustcorp.com.au> <493BF144.9080106@redhat.com> <493BF648.6060504@redhat.com>
In-Reply-To: <493BF648.6060504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812081638.07526.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2008 02:44:00 Avi Kivity wrote:
> Avi Kivity wrote:
> > Rusty Russell wrote:
> >> We're getting rid on on-stack cpumasks for large NR_CPUS.
> >>
> >> 1) Use cpumask_var_t and alloc_cpumask_var (a noop normally).  Fallback
> >>    code is inefficient but never happens in practice.
> >
> > Wow, code duplication from Rusty. Things must be bad.
> >
> > Since we're in a get_cpu() here, how about a per_cpu static cpumask 
> > instead? I don't mind the inefficient fallback, just the duplication.
> >
> 
> Btw, for the general case, instead of forcing everyone to duplicate, how 
> about:
> 
> cpumask_var_t cpus;
> 
> with_cpumask(cpus) {
>    ... code to populate cpus
>    smp_call_function_some(...);
> } end_with_cpumask(cpus);
> 
> Where with_cpumask() allocates cpus, and uses a mutex + static fallback 
> on failure.

I'd prefer not to hide deadlocks that way :(

I'll re-battle with that code to neaten it.  There are only a few places
which have these kind of issues.

Thanks,
Rusty.
