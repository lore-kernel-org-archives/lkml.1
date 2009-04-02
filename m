Return-Path: <linux-kernel-owner+w=401wt.eu-S1765831AbZDBTUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765831AbZDBTUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765441AbZDBTUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:20:20 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:53791 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764980AbZDBTUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:20:19 -0400
Subject: Re: [PATCH 06/43] FS-Cache: Recruit a couple of page flags for
 cache management [ver #46]
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, viro@zeniv.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <7516.1238694057@redhat.com>
References: <200904030431.04079.nickpiggin@yahoo.com.au>
	 <200904030353.17713.nickpiggin@yahoo.com.au>
	 <200904030315.03606.nickpiggin@yahoo.com.au> <7249.1238692155@redhat.com>
	 <7516.1238694057@redhat.com>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 15:19:47 -0400
Message-Id: <1238699987.16087.26.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: CFC2575891567119A52F276C988FE5EF4B860585
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 135 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 18:40 +0100, David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > Well in theory I still think it would be cleanest to modify buffer to
> > play more nicely with it. But maybe that ends up being harder to
> > distinguish the 3 cases of attached metadata on the page. I don't know,
> > you haven't posted any isofs code so either way it is inappropriate to
> > use up this extra page flag here.
> > 
> > Is isofs cache worth a page flag?
> 
> Well, isofs was something I wanted at the time.
> 
> Besides, as I said NFS uses PG_private for its own purposes, and entangling
> the two wasn't the most fun I've had.  Trond didn't like it either.

We use it for exactly the same purpose as everyone else: to signal that
we need a callback to ->releasepage() if the VM wants to truncate the
page.

Trond

