Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbXLDJfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbXLDJfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 04:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXLDJfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 04:35:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58377 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbXLDJfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 04:35:36 -0500
Date: Tue, 4 Dec 2007 10:34:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Mark Lord <lkml@rtr.ca>, Pavel Machek <pavel@ucw.cz>,
       Mark Lord <liml@rtr.ca>, Thomas Gleixner <tglx@linutronix.de>,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071204093451.GA4541@elte.hu>
References: <20071202141117.GB9516@lazybastard.org> <20071202154746.GA27069@elte.hu> <20071202195501.GB10657@lazybastard.org> <20071202200722.GA12101@elte.hu> <20071202203016.GC10657@lazybastard.org> <20071202204559.GA28550@elte.hu> <20071202211026.GB11522@lazybastard.org> <20071202211900.GB7439@elte.hu> <20071203005702.GA12215@lazybastard.org> <20071204000655.GA17212@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071204000655.GA17212@lazybastard.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jörn Engel <joern@logfs.org> wrote:

> On Mon, 3 December 2007 01:57:02 +0100, Jörn Engel wrote:
> > 
> > After an eternity of compile time, this config does generate some useful
> > output.  qemu is not to blame.
> 
> Or is it?  The output definitely looks suspicious.  Large amounts of 
> code get processed within a microsecond, while update_wall_time() 
> appears to cause huge delays every time it is called: 
> http://logfs.org/~joern/trace
> 
> Does this output make sense or does it rather indicate some sloppiness 
> wrt. time in the qemu virtual machine?

not sure. It could be qemu being scheduled away? You could try to run 
qemu with nice -20 or so, to avoid getting preempted. If time lapses 
like this still show up:

 trace-cm 434   0D.h. 1008us!: do_timer (tick_periodic)
 trace-cm 434   0D.h. 1972us+: update_wall_time (do_timer)

 trace-cm 434   0D.h. 1008us!: do_timer (tick_periodic)
 trace-cm 434   0D.h. 1972us+: update_wall_time (do_timer)

then that could indicate a timekeeping weirdness, OR it could mean that 
qemu is simply very slow. (there could be timer hw access between those 
two function calls)

	Ingo
