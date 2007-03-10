Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbXCJBK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbXCJBK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767693AbXCJBK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:10:56 -0500
Received: from holomorphy.com ([66.93.40.71]:39427 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbXCJBKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:10:54 -0500
Date: Fri, 9 Mar 2007 17:10:57 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Ryan Hope <rmh3093@gmail.com>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: Pluggable Schedulers (was: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler)
Message-ID: <20070310011057.GG2986@holomorphy.com>
References: <200703091625.55361.a1426z@gawab.com> <20070309135751.GE2986@holomorphy.com> <200703092343.46276.a1426z@gawab.com> <48f7fe350703091418p133a955ar8bef47db33a42e3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f7fe350703091418p133a955ar8bef47db33a42e3f@mail.gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 05:18:31PM -0500, Ryan Hope wrote:
> from what I understood, there is a performance loss in plugsched
> schedulers because they have to share code....
> even if pluggable schedulers is not a viable option, being able to
> choose which one was built into the kernel would be easy (only takes a
> few ifdefs), i too think competition would be good

Neither sharing code nor data structures is strictly necessary for a
pluggable scheduler. For instance, backing out per-cpu runqueues in
favor of a single locklessly-accessed queue or similar per-leaf-domain
queues is one potential design alternative (never mind difficulties
with ->cpus_allowed) explicitly considered for the sake of sched_yield()
semantics on SMP, among other concerns. What plugsched originally did
was to provide a set of driver functions and allow each scheduler to
play with its private data declared static in separate C files in what
were later intended to become kernel modules. As far as I know, runtime
switchover code to complement all that has never been written in such a
form. One possibility abandoned early-on was to have multiple schedulers
simultaneously active to manage different portions of the system with
different policies, in no small part due to the difficulty of load
balancing between the partitions associated with the different schedulers.
Some misguided attempts were made to export the lowest-level API possible,
which I rather quickly deemed a mistake, but they still held to such
largely design considerations as I described above.


-- wli
