Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZAEQFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZAEQFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZAEQFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:05:22 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42442 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbZAEQFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:05:20 -0500
Date: Mon, 5 Jan 2009 08:05:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       segher@kernel.crashing.org, rth@gcc.gnu.org
Subject: Re: atomics: document that linux expects certain atomic behaviour
	from unsigned long
Message-ID: <20090105160501.GB6959@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090103124400.GA1572@ucw.cz> <200901052154.45958.nickpiggin@yahoo.com.au> <20090105112350.3e665114@lxorguk.ukuu.org.uk> <200901052300.24951.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901052300.24951.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 11:00:24PM +1100, Nick Piggin wrote:
> On Monday 05 January 2009 22:23:50 Alan Cox wrote:
> > > Pretty much everywhere that uses RCU for example does so using atomic
> > > pointer loads and stores. The nastiest issue IMO actually is reloading
> > > the value through the pointer even if it isn't explicitly dereferenced.
> > > RCU gets this right with ACCESS_ONCE. Probably a lot of code using basic
> > > types does not. x86 atomic_read maybe should be using ACCESS_ONCE too...
> >
> > I'm pretty sure it should. gcc makes no guarantees about not being clever
> > with accesses.
> 
> Arguably it should. I don't know what the concurrent C standard looks like,
> but prohibiting reloads of potentially concurrently modified memory when
> there is no explicit pointer dereference is the natural complement to
> prohibiting stores to potentially concurrently read memory when there is
> no explicit store (which I think is begrudgingly agreed to be a problem).
> 
> http://lkml.org/lkml/2007/10/24/673
> 
> I think I would like to see multiple reloads to local variables prohibited,
> to avoid potential really subtle problems... But if ACCESS_ONCE is here to
> stay, then I do think that atomic_read etc should use it.

The concurrency stuff in c++0x still permits the compiler to have its
way with loads and stores to normal variables, but provides an "atomic"
type that must be loaded and stored as specified in the program.

The issue with ACCESS_ONCE() is that gcc doesn't do any optimizations on
volatile accesses, even the obvious ones.  Speaking of which, the gcc
guys kicked out my bug 33102, which was complaining about this
situation.  :-/

							Thanx, Paul
