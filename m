Return-Path: <linux-kernel-owner+w=401wt.eu-S1750706AbXCCXB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750706AbXCCXB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 18:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbXCCXB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 18:01:59 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:59888 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbXCCXB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 18:01:57 -0500
Date: Sun, 4 Mar 2007 00:01:55 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-ID: <20070303230155.GA475@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
References: <20070303122935.f1ab0067.akpm@linux-foundation.org> <45E9DD4A.2060806@redhat.com> <20070303131204.6706a95c.akpm@linux-foundation.org> <45E9E910.2070804@redhat.com> <20070303214108.GA28961@outpost.ds9a.nl> <20070303141448.1ed70e6d.akpm@linux-foundation.org> <45E9F454.2080600@redhat.com> <20070303142609.d3bc9cc3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070303142609.d3bc9cc3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 02:26:09PM -0800, Andrew Morton wrote:
> > > It is *not* a global instruction.  It uses setenv, so the user's policy
> > > affects only the target process and its forked children.
> > 
> > ... and all other processes accessing the same file(s)!
> > 
> > Your library and the system calls may be limited to one process,
> > but the consequences are global.
> 
> Yes.  So what?  If the user wants to go and evict libc.so from pagecache
> then he can do so - the kernel has provided syscalls with which this can be
> done for at least seven years.  Bad user, shouldn't do that.

While I agree with your sentiments that userspace can have a good idea on
how to deal with the page cache, your program does more than it claims to
do - because of how linux implements posix_fadvise.

I don't think anybody expects or desires your program to actually *evict*
the stuff from the cache you are trying access, which happens in case the
data was in the cache prior to starting your program.

What people expect is that a solution such as you wrote it simply won't
*add* anything to the cache. They don't expect it will actually globally
*remove* stuff from the cache.

Making a backup this way would hurt even worse than usual with your
pagecache management tool if the file being backupped was still being read.

This is not your fault, but in practice, it makes your program less useful
than it could be.

One could conceivably fix that up using mincore and simply not fadvise if a
page was in core already.

	Bert
-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
