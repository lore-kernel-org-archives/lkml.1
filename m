Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYEAFR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYEAFR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 01:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYEAFRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 01:17:50 -0400
Received: from mail.lang.hm ([64.81.33.126]:57623 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbYEAFRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 01:17:49 -0400
Date: Wed, 30 Apr 2008 22:19:25 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <20080501022142.GP5882@ZenIV.linux.org.uk>
Message-ID: <alpine.DEB.1.10.0804302216520.3013@asgard>
References: <20080429.190352.137408408.davem@davemloft.net> <20080430224610.GO8474@1wt.eu> <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org> <200805010242.36775.rjw@sisk.pl> <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org>
 <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org> <20080501022142.GP5882@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008, Al Viro wrote:

> FWIW, after the last month's flamefests I decided to actually do something
> about review density of code in the areas I'm theoretically responsible
> for.  Namely, do systematic review of core data structure handling (starting
> with the place where most of the codepaths get into VFS - descriptor tables
> and struct file), doing both blow-by-blow writeup on how that sort of things
> is done and documentation of the life cycle/locking rules/assertions made
> by code/etc.  I made one bad mistake that held the things back for quite
> a while - sending heads-up for one of the worse bugs found in process to
> never-sufficiently-damned vendor-sec.  The last time I'm doing that, TYVM...
>
> Anyway, I'm going to get the notes on that stuff in order and put them in
> the open.  I really hope that other folks will join the fun afterwards.
> The goal is to get a coherent braindump that would be sufficient for
> people new to the area wanting to understand and review VFS-related code -
> both in the tree and in new patches.

thank you, the lack of good documentation on the intent of the code has 
been a significant barrier for new people. it's (relativly) easy for a 
good programmer to look at the code and figure out how it does things, a 
bit harder to figure out what it does, but why it does it (and what it was 
actually _intended_ to do) is very hard to track down

> files_struct/fdtable handling is mostly dealt with, struct file is only
> partially done - unfortunately, struct file_lock has to be dealt with
> before that and it's a (predictable) nightmare.  On the other end of
> things, fs_struct is not really started, vfsmount review is partially
> done, dentry/superblock/inode not even touched.
>
> Even with what little had been covered... well, let's just say that it
> caught quite a few fun turds.  With typical age around 3-4 years.  And
> VFS is not the messiest part of the tree...

it may not be the messiest part of the tree, but it's definantly one of 
the hardest to figure out the intent of.

David Lang
