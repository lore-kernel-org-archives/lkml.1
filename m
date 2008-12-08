Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYLHGFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYLHGFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 01:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYLHGFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 01:05:40 -0500
Received: from ozlabs.org ([203.10.76.45]:52928 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbYLHGFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 01:05:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 2/2] kvm: use cpumask_var_t for cpus_hardware_enabled
Date: Mon, 8 Dec 2008 16:35:34 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: "kvm-devel" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <200812072125.45757.rusty@rustcorp.com.au> <493BF206.4070007@redhat.com>
In-Reply-To: <493BF206.4070007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812081635.35166.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2008 02:25:50 Avi Kivity wrote:
> Rusty Russell wrote:
> > This changes cpus_hardware_enabled from a cpumask_t to a cpumask_var_t:
> > equivalent for CONFIG_CPUMASKS_OFFSTACK=n, otherwise dynamically allocated.
> >
> >  
> > -static cpumask_t cpus_hardware_enabled;
> > +static cpumask_var_t cpus_hardware_enabled
> 
> This isn't on stack, so it isn't buying us anything.

It's the CONFIG_NR_CPUS=4096 but nr_cpu_ids=4 case which we win using
dynamic allocation.  Gotta love distribution kernels.

> Is the plan to drop cpumask_t?

Yes.  And undefine 'struct cpumask' if CONFIG_CPUMASK_OFFSTACK.  That
will stop assignment and on-stack declarations for all but the most
determined.

> If so, we're penalizing non-stack users 
> by forcing them to go through another pointer (and cacheline).

Not quite.  If !CONFIG_CPUMASK_OFFSTACK, cpumask_var_t == cpumask_t[1].
Blame Linus :)

Cheers,
Rusty.
