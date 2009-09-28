Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbZI1VRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbZI1VRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 17:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZI1VRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 17:17:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752952AbZI1VRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 17:17:33 -0400
Date: Mon, 28 Sep 2009 14:16:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: andi@firstfloor.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jbaron@redhat.com, rusty@rustcorp.com.au,
       bunk@stusta.de, hch@infradead.org
Subject: Re: [patch 02/12] Immediate Values - Architecture Independent Code
Message-Id: <20090928141600.03c64726.akpm@linux-foundation.org>
In-Reply-To: <20090928201108.GG1656@one.firstfloor.org>
References: <20090924132626.485545323@polymtl.ca>
	<20090924133359.218934235@polymtl.ca>
	<20090924212013.d27226c4.akpm@linux-foundation.org>
	<20090928012337.GC1656@one.firstfloor.org>
	<20090928104617.9c4b868a.akpm@linux-foundation.org>
	<20090928201108.GG1656@one.firstfloor.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 22:11:08 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > For example, how do we know it's safe to use immediate-values for
> > anything which can be modified from userspace, such as a sysfs-accessed
> > tunable?  How do we know this won't take someone's odd-but-legitimate
> > workload and shoot it in the head?
> 
> You're arguing we should tune for sysctl performance? That doesn't make
> sense to me.

We're talking about a tiny tiny performance gain (one which thus far
appears to be unobserveable) on the read-side traded off against a
tremendous slowdown on the write-side.

That's OK for people whose workloads use the expected read-vs-write
ratio.  But there's always someone out there who does something
peculiar.  There will be people who simply cannot accept large
slowdowns in writes to particular tunables.  Who these people are and
which tunables they care about we do not know.

No, I'm not saying we should "tune for sysctl performance".  I'm saying
we should tune for not making Linux utterly uselessly slow for people
for whom it previously worked OK.

It means we'd have to look very carefully at each tunable and decide
whether there's any conceivable situation in which someone would want
to alter it frequently.  If so, we need to leave it alone.

How many tunables will that leave behind, and how much use was it to
speed that remainder up by a teensy amount?  Who knows.

