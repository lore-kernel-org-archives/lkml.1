Return-Path: <linux-kernel-owner+w=401wt.eu-S1751995AbZK1PUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbZK1PUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 10:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZK1PUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 10:20:16 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37542 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZK1PUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 10:20:15 -0500
Date: Sat, 28 Nov 2009 07:20:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091128152026.GA6883@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091123145409.GA29627@wotan.suse.de> <20091128020739.GA18149@linux.vnet.ibm.com> <87pr72529w.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pr72529w.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 12:15:07PM +0100, Andi Kleen wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> >
> > The usual trick would be to keep per-fair-rwlock state in per-CPU
> > variables.  If it is forbidden to read-acquire one nestable fair rwlock
> > while read-holding another, then this per-CPU state can be a single
> > pointer and a nesting count.  On the other hand, if it is permitted to
> > read-acquire one nestable fair rwlock while holding another, then one
> > can use a small per-CPU array of pointer/count pairs.
> 
> The problem is that in preemptible kernels kernel threads can switch
> CPUs all the time.  How would you sync the per CPU state then?

In preemptible kernels, put the state into the task structure.  Perhaps do
this in non-preemptible kernels too, just to save a bit of source code.

							Thanx, Paul
