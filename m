Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZKWLun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZKWLun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756968AbZKWLum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:50:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:34932 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbZKWLum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:50:42 -0500
Subject: Re: newidle balancing in NUMA domain?
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091123114339.GB2287@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de>
	 <1258976175.4531.299.camel@laptop>  <20091123114339.GB2287@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 12:50:45 +0100
Message-ID: <1258977045.4531.317.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 12:43 +0100, Nick Piggin wrote:
> On Mon, Nov 23, 2009 at 12:36:15PM +0100, Peter Zijlstra wrote:

> > IIRC this was kbuild and other spreading workloads that want this.
> > 
> > the newidle_idx=0 thing is because I frequently saw it make funny
> > balance decisions based on old load numbers, like f_b_g() selecting a
> > group that didn't even have tasks in anymore.
> 
> Well it is just a damping factor on runqueue flucturations. If the
> group recently had load then the point of the idx is to account
> for this. On the other hand, if we have other groups that are also
> above the idx damped average, it would make sense to use them
> instead. (ie. cull source groups with no pullable tasks).

Right, thing is, I'm still catching up from being gone, and haven't
actually read and tought through the whole rate-limiting thing :-(

If you see a better way to accomplish things, please holler.

> > We went without newidle for a while, but then people started complaining
> > about that kbuild time, and there is a x264 encoder thing that looses
> > tons of throughput.
> 
> So... these were due to what? Other changes in domains balancing?
> Changes in CFS? Something else? Or were they comparisons versus
> other operating systems?

Comparison to Con's latest single-rq spread like there's no cache
affinity BFS thing.


