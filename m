Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYBYL4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYBYL4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYBYL4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:56:00 -0500
Received: from ping.pong.ch ([212.103.71.101]:42348 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbYBYLz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:55:59 -0500
X-Greylist: delayed 1752 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2008 06:55:59 EST
Date: Mon, 25 Feb 2008 12:23:10 +0100
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
To: xfs-masters@oss.sgi.com
Cc: xfs@oss.sgi.com, johannes@sipsolutions.net, linux-kernel@vger.kernel.org
Subject: filesystem corruption on xfs after 2.6.25-rc1 (bisected, powerpc
	related?)
Message-ID: <20080225112310.GA5516@soziologie.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Since upgrading to 2.6.25-rc1 I see filesystem corruption on my XFS
filesystem. I can reproduce this by doing "git reset --hard v2.6.25-rc1"
on a git checkout which is on some other revision. Git outputs strange
error messages (like file xxx is a directory when xxx really is a file)
and sometimes the filesystem "hangs" (I can no longer do any operations
on it even from another shell). If I reboot with a working kernel and
check the filesystem xfs_check reports many errors. I also see the
problem when doing other (not related to git) operations on the
filesystem. Git reset is just the easiest way to reproduce it.

I was able to track this corruption down to commit
a69b176df246d59626e6a9c640b44c0921fa4566 ([XFS] Use the generic bitops
rather than implementing them ourselves.) using git bisect.

Reverting edd319dc527733e61eec5bdc9ce20c94634b6482 ([XFS] Fix
xfs_lowbit64) to avoid merge conflicts and the faulty commit on top of
2.6.25-rc3 fixes the problem.

My filesystem is on an LVM2 logical volume and my computer is a
PowerBook G4 (model 5,8). I'm using GCC 4.2.3.

My problem is similar to the problem Johannes Berg reported in:
http://oss.sgi.com/archives/xfs/2008-02/msg00244.html

AFAIK Johannes also uses a PowerBook. Maybe this is an endianness
issue.

Gaudenz

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
