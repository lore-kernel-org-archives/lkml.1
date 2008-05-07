Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYEGEeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYEGEeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761373AbYEGEdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:33:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:56766 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761093AbYEGEdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:33:47 -0400
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
	drivers/video/aty/radeon_base.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080506182006.4b4a3968.akpm@linux-foundation.org>
References: <20080424043400.GS20457@bakeyournoodle.com>
	 <20080506143936.6357e578.akpm@linux-foundation.org>
	 <20080506.144301.233784820.davem@davemloft.net>
	 <1210121683.21644.194.camel@pasglop>
	 <20080506182006.4b4a3968.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 07 May 2008 14:33:24 +1000
Message-Id: <1210134804.21644.202.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 18:20 -0700, Andrew Morton wrote:
> Look at the history of this.  A couple of years ago we were seeing a huge
> number of mysterious crashes and warnings in and around sysfs and driver
> code and we just didn't have a clue what was causing it, because those
> crashes were happening long, long after the buggy code had done its work.
> 
> So I went in there and found a tremendous amount of code in driver core,
> sysfs and in callers of both which was just ignoring error returns and
> blundering on.
> 
> It was a comnplete undebuggable unmaintainable mess.  And the reason why it
> was undebuggable was because the code was failing to detect errors *when
> they occurred*.  So we (me, Cornelia, Greg, others) set about fixing all of
> that.  And to support that effort we marked all the things which should be
> checked with __must_check.

You haven't read me properly. I'm not advocating completely ignoring
those errors. In fact, I'm all about keeping must check on things like
allocations. However, in cases like sysfs_create_file() like many
similar things where failure will -not- prevent proper operations of the
driver or subsystem, mostly only compromise the user ABI, I believe it's
a _LOT_ more efficient to put -one- printk in the function itself,
rather than all callers

> Now you come along and cherrypick a few callsites where you'd rather not
> bother checking and assert that the entire effort was wrong-headed.  Well
> sorry, no, it wasn't.  Sure, there's a little bit of undesirable fallout
> but the whole thing had.  to.  be.  done.

Of course the whole effort was not wrong headed. I'm really only
complaining about all those stupid sysfs_create_file() and maybe a
handful of similar ones.

Ben.


