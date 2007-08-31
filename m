Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbXHaHki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbXHaHki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 03:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbXHaHka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 03:40:30 -0400
Received: from unthought.net ([212.97.129.88]:50783 "EHLO unthought.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbXHaHk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 03:40:29 -0400
Date: Fri, 31 Aug 2007 09:40:28 +0200
From: Jakob Oestergaard <jakob@unthought.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
Message-ID: <20070831074028.GR21979@unthought.net>
Mail-Followup-To: Jakob Oestergaard <jakob@unthought.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Frank van Maarseveen <frankvm@frankvm.com>,
	Hua Zhong <hzhong@gmail.com>,
	'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org
References: <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188535485.6626.85.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org> <1188536658.6626.98.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302215280.25853@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708302215280.25853@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 10:16:37PM -0700, Linus Torvalds wrote:
> 
...
> > Why aren't we doing that for any other filesystem than NFS?
> 
> How hard is it to acknowledge the following little word:
> 
> 	"regression"
> 
> It's simple. You broke things. You may want to fix them, but you need to 
> fix them in a way that does not break user space.

Trond has a point Linus.

What he "broke" is, for example, a ro mount being mounted as rw.

That *could* be a very serious security (etc.etc.) problem which he just fixed.
Anything depending on read-only not being enforced will cease to work, of
course, and that is what a few people complain about(!).

If ext3 in some rare case (which would still mean it hit a few thousand users)
failed to remember that a file had been marked read-only and allowed writes to
it, wouldn't we want to fix that too?  It would cause regressions, but we'd fix
it, right?

mount passes back the error code on a failed mount. autofs passes that error
along too (when people configure syslog correctly). In short; when these
serious mistakes are made and caught, the admin sees an error in his logs.

This is not wrong. This is good.

-- 

 / jakob

