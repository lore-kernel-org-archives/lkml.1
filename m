Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbZIBUBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbZIBUBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 16:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZIBUBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 16:01:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46089 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZIBUBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 16:01:36 -0400
Date: Wed, 2 Sep 2009 22:01:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
       Tim Pepper <lnxninja@linux.vnet.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       John Stultz <johnstul@us.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jamey Sharp <jamey@minilop.net>
Subject: Re: [RFC PATCH] Turn off the tick even when not idle
Message-ID: <20090902200125.GA1851@ucw.cz>
References: <20090901154327.GA10024@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901154327.GA10024@feather>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> When a process does some number crunching for a while, without involving
> the kernel, the kernel still interrupts it HZ times per second to figure
> out if it has any work to do.  With a system dedicated to doing such
> number crunching, the answer will almost always come up "no"; however,
> the kernel takes a while figuring out all the "no"s from various
> subsystems, every timer tick.  On my system, the timer tick takes about
> 80us, every 1/HZ seconds; that represents a significant overhead.  80us
> out of every 1ms, for instance, means 8% overhead.  Furthermore, the
> time taken varies, and the timer interrupts lead to jitter in the
> performance of the number crunching.

8% overhead on hz=1000 is quite high --- what hw is that?

You should be able to get similar results with HZ=1, right?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
