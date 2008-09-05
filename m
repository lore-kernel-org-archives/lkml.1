Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYIEG6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYIEG6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 02:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYIEG6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 02:58:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051AbYIEG6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 02:58:39 -0400
Date: Thu, 4 Sep 2008 23:58:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: hamid.jahanjou@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
Message-Id: <20080904235835.4406970a.akpm@linux-foundation.org>
In-Reply-To: <48C0E383.5060308@gmail.com>
References: <48BFCECE.90103@gmail.com>
	<20080904161433.5b020bd9.akpm@linux-foundation.org>
	<48C0E383.5060308@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Sep 2008 11:15:07 +0330 "Hamid R. Jahanjou" <hamid.jahanjou@gmail.com> wrote:

> Andrew Morton wrote:
> > I tried that once.  The code all worked as-designed but didn't seem to
> > improve performance much across a spread of workloads.
> >
> > Benchmarks are essential, please.  Good ones.
> Do you recommend any specific benchmarks for memory-related projects ?
> Which
> one did you use for your own implementation ?
> 

Pretty much any and all benchmarks, when there's not enough memory
(boot with mem=).  Kernel compiles, database benchmarks, you name it. 
Basically anything which has a measurable execution time is relevant.

Designing and running these things is a lot of work and thought.  And
it's an integral part of the development process, because some things
are going to get slower and others will show large inter-run variations
and then one needs to get in there and find explanations and hopefully
fixes.

For example, start with small and simple microbenchmarks: run two
processes which concurrently allocate 1*mem, then modify it all
linearly, then read it all linearly.  Build up from there.  Do not
dive into complex benchmarks on day 1, because you'll have no hope of
explaining the results which they produce.

Beware that behaviour on SMP can be very different from behaviour on
uniprocessor because of the relatively large duration of a timeslice. 
Both must be tested.
