Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZIBVaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZIBVaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 17:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZIBVaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 17:30:19 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:58501 "EHLO
	relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbZIBVaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 17:30:19 -0400
Date: Wed, 2 Sep 2009 14:30:43 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
       Tim Pepper <lnxninja@linux.vnet.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       John Stultz <johnstul@us.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jamey Sharp <jamey@minilop.net>
Subject: Re: [RFC PATCH] Turn off the tick even when not idle
Message-ID: <20090902213000.GA7137@josh-work.beaverton.ibm.com>
References: <20090901154327.GA10024@feather>
 <20090902200125.GA1851@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902200125.GA1851@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 10:01:26PM +0200, Pavel Machek wrote:
> Hi!
> 
> > When a process does some number crunching for a while, without involving
> > the kernel, the kernel still interrupts it HZ times per second to figure
> > out if it has any work to do.  With a system dedicated to doing such
> > number crunching, the answer will almost always come up "no"; however,
> > the kernel takes a while figuring out all the "no"s from various
> > subsystems, every timer tick.  On my system, the timer tick takes about
> > 80us, every 1/HZ seconds; that represents a significant overhead.  80us
> > out of every 1ms, for instance, means 8% overhead.  Furthermore, the
> > time taken varies, and the timer interrupts lead to jitter in the
> > performance of the number crunching.
> 
> 8% overhead on hz=1000 is quite high --- what hw is that?

32-bit x86, ThinkPad T60p (work laptop).  I've observed similar
latencies on x86-64, and others have observed them on 64-bit powerpc.

On top of that, almost all of that 80us consists of variations on "Do I
have any work to do?  No?  OK then.".

> You should be able to get similar results with HZ=1, right?

Possibly, yes.  But I want good responsiveness when the system *does*
have work to do.

- Josh Triplett
