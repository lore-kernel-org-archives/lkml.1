Return-Path: <linux-kernel-owner+w=401wt.eu-S1760416AbXGEPq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbXGEPq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 11:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758255AbXGEPqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 11:46:48 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:32996 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757293AbXGEPqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 11:46:47 -0400
Date: Thu, 5 Jul 2007 11:46:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070705154644.GA22597@Krystal>
References: <8CTJM-4Z1-27@gated-at.bofh.it> <8CU38-5E1-23@gated-at.bofh.it> <8DjNU-4bL-47@gated-at.bofh.it> <8DkTC-5Vy-11@gated-at.bofh.it> <E1I6TAl-0002iC-W7@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <E1I6TAl-0002iC-W7@be1.lrz>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:30:32 up 4 days, 10:13,  3 users,  load average: 0.69, 0.31, 0.32
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Bodo Eggert (7eggert@gmx.de) wrote:
> Andi Kleen <andi@firstfloor.org> wrote:
> > Alexey Dobriyan <adobriyan@gmail.com> writes:
> >> On Tue, Jul 03, 2007 at 12:40:56PM -0400, Mathieu Desnoyers wrote:
> 
> >> > Use immediate values with lower d-cache hit in optimized version as a
> >> > condition for scheduler profiling call.
> >> 
> >> I think it's better to put profile.c under CONFIG_PROFILING as
> >> _expected_, so CONFIG_PROFILING=n users won't get any overhead, immediate or
> >> not. That's what I'm going to do after test-booting bunch of kernels.
> > 
> > No, it's better to handle this efficiently at runtime e.g. for
> > distribution kernels. Mathieu's patch is good
> 
> IMO you should combine them. For distibutions, it may be good to include
> profiling support unconditionally, but how many of the vanilla kernel users
> are going to use profiling at all?

For CONFIG_PROFILING, I think of it more like a chicken and egg problem:
as long as it won't be easy to enable when needed in distributions
kernels, few profiling applications will use it. So if you ban it from
distros kernel with a CONFIG option under the pretext that no profiling
application use it, you run straight into a conceptual deadlock. :)

Another simliar example would be CONFIG_TIMER_STATS, used by powertop,
which users will use to tune their laptops (I got 45 minutes more
battery time on mine thanks to this wonderful tool). Compiling-in, but
dynamically turning it on/off makes sense for a lot of kernel
"profiling/stats extraction" mechanisms like those.

But I suspect they will be used by distros only when their presence when
disabled will be unnoticeable or when a major portion of their users
will yell loudly enough telling that they want this and this features,
leaving the more specialized minority of distro users without these
features that they need to fine-tune their applications or their kernel.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
