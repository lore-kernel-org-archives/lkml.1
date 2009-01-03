Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbZACB6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbZACB6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 20:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbZACB5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 20:57:52 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39581 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423AbZACB5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 20:57:51 -0500
Date: Fri, 2 Jan 2009 17:57:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090103015748.GL6842@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090102111819.GC6088@alice> <20090102175853.GC6842@linux.vnet.ibm.com> <20090102185303.GC5743@linux.vnet.ibm.com> <20090102195326.GF6842@linux.vnet.ibm.com> <20090102231239.GA19778@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102231239.GA19778@alice>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 12:12:39AM +0100, Eric Sesterhenn wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Sat, Jan 03, 2009 at 12:23:03AM +0530, Kamalesh Babulal wrote:
> > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2009-01-02 09:58:53]:
> > > 
> > > > On Fri, Jan 02, 2009 at 12:18:19PM +0100, Eric Sesterhenn wrote:
> > > > > Hi,
> > > > > 
> > > > > modprobing rcutorture and removing it again gives me the following oops:
> > > > 
> > > > This looks similar to something that Kamalesh ran into a few weeks ago.
> > > > 
> > > > Kamalesh, did the fixes for that make it to 2.6.28?
> > > > 
> > > > 							Thanx, Paul
> > > > 
> > > 
> > > Hi Paul,
> > > 
> > > 	The fix was available in linux-next from Dec 23 2008 (commit 392ddc32982a5c661dd90dd49a3cb37f1c68b782
> > > 'bio: add support for inlining a number of bio_vecs inside the bio') and it has be pushed for merger in 2.6.29.
> > 
> > Thank you, Kamalesh!
> > 
> > Eric, could you please try applying the above commit and see if the
> > problem reproduces?
> 
> I tried to apply the patch from
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff_plain;h=392ddc32982a5c661dd90dd49a3cb37f1c68b782;hp=bb799ca0202a360fa74d5f17039b9100caebdde7
> but get a message that it is already applied. Seems i already got that
> one.

Is your configuration able to support ftrace?

Looks like someone is (wrongly) freeing some memory that was sent to
call_rcu(), and ftrace might be one way to locate the problem.

							Thanx, Paul
