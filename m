Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbZDQI7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbZDQI7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 04:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbZDQI7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:59:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:16805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbZDQI7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:59:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,203,1239001200"; 
   d="scan'208";a="682380771"
Subject: Re: [PATCH] Fix discard requests accounting in the diskstats
From: David Woodhouse <david.woodhouse@intel.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jmarchan@redhat.com" <jmarchan@redhat.com>
In-Reply-To: <200904171325.01486.knikanth@suse.de>
References: <200904171144.49448.knikanth@suse.de>
	 <20090417064912.GH4593@kernel.dk>  <200904171325.01486.knikanth@suse.de>
Content-Type: text/plain
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Fri, 17 Apr 2009 09:59:11 +0100
Message-Id: <1239958751.3428.21.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-3.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 08:55 +0100, Nikanth Karthikesan wrote:
> On Friday 17 April 2009 12:19:12 Jens Axboe wrote:
> > On Fri, Apr 17 2009, Nikanth Karthikesan wrote:
> > > When 2 discard requests are merged, the stats gets updated, but we do not
> > > update statistics normally when a discard request is issued or completed.
> > > For example the in_flight counter would be decremented when 2 discard
> > > requests are merged, but it was not at all incremented when they were
> > > issued, and in_flight counter will not be decremented, when they are
> > > completed as well.
> > >
> > > This patch fixes this by adding discard requests to the statistics.
> >
> > This needs rebasing on top of this one:
> >
> > http://lkml.org/lkml/2009/4/16/159
> >
> > whenever that gets resubmitted as a proper, working patch.
> >
> 
> Ok. I will resend after Jerome resubmits that patch.

There are more interesting issues with discard requests and elevators
for now, such as the fact that elevators only actually prevent write
requests from crossing each other on the queue if the {start,end} range
precisely matches, not merely if they happen to overlap.

So all discard requests are submitted as soft barriers for now anyway.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

