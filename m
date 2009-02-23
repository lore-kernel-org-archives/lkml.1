Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZBWUoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZBWUoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZBWUod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:44:33 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55486 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbZBWUoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:44:32 -0500
Date: Mon, 23 Feb 2009 12:44:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, nickpiggin@yahoo.com.au,
       vegard.nossum@gmail.com, stable@kernel.org, npiggin@suse.de,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090223204429.GU6751@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220140157.GA12799@elte.hu> <20090222030030.GD6860@linux.vnet.ibm.com> <20090223051709.GA5990@linux.vnet.ibm.com> <200902240029.37815.nickpiggin@yahoo.com.au> <20090223161726.GD6751@linux.vnet.ibm.com> <20090223111009.d48ff81d.akpm@linux-foundation.org> <20090223193351.GA11921@elte.hu> <20090223120401.b1354133.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223120401.b1354133.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 12:04:01PM -0800, Andrew Morton wrote:
> On Mon, 23 Feb 2009 20:33:51 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > > > Nice work all (btw. if this patch goes in rather than using system_state,
> > > > > then please make the variable __read_mostly).
> > > > 
> > > > Hmmm...  I misread this and made system_state be __read_mostly.  Let
> > > > me know if this is bad, easy to fix if needed.
> > > 
> > > Please don't use system_state.  The whole thing is just bad 
> > > design. It's a global variable, breaks encapsulation, creates 
> > > interactions etc. CS-101 stuff.
> > 
> > ok, i've removed the patch
> 
> Thanks.
> 
> > - Paul, would you mind to re-send 
> > your original flag solution, with it marked __read_mostly and 
> > with the extern declarations put into a suitable header file?
> 
> It would still make sense to mark system_state __read_mostly.
> 
> (That's assuming that __read_mostly makes sense.  I still wanna
> rename it to __pack_all_write_often_variables_into_the_same_cacheline
> and see what happens then)

The patch I just posted retains this change.  ;-)

							Thanx, Paul
