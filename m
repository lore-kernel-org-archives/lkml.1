Return-Path: <linux-kernel-owner+w=401wt.eu-S1761042AbZJIQCC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761042AbZJIQCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:02:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758723AbZJIQCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:02:02 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54916 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758267AbZJIQCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:02:00 -0400
Date: Fri, 9 Oct 2009 18:01:23 +0200
From: Andreas Mohr <andi@lisas.de>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Andreas Mohr <andi@lisas.de>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.32-rc3: floating-point build failure (undefined reference
	to `__udivdi3' in menu governor)
Message-ID: <20091009160123.GA14808@rhlx01.hs-esslingen.de>
References: <20091007104125.GA1449@rhlx01.hs-esslingen.de> <4ACCA44B.3070706@linux.intel.com> <20091007173457.GA25415@rhlx01.hs-esslingen.de> <20091007174553.GC11702@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007174553.GC11702@bombadil.infradead.org>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 07, 2009 at 01:45:54PM -0400, Kyle McMartin wrote:
> On Wed, Oct 07, 2009 at 07:34:58PM +0200, Andreas Mohr wrote:
> > Still happening.
> > IOW it must be somewhere inside the DIV_ROUND_CLOSEST macro or so.
> > 
> 
> It's being a jerk and not realizing that RESOLUTION * DECAY is a power
> of 2, so it can just do a shift...
> 
> I don't recall if gcc 3 had these magic builtins, but if it does,
> something like this might help since it's the u64 case that's
> problematic.

Uh... nope:

In file included from kernel/sched.c:1818:
kernel/sched_fair.c: In function `select_task_rq_fair':
kernel/sched_fair.c:1366: implicit declaration of function `__builtin_popcountll'
kernel/sched_fair.c:1366: implicit declaration of function `__builtin_ffsll'
kernel/sched_fair.c:1366: warning: suggest parentheses around + or - inside shift
kernel/sched.c: In function `update_sg_lb_stats':
kernel/sched.c:3755: warning: suggest parentheses around + or - inside shift
kernel/sched.c: In function `find_busiest_queue':
kernel/sched.c:4050: warning: suggest parentheses around + or - inside shift
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2


Hmpf. Rather stuck now, ain'tcha, given that gcc 3.2.3 doesn't even have those?

Thanks,

Andreas Mohr
