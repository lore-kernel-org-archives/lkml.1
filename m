Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbYLDWEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbYLDWEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYLDWEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:04:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46367 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbYLDWEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:04:42 -0500
Date: Thu, 4 Dec 2008 23:15:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple barriers.)
Message-ID: <20081204221551.GV6703@one.firstfloor.org>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com> <20081204100050.GN6703@one.firstfloor.org> <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com> <20081204142015.GQ6703@one.firstfloor.org> <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com> <20081204145810.GR6703@one.firstfloor.org> <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com> <20081204174838.GS6703@one.firstfloor.org> <Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you are pushing what you are pushing --- barriers allowing to return 
> EOPNOTSUPP anytime --- then asynchronous barrier submits can no longer be 
> used, because by the time EOPNOTSUPP is detected, the filesystem is 
> already corrupted.

Chris Mason pointed out that this can actually already happen. From
a quick review this can happen in MD raid1 at least (their barriers_work
flag is pretty similar to the DM implementation I did).  So everyone
has to handle this already anyways.

> I'm wondering, where in fsync() does Linux wait for hardware disk cache to 
> be flushed? Isn't there a bug that fsync() will return before the cache is 
> flushed? I couldn't really find it. The last thing do_fsync calls is 
> filemap_fdatawait and it doesn't do cache flush (blkdev_issue_flush).

At least in fsync() on journaling fs the metadata update should push it.

-Andi

-- 
ak@linux.intel.com
