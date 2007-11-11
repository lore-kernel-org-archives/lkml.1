Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbXKKOqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbXKKOqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 09:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXKKOqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 09:46:30 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:41590 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbXKKOq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 09:46:29 -0500
Date: Sun, 11 Nov 2007 09:45:46 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tony@bakeyournoodle.com, paulus@samba.org, dino@in.ibm.com,
       tytso@us.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com, antonb@us.ibm.com
Subject: Re: [PATCH, RFC] improved hacks to allow -rt to run kernbench on
 POWER
In-Reply-To: <1194753541.21340.26.camel@pasglop>
Message-ID: <Pine.LNX.4.58.0711110943510.12853@gandalf.stny.rr.com>
References: <20071109181028.GA26800@linux.vnet.ibm.com> <1194641524.21340.14.camel@pasglop>
 <20071109220717.GJ8826@linux.vnet.ibm.com> <1194753541.21340.26.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 11 Nov 2007, Benjamin Herrenschmidt wrote:

>
> > Removed this as well, also seemed to work.  Please note, however, that
> > this is just running kernbench.  But this did seem to get rid of some
> > of the warnings as well.  ;-)  Now only have the xics_startup() warning.
> >
> > > Overall, looks fine !
> >
> > I bet that there are more gotchas lurking in there somewhere, but in
> > the meantime here is the updated patch.
> >
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
>
> Well, I suppose the patch could go in, maybe with some ifdef's around
> the bits in _switch_to, there's little point in doing that on non-rt
> kernels.

As Nick Piggin already stated, and I'll even state it for the RT kernel,
we do not allow preemption in switch_to. So it is safe to remove those
"preempt_disable" bits from the patch.

-- Steve
