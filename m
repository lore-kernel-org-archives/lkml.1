Return-Path: <linux-kernel-owner+w=401wt.eu-S935689AbXGQTZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935689AbXGQTZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbXGQTZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:25:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48735 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757370AbXGQTZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:25:27 -0400
Date: Tue, 17 Jul 2007 12:18:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: block/bsg.c
Message-Id: <20070717121821.3212cd60.akpm@linux-foundation.org>
In-Reply-To: <20070717063810.GY5195@kernel.dk>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	<20070717063810.GY5195@kernel.dk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 08:38:11 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> > In terms of presentation: this code hit the tree as base patch plus what
> > appear to be 20 bugfixes, none of which are really interesting or relevant
> > to mainline.  Personally I think it would be nicer if all that out-of-tree
> > development work was cleaned up and the new code goes in as a single hit.
> > 
> > This makes it a lot easier to find out "wtf does this code all do".  One
> > finds the first commit and reads the changlog.  But this algorithm yields:
> > 
> >     bsg: support for full generic block layer SG v3
> > 
> > which is not helpful.
> 
> I agree, I did consider rebasing the merging all patches into a single
> commit prior to submission. In retrospect that would have been better,
> the bug fixes commits prior to inclusion is not that interesting.

I'm doing a git-bisect and....

block/bsg.c: In function 'bsg_register_queue':
block/bsg.c:1014: error: 'struct kobject' has no member named 'dentry'

That's easily fixable in config, but it's another reason for doing
that consolidation prior to merging.
