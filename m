Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbXGXUNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbXGXUNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbXGXUNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:13:13 -0400
Received: from pat.uio.no ([129.240.10.15]:52175 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbXGXUNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:13:11 -0400
Subject: Re: [PATCH RFC] extent mapped page cache
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Chris Mason <chris.mason@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070724160032.7a7097db@think.oraclecorp.com>
References: <20070710210326.GA29963@think.oraclecorp.com>
	 <20070724160032.7a7097db@think.oraclecorp.com>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 16:13:05 -0400
Message-Id: <1185307985.6586.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.108)
X-UiO-Scanned: 7C68EE737FC0C41FDE2BF98440D39ACF629E48C2
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 121 total 2956083 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 16:00 -0400, Chris Mason wrote:
> On Tue, 10 Jul 2007 17:03:26 -0400
> Chris Mason <chris.mason@oracle.com> wrote:
> 
> > This patch aims to demonstrate one way to replace buffer heads with a
> > few extent trees.  Buffer heads provide a few different features:
> > 
> > 1) Mapping of logical file offset to blocks on disk
> > 2) Recording state (dirty, locked etc)
> > 3) Providing a mechanism to access sub-page sized blocks.
> > 
> > This patch covers #1 and #2, I'll start on #3 a little later next
> > week.
> > 
> Well, almost.  I decided to try out an rbtree instead of the radix,
> which turned out to be much faster.  Even though individual operations
> are slower, the rbtree was able to do many fewer ops to accomplish the
> same thing, especially for merging extents together.  It also uses much
> less ram.

The problem with an rbtree is that you can't use it together with RCU to
do lockless lookups. You can probably modify it to allocate nodes
dynamically (like the radix tree does) and thus make it RCU-compatible,
but then you risk losing the two main benefits that you list above.

Trond

