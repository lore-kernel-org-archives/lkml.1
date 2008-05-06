Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbYEFU3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbYEFU3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbYEFU31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:29:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756259AbYEFU3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:29:25 -0400
Date: Tue, 6 May 2008 13:28:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Ingo Molnar <mingo@elte.hu>, "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080506164231.GK19219@parisc-linux.org>
Message-ID: <alpine.LFD.1.10.0805061327490.32269@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <alpine.LFD.1.10.0805060931450.32269@woody.linux-foundation.org>
 <20080506164231.GK19219@parisc-linux.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 May 2008, Matthew Wilcox wrote:
> On Tue, May 06, 2008 at 09:36:06AM -0700, Linus Torvalds wrote:
> > 
> > Hmm. Wouldn't it be nicer to make the lock be a per-inode thing? Or is 
> > there some user that doesn't have the inode info, or does anything that 
> > might cross inode boundaries?
> 
> /proc/locks and deadlock detection both cross inode boundaries (and even
> filesystem boundaries).  The BKL-removal brigade tried this back in 2.4
> and the locking ended up scaling worse than just plonking a single
> spinlock around the whole thing.

Ok, no worries. Just as long as I know why it's a single lock. Looks ok to 
me, apart from the need for testing (and talking to NFS etc people).

		Linus
