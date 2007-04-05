Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbXDEQpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbXDEQpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbXDEQpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:45:16 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:37339 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753232AbXDEQpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:45:15 -0400
Date: Thu, 5 Apr 2007 12:45:14 -0400
To: Mark Lord <lkml@rtr.ca>
Cc: Phillip Susi <psusi@cfl.rr.com>, Chris Snook <csnook@redhat.com>,
       Paa Paa <paapaa125@hotmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Lower HD transfer rate with NCQ enabled?
Message-ID: <20070405164514.GF3510@csclub.uwaterloo.ca>
References: <BAY20-F50719E454DCCF2309DA1AF9670@phx.gbl> <46128175.2090506@redhat.com> <4612852C.2030801@rtr.ca> <4612A854.1070702@cfl.rr.com> <4613C612.5040600@rtr.ca> <4615160A.4090506@cfl.rr.com> <46151FCD.6000700@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46151FCD.6000700@rtr.ca>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 12:11:57PM -0400, Mark Lord wrote:
> For personal systems, yes.  For servers, probably not a bug.
> 
> Disabling readahead means faster execution queued commands,
> since it doesn't have to "linger" and do unwanted read-ahead.
> So this bug is a "feature" for random access servers.
> And a big nuisance for everything else.

Sounds like a trade off between doing read ahead on the current track,
or immediately starting to seek to the track for the next request in the
queue.  After all reading ahead on the current track means you can't
start seeking to the next request yet.

I agree it does sound like a feature.  Let the user/OS decide if read
aheads should be done by queueing them if wanted, and not queueing them
if not wanted.  Seems simple enough.  Also avoids poluting the cache
with unwanted data at the expense of potentially wanted data that was
already in the cache.

--
Len Sorensen
