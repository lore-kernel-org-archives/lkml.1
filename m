Return-Path: <linux-kernel-owner+w=401wt.eu-S966118AbXDJIlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966118AbXDJIlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966120AbXDJIla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:41:30 -0400
Received: from smtp.osdl.org ([65.172.181.24]:48403 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966118AbXDJIla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:41:30 -0400
Date: Tue, 10 Apr 2007 01:41:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Dave Jones <davej@redhat.com>, Robin Holt <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-Id: <20070410014102.fd730911.akpm@linux-foundation.org>
In-Reply-To: <461B4BF5.6070909@garzik.org>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<4616CBF0.7090606@garzik.org>
	<20070409172339.48d661d6.akpm@linux-foundation.org>
	<20070410015912.GE1994@redhat.com>
	<20070409193056.6b52c354.akpm@linux-foundation.org>
	<461B3754.9040107@garzik.org>
	<20070410003702.f8a49b75.akpm@linux-foundation.org>
	<461B4BF5.6070909@garzik.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 04:33:57 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> Andrew Morton wrote:
> > On Tue, 10 Apr 2007 03:05:56 -0400 Jeff Garzik <jeff@garzik.org> wrote:
> > 
> >> My main 
> >> worry with keventd is that we might get stuck behind an unrelated 
> >> process for an undefined length of time.
> > 
> > I don't think it has ever been demonstrated that keventd latency is
> > excessive, or a problem.  I guess we could instrument it and fix stuff
> > easily enough.
> 
> It's simple math, combined with user expectations.
> 
> On a 1-CPU or 2-CPU box, if you have three or more tasks, all of which 
> are doing hardware reset tasks that could take 30-60 seconds (realistic 
> for libata, SCSI and network drivers, at least), then OBVIOUSLY you have 
> other tasks blocked for that length of time.

Well that obviously would be a dumb way to use keventd.  One would need
to do schedule_work(), kick off the reset then do schedule_delayed_work()
to wait (or poll) for its termination.
