Return-Path: <linux-kernel-owner+w=401wt.eu-S934204AbYD1Nbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204AbYD1Nbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765640AbYD1Nbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:31:43 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:53402 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764994AbYD1Nbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:31:43 -0400
Date: Mon, 28 Apr 2008 09:31:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: Avi Kivity <avi@qumranet.com>
Cc: Ulrich Drepper <drepper@gmail.com>, Soeren Sandmann <sandmann@daimi.au.dk>,
       linux-kernel@vger.kernel.org
Subject: Re: stat benchmark
Message-ID: <20080428133130.GG30840@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Avi Kivity <avi@qumranet.com>, Ulrich Drepper <drepper@gmail.com>,
	Soeren Sandmann <sandmann@daimi.au.dk>,
	linux-kernel@vger.kernel.org
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk> <a36005b50804272143g68dc5f3ax848e9548a3d14ed7@mail.gmail.com> <20080428115321.GD30840@mit.edu> <4815BC1E.6020805@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4815BC1E.6020805@qumranet.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 02:59:26PM +0300, Avi Kivity wrote:
>
> A readdirplus() could sort the inodes according to the filesystem's layout, 
> and additionally issue the stats in parallel, so if you have multiple 
> spindles you get significant additional speedup.
>

Well, sorting inodes is something readdir() could do, but it takes
potentially an unbounded amount of (non-swappable) kernel memory.
That's why it's messy.

And it wouldn't be hard to have flags (set by fcntl()) on the fd
returned by readdir() which which requests inode cache prefetching,
which would have the same net result, without needing to design a new
system call.  So before designing a new system call, it might be worth
it to do some benchmarks to see how much of the cost is really in the
number of stat() system calls, in the warm cache case.

       	  	 	       	      - Ted
