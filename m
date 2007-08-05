Return-Path: <linux-kernel-owner+w=401wt.eu-S1762627AbXHEUnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762627AbXHEUnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbXHEUnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:43:09 -0400
Received: from thunk.org ([69.25.196.29]:40617 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbXHEUnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:43:08 -0400
Date: Sun, 5 Aug 2007 16:42:20 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jakob Oestergaard <jakob@unthought.net>, Jeff Garzik <jeff@garzik.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [patch] implement smarter atime updates support, v2
Message-ID: <20070805204220.GB32217@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jakob Oestergaard <jakob@unthought.net>,
	Jeff Garzik <jeff@garzik.org>, miklos@szeredi.hu,
	akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
	tomoki.sekiyama.qu@hitachi.com,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	nikita@clusterfs.com, trond.myklebust@fys.uio.no,
	yingchao.zhou@gmail.com, richard@rsk.demon.co.uk, david@lang.hm
References: <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070805102021.GA4246@unthought.net> <46B5A996.5060006@garzik.org> <20070805105850.GC4246@unthought.net> <20070805124648.GA21173@elte.hu> <alpine.LFD.0.999.0708050944470.5037@woody.linux-foundation.org> <20070805190928.GA17433@elte.hu> <20070805192226.GA20234@elte.hu> <20070805192838.GA21704@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805192838.GA21704@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 09:28:38PM +0200, Ingo Molnar wrote:
> 
> added the relatime_interval sysctl that allows the changing of the atime 
> update frequency. (default: 1 day / 86400 seconds)

What if you specify the interval as a per-mount option?  i.e., 

	mount -o relatime=86400 /dev/sda2 /u1

If you had this, I don't think we would need the sysctl tuning parameter.

							- Ted
