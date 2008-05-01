Return-Path: <linux-kernel-owner+w=401wt.eu-S1761704AbYEACWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761704AbYEACWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbYEACWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:22:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33131 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001AbYEACWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:22:07 -0400
Date: Thu, 1 May 2008 03:21:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501022142.GP5882@ZenIV.linux.org.uk>
References: <20080429.190352.137408408.davem@davemloft.net> <20080430224610.GO8474@1wt.eu> <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org> <200805010242.36775.rjw@sisk.pl> <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org> <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 06:40:39PM -0700, Linus Torvalds wrote:

> Now, we do know that open-source code tends to be higher quality (along a 
> number of metrics) than closed source code, and my argument is that it's 
> not because of bike-shedding (aka code review), but simply because the 
> code is out there and available and visible.
 
Really?  And how, pray tell, being out there will magically improve the
code?  "With enough eyes all bugs are shallow" stuff out of ESR's arse?

FWIW, after the last month's flamefests I decided to actually do something
about review density of code in the areas I'm theoretically responsible
for.  Namely, do systematic review of core data structure handling (starting
with the place where most of the codepaths get into VFS - descriptor tables
and struct file), doing both blow-by-blow writeup on how that sort of things
is done and documentation of the life cycle/locking rules/assertions made
by code/etc.  I made one bad mistake that held the things back for quite
a while - sending heads-up for one of the worse bugs found in process to
never-sufficiently-damned vendor-sec.  The last time I'm doing that, TYVM...

Anyway, I'm going to get the notes on that stuff in order and put them in
the open.  I really hope that other folks will join the fun afterwards.
The goal is to get a coherent braindump that would be sufficient for
people new to the area wanting to understand and review VFS-related code -
both in the tree and in new patches.

files_struct/fdtable handling is mostly dealt with, struct file is only
partially done - unfortunately, struct file_lock has to be dealt with
before that and it's a (predictable) nightmare.  On the other end of
things, fs_struct is not really started, vfsmount review is partially
done, dentry/superblock/inode not even touched.

Even with what little had been covered... well, let's just say that it
caught quite a few fun turds.  With typical age around 3-4 years.  And
VFS is not the messiest part of the tree...
