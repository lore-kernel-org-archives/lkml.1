Return-Path: <linux-kernel-owner+w=401wt.eu-S1767691AbXCJBXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767691AbXCJBXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767708AbXCJBXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:23:21 -0500
Received: from waste.org ([66.93.16.53]:46272 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993156AbXCJBXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:23:19 -0500
Date: Fri, 9 Mar 2007 19:10:34 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070310011034.GO10394@waste.org>
References: <20070309053931.GA10459@waste.org> <20070309215716.GK943@1wt.eu> <200703100912.07792.kernel@kolivas.org> <200703101202.25814.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703101202.25814.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 12:02:25PM +1100, Con Kolivas wrote:
> On Saturday 10 March 2007 09:12, Con Kolivas wrote:
> > On Saturday 10 March 2007 08:57, Willy Tarreau wrote:
> > > On Fri, Mar 09, 2007 at 03:39:59PM -0600, Matt Mackall wrote:
> > > > On Sat, Mar 10, 2007 at 08:19:18AM +1100, Con Kolivas wrote:
> > > > > On Saturday 10 March 2007 08:07, Con Kolivas wrote:
> > > > > > On Saturday 10 March 2007 07:46, Matt Mackall wrote:
> 
> > > > 5x memload: good
> > > > 5x execload: good
> > > > 5x forkload: good
> > > > 5 parallel makes: mostly good
> > > > make -j 5: bad
> > > >
> > > > So what's different between makes in parallel and make -j 5? Make's
> > > > job server uses pipe I/O to control how many jobs are running.
> > >
> > > Matt, could you check with plain 2.6.20 + Con's patch ? It is possible
> > > that he added bugs when porting to -mm, or that someting in -mm causes
> > > the trouble. Your experience with -mm seems so much different from mine
> > > with mainline, there must be a difference somewhere !
> >
> > Good idea.
> 
> It's all very odd Matt. It really isn't behaving anything like you describe 
> for myself or others. It sounds more like a real bug than what the design 
> would do at all. The only things that are different on yours is Beryl and a 
> different graphics card. When you're comparing to mainline are you 
> comparing -mm1 to -mm2 to ensure something else from -mm isn't responsible? 
> Also have you tried rsdl on 2.6.20 as Willy suggested?

Haven't tried -mm2. So far I've tried 2.6.21-rc2-mm2 (aka 'stock'),
2.6.21-rc3-mm1, and 2.6.20+rsdl.

I also did a test with Metacity and saw the same issues under load. So
I think Beryl is not part of the problem.

Right now it's looking like the problem is caused by ccache. Disabling
ccache with 2.6.21-rc2-mm1+tickfix+noyield lets me run make -j 5
acceptably. So my new column would be:

            RSDL+NO_HZ+tickfix+noyield+noccache
make -j 5
 beryl      ok/good
 galeon     ok/good
 mp3        good
 terminal   good
 mouse      good

So it's about on par with 2.6.20, maybe slightly better.

I suspect ccache lock contention is somehow involved though it doesn't
explain why my 5 independent makes test beats out make -j 5.

-- 
Mathematics is the supreme nostalgia of our time.
