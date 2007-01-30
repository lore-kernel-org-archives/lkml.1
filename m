Return-Path: <linux-kernel-owner+w=401wt.eu-S1750978AbXA3TuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbXA3TuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbXA3TuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:50:09 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53195 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbXA3TuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:50:06 -0500
Date: Tue, 30 Jan 2007 11:49:40 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       dipankar@in.ibm.com, Gautham Shenoy <ego@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070130194940.GI2092@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070126112837.059502fc.akpm@osdl.org> <20070130073340.GC30160@elte.hu> <20070130160244.GB2092@linux.vnet.ibm.com> <200701301744.48601.rjw@sisk.pl> <20070130102718.f03f37d8.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130102718.f03f37d8.akpm@osdl.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 10:27:18AM -0800, Andrew Morton wrote:
> On Tue, 30 Jan 2007 17:44:47 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > > I need to look at all uses of PF_NOFREEZE -- as I understand the
> > > code, processes marked PF_NOFREEZE will continue running, potentially
> > > interfering with the hotplug operation.  :-(
> > > 
> > > I will pass my findings on to this list.
> > 
> > Well, I did it some time ago, although not very thoroughly.
> > 
> > AFAICS there are not so many, but one that stands out is the worker threads.
> > We needed two of them to actually go to sleep, so now it's possible to create
> > a "freezeable workqueue" the worker thread of which will not set PF_NOFREEZE,
> > but currently this is only used by XFS.
> 
> Or we can create a variant of freeze_processes which ignores PF_NOFREEZE.
> 
> As I said eariler, we might need to change the freezer code for this
> application.  In fact we should do so: that sys_sync() call in there is
> quite inappropriate, as is, I suppose, the two-pass freeze attempt.  As are
> the nice printks, come to that.
> 
> Pretty simple stuff though.

And we might need to change some of the processes that currently set
PF_NOFREEZE so that they periodically go somewhere that the freezer can
find them -- if I remember correctly, at least some of the PF_NOFREEZE
tasks were so marked in order to prevent suspend hangs.

Part of what I need to look at.  ;-)

							Thanx, Paul
