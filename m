Return-Path: <linux-kernel-owner+w=401wt.eu-S1762450AbZBECiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450AbZBECiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZBEChv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:37:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbZBEChu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:37:50 -0500
Date: Wed, 4 Feb 2009 18:36:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arthur Jones <ajones@riverbed.com>, C Sights <csights@fastmail.fm>,
       Eric Sandeen <sandeen@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #12224] journal activity on inactive partition causes
 inactive harddrive spinup
Message-Id: <20090204183654.4c6cbf63.akpm@linux-foundation.org>
In-Reply-To: <20090205020013.GG8945@mit.edu>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
	<CGyEB0S4BpO.A.haD.S6YiJB@chimera>
	<20090205020013.GG8945@mit.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 21:00:13 -0500 Theodore Tso <tytso@mit.edu> wrote:

> On Wed, Feb 04, 2009 at 11:58:33AM +0100, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12224
> > Subject		: journal activity on inactive partition causes inactive harddrive spinup
> > Submitter	: C Sights <csights@fastmail.fm>
> > Date		: 2008-12-14 11:39 (53 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c87591b719737b4e91eb1a9fa8fd55a4ff1886d6
> > Handled-By	: Eric Sandeen <sandeen@redhat.com>
> 
> Patches against ext3 have been posted by Jan Kara and have been sucked
> into the mm tree.  I don't know if Andrew is planning on waiting until
> the next merge window, or is planning on pushing it sooner given that
> it is a regression.

Yes, I have jbd-fix-return-value-of-journal_start_commit.patch and
revert-ext3-wait-on-all-pending-commits-in-ext3_sync_fs.patch queued
for 2.6.29.

The secret algorithm for determining this is to peek in the series file
(http://userweb.kernel.org/~akpm/mmotm/series) and see where I positioned the
patch:

   #
-> # more 2.6.29 queue:
   #
   # me:
   #
   migration-migrate_vmas-should-check-vma.patch
   rtc-update-maintainership-of-pxa-rtc-driver.patch
   lxfb-properly-alloc-cmap-in-all-cases-and-dont-leak-the-memory.patch
   gxfb-properly-alloc-cmap-and-plug-cmap-leak.patch
   gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch
   mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches.patch
   mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches-fix.patch
-> jbd-fix-return-value-of-journal_start_commit.patch
-> revert-ext3-wait-on-all-pending-commits-in-ext3_sync_fs.patch
   writeback-fix-nr_to_write-counter.patch
   
   
