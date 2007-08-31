Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbXHaOmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbXHaOmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbXHaOma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:42:30 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:51178 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754254AbXHaOm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:42:29 -0400
Date: Fri, 31 Aug 2007 16:42:27 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Frank van Maarseveen <frankvm@frankvm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jakob Oestergaard <jakob@unthought.net>, Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
Message-ID: <20070831144227.GA25830@janus>
References: <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188535485.6626.85.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org> <1188536658.6626.98.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302215280.25853@woody.linux-foundation.org> <20070831074028.GR21979@unthought.net> <alpine.LFD.0.999.0708310055010.25853@woody.linux-foundation.org> <1188562298.6649.39.camel@heimdal.trondhjem.org> <20070831131226.GA24084@janus> <1188568212.6649.75.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188568212.6649.75.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 09:50:12AM -0400, Trond Myklebust wrote:
> On Fri, 2007-08-31 at 15:12 +0200, Frank van Maarseveen wrote:
> 
> > IMHO I'd only consider returning EBUSY when trying to mount _exactly_
> > the same directory with different flags, not for arbitrary subtrees. The
> > client should preferably not be bothered with server side disk
> > partitioning (at least not beyond the obvious such as df output).
> 
> That is utterly inconsistent and confusing too.
> 
> If you have a filesystem "/foo" exported on the server "remote", then
> why should
> 
>         mount -oro remote:/foo
>         mount -orw remote:/foo/a
> 
> be allowed, but
> 
>         mount -oro remote:/foo
>         mount -orw remote:/foo
> 
> be forbidden?

I'm not arguing to forbid the second case but confronting the sysadmin
there with nosharedcache is much less likely to harm existing setups than
the first case. Let's consider the most likely intention. The first case
is probably used as:

	mount -oro remote:/foo		<path>/foo
	mount -orw remote:/foo/a	<path>/foo/a

and I don't see a real issue with that, sharedcache or not. Ditto with:

	mount -oro remote:/foo/a	<path>/a
	mount -orw remote:/foo/b	<path>/b

These are all typical use cases, without multiple views on the same
tree. But

	mount -oro remote:/foo		/foo1
	mount -orw remote:/foo		/foo2

is strange and much less likely.

-- 
Frank
