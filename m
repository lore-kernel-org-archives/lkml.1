Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbYFCUwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbYFCUwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYFCUwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:52:35 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51635 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYFCUwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:52:32 -0400
Date: Tue, 03 Jun 2008 14:52:20 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: Correct EXT3_TOPDIR_FL behaviour
In-reply-to: <e9e943910806021727h111b0e57qeea0032d164e0ffb@mail.gmail.com>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20080603205220.GG2961@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <e9e943910806021727h111b0e57qeea0032d164e0ffb@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 03, 2008  01:27 +0100, Duane Griffin wrote:
> I'm looking at http://bugzilla.kernel.org/show_bug.cgi?id=9866, where
> the reporter is claiming that EXT3_TOPDIR_FL (chattr +T) is behaving
> incorrectly by being inherited from the parent. As mentioned in the
> bug, it also only seems to only make sense for directories but
> ext{2,3,4} is happy to set it on anything. It seems to me that the
> reporter is correct and the behaviour should be changed to prevent the
> flag being inherited and to limit it to directories only. If there is
> no disagreement I'll follow-up with patches accordingly.

Yes, this is a problem that was mentioned previously, and hasn't been
fixed yet.  The TOPDIR_FL shouldn't be inherited, similar to the
non-inheritance of INDEX_FL and EXTENTS_FL.

It could be argued pretty easily that inheriting flags is usually wrong,
and that we should instead specify which flags SHOULD be inherited,
instead of repeatedly fixing bugs like this.

Flags that I would propose should be inherited from directories to
regular files and subdirectories are: SECRM, UNRM, SYNC, APPEND, NODUMP,
NOATIME, COMPR, NOCOMPR, JOURNAL_DATA, NOTAIL, and DIRSYNC, EXTENTS.
I'm not sure what the semantics of IMMUTABLE on a directory are, whether
it is even possible to create a new file in such a directory, but by
principle of least surprise it should probably be inherited.

Flags that definitely do not make sense to be inherited are: DIRTY, ECOMPR,
INDEX, IMAGIC, TOPDIR, HUGE_FILE.

Flags that don't make sense to be set on non-file/dir inodes are: DIRTY,
ECOMPR, INDEX, SECRM, UNRM, SYNC, APPEND, COMPR, NOCOMPR, JOURNAL_DATA,
NOTAIL, DIRSYNC, TOPDIR, EXTENTS, HUGE_FILE (used for files > 2TB).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

