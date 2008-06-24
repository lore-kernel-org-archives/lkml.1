Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbYFXBm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbYFXBm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYFXBmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:42:20 -0400
Received: from ozlabs.org ([203.10.76.45]:41914 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYFXBmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:42:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
Date: Tue, 24 Jun 2008 11:36:51 +1000
User-Agent: KMail/1.9.9
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20080622125633.GA8166@damson.getinternet.no> <200806231326.11328.rusty@rustcorp.com.au> <485FD644.80208@sgi.com>
In-Reply-To: <485FD644.80208@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241136.52430.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008 02:58:44 Mike Travis wrote:
> Rusty Russell wrote:
> > On Monday 23 June 2008 02:29:07 Vegard Nossum wrote:
> >> And the (cpu < nr_cpu_ids) fails because the CPU has just been
> >> offlined (or failed to initialize, but it's the same thing), while
> >> NR_CPUS is the value that was compiled in as CONFIG_NR_CPUS (so the
> >> former check will always be true).
> >>
> >> I don't think it is valid to ask for a per_cpu() variable on a CPU
> >> which does not exist, though
> >
> > Yes it is.  As long as cpu_possible(cpu), per_cpu(cpu) is valid.
> >
> > The number check should be removed: checking cpu_possible() is
> > sufficient.
> >
> > Hope that helps,
> > Rusty.
>
> I don't see a check for index being out of range in cpu_possible().

You're right.  It assumes cpu is < NR_CPUS.  Hmm, I have no idea what's going 
on.  nr_cpu_ids (ignore that it's a horrible name for a bad idea) should be 
fine to test against.

Vegard's analysis is flawed: just because cpu is offline, it still must be < 
nr_cpu_ids, which is based on possible cpus.  Unless something crazy is 
happening, but a quick grep doesn't reveal anyone manipulating nr_cpu_ids.

If changing this fixes the bug, something else is badly wrong...
Rusty.

