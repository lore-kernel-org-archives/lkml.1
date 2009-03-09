Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbZCIN3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbZCIN3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZCIN2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:28:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZCIN2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:28:02 -0400
Subject: Re: [patch] Re: scheduler oddity [bug?]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Balazs Scheidler <bazsi@balabit.hu>,
       linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
In-Reply-To: <1236604563.6027.8.camel@marge.simson.net>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>
	 <1236529200.7110.16.camel@marge.simson.net>
	 <20090308175255.GA22802@elte.hu>
	 <1236585731.6118.24.camel@marge.simson.net>
	 <20090309080714.GB24904@elte.hu>  <1236596664.8389.331.camel@laptop>
	 <1236604563.6027.8.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 14:27:47 +0100
Message-Id: <1236605267.8389.490.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 14:16 +0100, Mike Galbraith wrote:
> On Mon, 2009-03-09 at 12:04 +0100, Peter Zijlstra wrote:
> 
> > OK, talked a bit with Ingo, the reason you're doing is that avg_overlap
> > can easily grow stale.. I can see that happen indeed.
> > 
> > So the 'perfect' thing would be a task-runtime decay, barring that the
> > preemption thing seems a sane enough hart-beat of a task.
> > 
> > How does the below look to you?
> 
> Other than the fact that the test for sync reject is currently
> avg_overlap > sysctl_sched_migration_cost, looks fine to me.  Having it
> capped at the boundary is probably the better way to go.

Ah, yes, and looking at update_avg() we'll also discard the lower 3
bits, so we'll never actually reach.

So I guess it should read something like:

  update_avg(&prev->se.avg_overlap, 2*sysctl_sched_migration_cost);

or somesuch.

Does it actually solve the reported problem? I've only thought about the
issue so far :-)

