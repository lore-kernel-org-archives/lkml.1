Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbXIDVMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbXIDVMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 17:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbXIDVMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 17:12:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754764AbXIDVMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 17:12:06 -0400
Date: Tue, 4 Sep 2007 14:10:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: clameter@sgi.com, steiner@sgi.com, ak@suse.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kamalesh@linux.vnet.ibm.com
Subject: Re: [PATCH 3/6] x86: Convert cpu_sibling_map to be a per cpu
 variable (v2) (fwd)
Message-Id: <20070904141055.e00a60d7.akpm@linux-foundation.org>
In-Reply-To: <46DDC017.4040301@sgi.com>
References: <Pine.LNX.4.64.0708312028400.24049@schroedinger.engr.sgi.com>
	<46DDC017.4040301@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 04 Sep 2007 13:29:11 -0700 Mike Travis <travis@sgi.com> wrote:
> [Sorry, I did not see this message until Christoph forwarded it to me.  I'm
> guessing we (SGI) still have a problem with our external spam filter?]
> 
> > 
> > ---------- Forwarded message ----------
> > Date: Fri, 31 Aug 2007 19:49:03 -0700
> > From: Andrew Morton <akpm@linux-foundation.org>
> > To: travis@sgi.com
> > Cc: Andi Kleen <ak@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
> >     Christoph Lameter <clameter@sgi.com>
> > Subject: Re: [PATCH 3/6] x86: Convert cpu_sibling_map to be a per cpu variable
> >     (v2)
> > 
> > On Fri, 24 Aug 2007 15:26:57 -0700 travis@sgi.com wrote:
> > 
> >> Convert cpu_sibling_map from a static array sized by NR_CPUS to a
> >> per_cpu variable.  This saves sizeof(cpumask_t) * NR unused cpus.
> >> Access is mostly from startup and CPU HOTPLUG functions.
> > 
> > ia64 allmodconfig:
> > 
> > kernel/sched.c: In function `cpu_to_phys_group':                                                                             kernel/sched.c:5937: error: `per_cpu__cpu_sibling_map' undeclared (first use in this function)                               kernel/sched.c:5937: error: (Each undeclared identifier is reported only once
> > kernel/sched.c:5937: error: for each function it appears in.)                                                                kernel/sched.c:5937: warning: type defaults to `int' in declaration of `type name'
> > kernel/sched.c:5937: error: invalid type argument of `unary *'                                                               kernel/sched.c: In function `build_sched_domains':                                                                           kernel/sched.c:6172: error: `per_cpu__cpu_sibling_map' undeclared (first use in this function)                               kernel/sched.c:6172: warning: type defaults to `int' in declaration of `type name'                                           kernel/sched.c:6172: error: invalid type argument of `unary *'                                                               kernel/sched.c:6183: warning: type defaults to `int' in declaration of `type name'                                           kernel/sched.c:6183: error: invalid type argument of `unary *'                                                               
> 
> I'm thinking that the best approach would be to define a cpu_sibling_map() macro
> to handle the cases where cpu_sibling_map is not a per_cpu variable?  Perhaps
> something like:
> 
> #ifdef CONFIG_SCHED_SMT
> #ifndef cpu_sibling_map
> #define cpu_sibling_map(cpu)    cpu_sibling_map[cpu]
> #endif
> #endif
> 
> My question though, would include/linux/smp.h be the appropriate place for
> the above define?  (That is, if the above approach is the correct one... ;-)

It'd be better to convert the unconverted architectures?
