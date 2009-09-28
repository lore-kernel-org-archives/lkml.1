Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZI1WBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZI1WBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 18:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbZI1WBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 18:01:13 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:51562 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753419AbZI1WBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 18:01:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFAKfIwEpMROOX/2dsb2JhbACBUdVrhB4F
Date: Mon, 28 Sep 2009 18:01:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jbaron@redhat.com, rusty@rustcorp.com.au,
       bunk@stusta.de, hch@infradead.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 02/12] Immediate Values - Architecture Independent Code
Message-ID: <20090928220114.GB27947@Krystal>
References: <20090924132626.485545323@polymtl.ca> <20090924133359.218934235@polymtl.ca> <20090924212013.d27226c4.akpm@linux-foundation.org> <20090928012337.GC1656@one.firstfloor.org> <20090928104617.9c4b868a.akpm@linux-foundation.org> <20090928201108.GG1656@one.firstfloor.org> <20090928141600.03c64726.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090928141600.03c64726.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:58:22 up 41 days,  8:47,  4 users,  load average: 0.35, 0.24,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Mon, 28 Sep 2009 22:11:08 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > For example, how do we know it's safe to use immediate-values for
> > > anything which can be modified from userspace, such as a sysfs-accessed
> > > tunable?  How do we know this won't take someone's odd-but-legitimate
> > > workload and shoot it in the head?
> > 
> > You're arguing we should tune for sysctl performance? That doesn't make
> > sense to me.
> 
> We're talking about a tiny tiny performance gain (one which thus far
> appears to be unobserveable) on the read-side traded off against a
> tremendous slowdown on the write-side.
> 
> That's OK for people whose workloads use the expected read-vs-write
> ratio.  But there's always someone out there who does something
> peculiar.  There will be people who simply cannot accept large
> slowdowns in writes to particular tunables.  Who these people are and
> which tunables they care about we do not know.
> 
> No, I'm not saying we should "tune for sysctl performance".  I'm saying
> we should tune for not making Linux utterly uselessly slow for people
> for whom it previously worked OK.
> 
> It means we'd have to look very carefully at each tunable and decide
> whether there's any conceivable situation in which someone would want
> to alter it frequently.  If so, we need to leave it alone.
> 
> How many tunables will that leave behind, and how much use was it to
> speed that remainder up by a teensy amount?  Who knows.
> 

BTW, when/if we get the OK from Intel to use a breakpoint/IPI-based
scheme to perform the updates rather than using the heavyweight
stop_machine(), this update performance question will be much less of a
concern.

hpa is currently looking into this.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
