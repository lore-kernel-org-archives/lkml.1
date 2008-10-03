Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbYJCOuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbYJCOuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbYJCOun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:50:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbYJCOun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:50:43 -0400
Date: Fri, 3 Oct 2008 15:50:29 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH] Memory management livelock
Message-ID: <20081003145029.GE18542@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, mbroz@redhat.com, chris@arachsys.com
References: <20080911101616.GA24064@agk.fab.redhat.com> <200810031254.29121.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0810030716310.4875@hs20-bc2-1.build.redhat.com> <200810032231.03985.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0810030941480.27239@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810030941480.27239@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 09:50:17AM -0400, Mikulas Patocka wrote:
> > > LVM does (that is where the bug was discovered). Basically, it scans all
> > > the block devices with direct IO and if someone else does buffered IO on
> > > any device simultaneously, it locks up.
> > Scans all block devices with direct IO? Hmm, why, I wonder? Should
> > really consider using buffered (posix_fadvise to readahead/dropbehind).
> LVM must not allocate any memory when doing IO because it suspends the 
> block device and memory allocation could trigger writeback on the 
> suspended device and deadlock.
> So it preallocates heap and stack, mlockall()s itself and does direct IO.
 
True, but unrelated to the scanning, which LVM performs *prior* to
entering such a state.

We use direct IO while scanning because it's essential all nodes in a
cluster see the same updated version of the data after any node updated
it.

Alasdair
-- 
agk@redhat.com
