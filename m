Return-Path: <linux-kernel-owner+w=401wt.eu-S933743AbXJQPrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743AbXJQPrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbXJQPrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:47:32 -0400
Received: from pat.uio.no ([129.240.10.15]:40799 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760852AbXJQPrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:47:31 -0400
Subject: Re: [PATCH] nfs: fix nfs_writepage()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1192635917.7573.24.camel@heimdal.trondhjem.org>
References: <1192628458.27435.119.camel@twins>
	 <1192634702.7573.10.camel@heimdal.trondhjem.org>
	 <1192635028.27435.137.camel@twins>
	 <1192635917.7573.24.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 11:47:54 -0400
Message-Id: <1192636074.7573.27.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.3, required=12.0, autolearn=disabled, AWL=-0.298)
X-UiO-Scanned: 0C5150C57426D1FB6F15355D70BCBFCC0B71E8BA
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -2 maxlevel 200 minaction 2 bait 0 mail/h: 753 total 4555608 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-17 at 11:45 -0400, Trond Myklebust wrote:
> On Wed, 2007-10-17 at 17:30 +0200, Peter Zijlstra wrote:
> 
> > The thing is, swapper_space just calls ->writepage() and expects the
> > page to be written out. So either the a_ops usage of swapper_space is
> > deviant or NFS' is.
> 
> Could somebody please document WTF writepage() is supposed to do, and
> WTF page_mkwrite() is for?
> 
> I thought that page_mkwrite() was supposed to finally allow us to deal
> with dirty pages in a clean manner: the caller gets to tell the
> filesystem that it wants the entire page written out, and then dirties
> the page. What is the point if the VM then expects to be able to
> circumvent this?

Put differently:
      * _who_ is dirtying the page when the swapper is trying to write
        the page out?
      * why are they not calling either page_mkwrite() or
        commit_write()?

Trond

