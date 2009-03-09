Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbZCINqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbZCINqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZCINql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:46:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:45725 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZCINqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:46:40 -0400
Subject: Re: [patch] Re: scheduler oddity [bug?]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Balazs Scheidler <bazsi@balabit.hu>,
       linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
In-Reply-To: <1236605870.6515.5.camel@marge.simson.net>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>
	 <1236529200.7110.16.camel@marge.simson.net>
	 <20090308175255.GA22802@elte.hu>
	 <1236585731.6118.24.camel@marge.simson.net>
	 <20090309080714.GB24904@elte.hu>  <1236596664.8389.331.camel@laptop>
	 <1236604563.6027.8.camel@marge.simson.net>
	 <1236605870.6515.5.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 14:46:29 +0100
Message-Id: <1236606389.8389.518.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 14:37 +0100, Mike Galbraith wrote:
> On Mon, 2009-03-09 at 14:16 +0100, Mike Galbraith wrote:
> > On Mon, 2009-03-09 at 12:04 +0100, Peter Zijlstra wrote:
> > 
> > > OK, talked a bit with Ingo, the reason you're doing is that avg_overlap
> > > can easily grow stale.. I can see that happen indeed.
> > > 
> > > So the 'perfect' thing would be a task-runtime decay, barring that the
> > > preemption thing seems a sane enough hart-beat of a task.
> > > 
> > > How does the below look to you?
> > 
> > Other than the fact that the test for sync reject is currently
> > avg_overlap > sysctl_sched_migration_cost, looks fine to me.  Having it
> > capped at the boundary is probably the better way to go.
> 
> Heh, doesn't _quite_ work though.  The little bugger now hovers just
> under :-/

> se.avg_overlap                     :             0.499993

Right, update_avg()'s >>3 and the off-by-one you spotted.

I recon stuff works better with a 2* added? After that I guess its
praying sysbench still works.. :-)

