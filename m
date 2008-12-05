Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYLEAhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYLEAhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 19:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYLEAhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 19:37:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47403 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYLEAhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 19:37:40 -0500
Date: Fri, 5 Dec 2008 01:48:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple barriers.)
Message-ID: <20081205004849.GX6703@one.firstfloor.org>
References: <20081204100050.GN6703@one.firstfloor.org> <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com> <20081204142015.GQ6703@one.firstfloor.org> <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com> <20081204145810.GR6703@one.firstfloor.org> <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com> <20081204174838.GS6703@one.firstfloor.org> <Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com> <20081204221551.GV6703@one.firstfloor.org> <Pine.LNX.4.64.0812041756550.29638@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812041756550.29638@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And if barriers fail at random points, the user can't turn on disk cache 
> anyway (he would get data corruption if barrier write failed and hardware 

I think we already established earlier in the thread that there is no disk
corruption

> > > I'm wondering, where in fsync() does Linux wait for hardware disk cache to 
> > > be flushed? Isn't there a bug that fsync() will return before the cache is 
> > > flushed? I couldn't really find it. The last thing do_fsync calls is 
> > > filemap_fdatawait and it doesn't do cache flush (blkdev_issue_flush).
> > 
> > At least in fsync() on journaling fs the metadata update should push it.
> > 
> > -Andi
> 
> And what about fdatasync()?

I don't know. The surest way to find out is to instrument it and try.

-Andi
-- 
ak@linux.intel.com
