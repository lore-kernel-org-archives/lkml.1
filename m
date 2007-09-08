Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbXIHRWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbXIHRWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 13:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXIHRW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 13:22:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:41296 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbXIHRW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 13:22:28 -0400
Date: Sat, 8 Sep 2007 17:22:27 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.35.2
Message-ID: <20070908172227.GA6308@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.4.35.2.

The removal of -fno-unit-at-a-time in 2.4.35.1 in order to fix build
with gcc-4.2 uncovered nasty optimization issues in the current code
under gcc-4.x. This option not only prevents gcc from reordering
sections, it also prevents it from doing a better optimization of some
inlinable functions and from stripping out static variables which
apparently never get assigned.

Since the removal of the option, some users were caught by modules
which had no symbol for certain parameters ; this is a very annoying
regression which forced them to go back to 2.4.34.x.

So I have restored -fno-unit-at-a-time for now, and yes, it *will* break
gcc-4.2. But the breakage will be detected at build time now, and people
will not get randomly working modules. I am currently exploring several
solutions to this issue, one of them consisting in fixing broken modules
since -fno-unit-at-a-time is already deprecated. If I find something
reasonably non-intrusive, I will consider it for 2.4.36-pre.

Right now, I expect 2.4.35.2 to be safe for gcc-4.1 users.

Willy
--

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.35.2.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.35.2

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.35.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.35.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.35.y.git



Summary of changes from v2.4.35.1 to v2.4.35.2
============================================

Willy Tarreau (3):
      i386: do_test_wp_bit() must not be inlined
      restore -fno-unit-at-a-time on GCC >= 4
      Change VERSION to 2.4.35.2

