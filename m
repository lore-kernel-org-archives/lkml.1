Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZEKQcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZEKQcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZEKQcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:32:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42666 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbZEKQcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:32:11 -0400
Date: Mon, 11 May 2009 18:37:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
Cc: "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Lee.Schermerhorn@hp.com, linux-numa@vger.kernel.org,
       brice.goglin@inria.fr,
       "'Terboven, Christian'" <terboven@rz.rwth-aachen.de>,
       anmey@rz.rwth-aachen.de, "'Boris Bierbaum'" <boris@lfbs.rwth-aachen.de>
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
Message-ID: <20090511163719.GA19296@one.firstfloor.org>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de> <87zldjn597.fsf@basil.nowhere.org> <001501c9d248$69e2a870$3da7f950$@rwth-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001501c9d248$69e2a870$3da7f950$@rwth-aachen.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 04:54:40PM +0200, Stefan Lankes wrote:
> > From: Andi Kleen [mailto:andi@firstfloor.org]
> > 
> > Stefan Lankes <lankes@lfbs.rwth-aachen.de> writes:
> > >
> > > [Patch 1/4]: Extend the system call madvise with a new parameter
> > > MADV_ACCESS_LWP (the same as used in Solaris). The specified memory
> > area
> > 
> > Linux does NUMA memory policies in mbind(), not madvise()
> > Also if there's a new NUMA policy it should be in the standard
> > Linux NUMA memory policy frame work, not inventing a new one
> 
> By default, mbind only has an effect on new allocations. I think that this

Nope, it affects existing pages too, it can even move pages
if you ask for it.

> is different from what we need for applications with dynamic memory access
> patterns. The app gives the kernel a hint that the access pattern has been
> changed and the kernel has to redistribute the pages which are already
> allocated.

MF_MOVE


> For instance, Norden's PDE solvers using adaptive mesh refinements (AMR) [1]
> is an application with a dynamic access pattern. We use this example to
> evaluate the performance of our patch. We ran this solver on our
> quad-socket, dual-core Opteron 875 (2.2GHz) system running CentOS 5.2. The
> code was already optimized for NUMA architectures. Before the arrays are
> initialized, the threads are bound to one core. In our test case, the solver
> needs 5318s. If we use our kernel extension, the solver needs 4489s. 

Okay that sounds like good numbers. 

> Currently, we are testing some other apps.

Please keep the list updated.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
