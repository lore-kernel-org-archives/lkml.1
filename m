Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYJCOhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYJCOhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYJCOh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:37:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYJCOh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:37:27 -0400
Date: Fri, 3 Oct 2008 15:36:36 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
Subject: Re: [PATCH] Memory management livelock
Message-ID: <20081003143636.GD18542@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
	mbroz@redhat.com, chris@arachsys.com
References: <20080911101616.GA24064@agk.fab.redhat.com> <200810031254.29121.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0810030716310.4875@hs20-bc2-1.build.redhat.com> <200810032231.03985.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810032231.03985.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 10:31:03PM +1000, Nick Piggin wrote:
> On Friday 03 October 2008 21:26, Mikulas Patocka wrote:
> > LVM does (that is where the bug was discovered). Basically, it scans all
> > the block devices with direct IO and if someone else does buffered IO on
> > any device simultaneously, it locks up.
> Scans all block devices with direct IO? Hmm, why, I wonder? Should
> really consider using buffered (posix_fadvise to readahead/dropbehind).
 
Scan in the sense of it reading a few sectors from each potential LVM
device to check whether it contains an LVM label.

Alasdair
-- 
agk@redhat.com
