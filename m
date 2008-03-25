Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbYCYIWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbYCYIWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 04:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYCYIWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 04:22:37 -0400
Received: from www.tglx.de ([62.245.132.106]:50188 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbYCYIWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 04:22:36 -0400
Date: Tue, 25 Mar 2008 09:19:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/5] infrastructure to debug (dynamic) objects
In-Reply-To: <20080324130454.ced60108.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803250915330.3781@apollo.tec.linutronix.de>
References: <20080321200300.310393657@linutronix.de> <20080321200321.650649403@linutronix.de> <20080324130454.ced60108.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008, Andrew Morton wrote:
> On Fri, 21 Mar 2008 20:26:18 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > The debugobjects core code keeps track of operations on static and
> > dynamic objects by inserting them into a hashed list and sanity
> > checking them on object operations and provides additional checks
> > whenever kernel memory is freed.
> 
> Prime candidates for conversion to this interface are locks: spinlocks,
> rwlocks, mutexes, etc.
> 
> a) it'd be interesting to get that done, as a proof-of-usefulness thing.

/me looks for volunteers :)
 
> b) but this code internally uses spinlocks.  Will it explode?

It should not, but we can use untracked spinlocks for the internals.

> also list_heads and hlists.  But
> 
> a) that might be a bit redundant against the custome debugging which lists
>    already have and

Yup.
 
> b) this code uses lists and hlists internally?

Yes, it uses hlists.

Thanks,

	tglx
 
