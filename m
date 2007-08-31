Return-Path: <linux-kernel-owner+w=401wt.eu-S965653AbXHaNwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965653AbXHaNwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 09:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965074AbXHaNvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 09:51:52 -0400
Received: from pat.uio.no ([129.240.10.15]:53103 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965041AbXHaNvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 09:51:51 -0400
Subject: Re: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jakob Oestergaard <jakob@unthought.net>, Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <20070831131226.GA24084@janus>
References: <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
	 <1188535485.6626.85.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org>
	 <1188536658.6626.98.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302215280.25853@woody.linux-foundation.org>
	 <20070831074028.GR21979@unthought.net>
	 <alpine.LFD.0.999.0708310055010.25853@woody.linux-foundation.org>
	 <1188562298.6649.39.camel@heimdal.trondhjem.org>
	 <20070831131226.GA24084@janus>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 09:50:12 -0400
Message-Id: <1188568212.6649.75.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, AWL=0.041)
X-UiO-Scanned: DC00E1F9ABD6CBC3DBBA06605C33F14BA3D5F570
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1311 total 3589923 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 15:12 +0200, Frank van Maarseveen wrote:

> IMHO I'd only consider returning EBUSY when trying to mount _exactly_
> the same directory with different flags, not for arbitrary subtrees. The
> client should preferably not be bothered with server side disk
> partitioning (at least not beyond the obvious such as df output).

That is utterly inconsistent and confusing too.

If you have a filesystem "/foo" exported on the server "remote", then
why should

        mount -oro remote:/foo
        mount -orw remote:/foo/a

be allowed, but

        mount -oro remote:/foo
        mount -orw remote:/foo

be forbidden? The caching problems are the same. Telling the admin that
one is safe and the other is not, is just messing with his mind.

Trond

