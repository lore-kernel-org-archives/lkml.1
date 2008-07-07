Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYGGNqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYGGNqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 09:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYGGNqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 09:46:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48963 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYGGNqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 09:46:05 -0400
Subject: Re: [PATCH] aio: avoid using queue_delayed_work in
	aio_kick_handler to schedule itself
From: Chris Mason <chris.mason@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
       Zach Brown <zach.brown@oracle.com>
In-Reply-To: <200807011421.38532.knikanth@suse.de>
References: <200806260927.27995.knikanth@suse.de>
	 <x49prq3t43a.fsf@segfault.boston.devel.redhat.com>
	 <200806301120.27743.knikanth@suse.de> <200807011421.38532.knikanth@suse.de>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 09:44:58 -0400
Message-Id: <1215438298.24425.9.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-01 at 14:21 +0530, Nikanth Karthikesan wrote:
> On Monday 30 June 2008 11:20:27 Nikanth Karthikesan wrote:
> > On Friday 27 June 2008 18:41:37 Jeff Moyer wrote:
> > > Nikanth Karthikesan <knikanth@suse.de> writes:
> > > > Avoid using queue_delayed_work in aio_kick_handler() to run itself
> > > > immediately. Instead use aio_run_all_iocbs()
> > >
> > > Can you give some rationale for this change?  Also, how did you test it?
> >
> > The comment in aio_kick_handler(), "we're in a worker thread already, don't
> > use queue_delayed_work" triggered me to do this. Ran multiple instances
> > of Stephen Hemminger's aio cp for basic testing.
> >
> > I think this would make it unfair between different kioctx? May be only the
> > comment should be removed?
> >
> 
> Anyway we are scheduling it again with timeout of 0, so fairness shouldnt be a 
> problem? If yes, wouldn't this change reduce the overhead of queuing the work 
> again, and repeated lock/unlock.

The main purpose of the delayed queuing was to improve performance with
workloads where the work was more or less immediately done.  The best
example is aio pipes.  The delayed queue cut down on the context switch
rate dramatically and made a large performance improvement for pipe
workloads (without cutting down on other perf at the time).

-chris


