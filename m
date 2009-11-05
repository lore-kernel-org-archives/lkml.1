Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbZKETtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbZKETtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbZKETtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:49:05 -0500
Received: from THUNK.ORG ([69.25.196.29]:50736 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758362AbZKETtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:49:04 -0500
Date: Thu, 5 Nov 2009 14:48:58 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jim Meyering <jim@meyering.net>
Cc: Ulrich Drepper <drepper@gmail.com>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org
Subject: Re: make getdents/readdir POSIX compliant wrt mount-point
	dirent.d_ino
Message-ID: <20091105194858.GP6510@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jim Meyering <jim@meyering.net>, Ulrich Drepper <drepper@gmail.com>,
	Ulrich Drepper <drepper@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	bug-coreutils@gnu.org
References: <87y6oyhkz8.fsf@meyering.net> <20090901201943.GB6996@mit.edu> <a36005b50909011503y73efdf56yabc4d981db2989bc@mail.gmail.com> <87my32rsw3.fsf@meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87my32rsw3.fsf@meyering.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 08:29:00PM +0100, Jim Meyering wrote:
> One way to accommodate the current automount semantics, is to make fts.c
> incur, _for every directory traversed_, the cost of an additional
> stat (fstatat, actually) call just in case this happens to be one of
> those rare mount points.
> 
> I would really rather not pessimize most[*] hierarchy-traversing
> command-line tools by up to 17% (though usually far less) in order
> to accommodate device-number change semantics that arise
> for an automountable directory.

I must be missing something.  How do you come up with the 17% penalty
figure?  And what does this actually mean in real life?

stat() in Linux is fast.  Really fast.  A quick benchmark clocks
stat() on my system at 0.814 *microseconds* in the warm cache case,
and if you're stating a directory that you've traversed, odds are
extremely high that it will still be in the cache.

My entire laptop root filesystem has 53,934 directories, so an extra
stat() per directory translates to an extra 43 milliseconds, assuming
I needed to walk my entire root filesystem.  It's really hard to see
why kernel developers should get worked up into a lather over that
kind of "performance penalty".

Regards,

						- Ted
