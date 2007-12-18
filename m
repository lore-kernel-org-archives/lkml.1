Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbXLRL2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbXLRL2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 06:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbXLRL2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 06:28:07 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:58622 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753720AbXLRL2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 06:28:06 -0500
Date: Tue, 18 Dec 2007 12:28:04 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>,
       Lachlan McIlroy <lachlan@sgi.com>, Peter Leckie <pleckie@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Important regression with XFS update for 2.6.24-rc6
Message-ID: <20071218112804.GA3069@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

As a follow-up to
<http://marc.info/?l=linux-kernel&m=119796120524618&w=2> (LKML seems
down right now so I am not linking to it), I have detected an important
problem with these two patches: after applying them by hand (downloaded
them raw from SGI's gitweb) on top of 2.6.24-rc5-git5 (they have not yet
been pulled into mainline by Linux as of this morning) for testing
purposes, I noticed upon reboot that "ls -l" on directories with many
files and subdirectories (around 5000 entries) takes several hundreds of
MB in RAM and then dies with "memory exhausted" error.

I also noticed that ldconfig takes a lot of time to complete, and
firefox seems also to eat much more memory than usual. Reverting the two
patches (going back to vanilla rc5-git5) makes these problems go away.
I am not able to test right now if only one of the patches is bogus or
if both of them are concerned.

As the symptoms are easy to reproduce, I guess this is some kind of
brown paper bag bug and will be easy for XFS experts to spot.


Best,

-- 
Damien Wyart
