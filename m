Return-Path: <linux-kernel-owner+w=401wt.eu-S1759021AbZDQJJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbZDQJJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 05:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbZDQJIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 05:08:54 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60165 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728AbZDQJIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:08:54 -0400
Date: Fri, 17 Apr 2009 11:08:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Woodhouse <david.woodhouse@intel.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jmarchan@redhat.com" <jmarchan@redhat.com>
Subject: Re: [PATCH] Fix discard requests accounting in the diskstats
Message-ID: <20090417090851.GO4593@kernel.dk>
References: <200904171144.49448.knikanth@suse.de> <20090417064912.GH4593@kernel.dk> <200904171325.01486.knikanth@suse.de> <1239958751.3428.21.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239958751.3428.21.camel@macbook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17 2009, David Woodhouse wrote:
> On Fri, 2009-04-17 at 08:55 +0100, Nikanth Karthikesan wrote:
> > On Friday 17 April 2009 12:19:12 Jens Axboe wrote:
> > > On Fri, Apr 17 2009, Nikanth Karthikesan wrote:
> > > > When 2 discard requests are merged, the stats gets updated, but we do not
> > > > update statistics normally when a discard request is issued or completed.
> > > > For example the in_flight counter would be decremented when 2 discard
> > > > requests are merged, but it was not at all incremented when they were
> > > > issued, and in_flight counter will not be decremented, when they are
> > > > completed as well.
> > > >
> > > > This patch fixes this by adding discard requests to the statistics.
> > >
> > > This needs rebasing on top of this one:
> > >
> > > http://lkml.org/lkml/2009/4/16/159
> > >
> > > whenever that gets resubmitted as a proper, working patch.
> > >
> > 
> > Ok. I will resend after Jerome resubmits that patch.
> 
> There are more interesting issues with discard requests and elevators
> for now, such as the fact that elevators only actually prevent write
> requests from crossing each other on the queue if the {start,end} range
> precisely matches, not merely if they happen to overlap.
> 
> So all discard requests are submitted as soft barriers for now anyway.

But they are still marked mergeable, so the accounting should be correct
regardless.

-- 
Jens Axboe

