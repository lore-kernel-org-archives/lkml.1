Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbYGOTrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbYGOTrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYGOTrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:47:12 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36006 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbYGOTrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:47:11 -0400
Date: Tue, 15 Jul 2008 13:47:06 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: Recursive directory accounting for size, ctime, etc.
In-reply-to: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ceph-devel@lists.sourceforge.net
Message-id: <20080715194706.GK6239@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 15, 2008  11:28 -0700, Sage Weil wrote:
> unique (?) recursive accounting 
> infrastructure that allows statistics about all metadata nested beneath a 
> point in the directory hierarchy to be efficiently propagated up the tree.  
> Currently this includes a file and directory count, total bytes (summation 
> over file sizes), and most recent inode ctime.

Interesting...

> Note that st_blocks is _not_ recursively defined, so 'du' still behaves as 
> expected.  If mounted with -o norbytes instead, the directory st_size is 
> the number of entries in the directory.

Is it possible to extract an environment variable from the process
in the kernel to decide what behaviour to have (e.g. like LS_COLORS)?

> The second interface takes advantage of the fact (?) that read() on a 
> directory is more or less undefined.  (Okay, that's not really true, but 
> it used to return encoded dirents or something similar, and more recently 
> returns -EISDIR.  As far as I know, no sane application expects meaningful 
> data from read() on a directory...)  So, assuming Ceph is mounted with -o 
> dirstat,

Hmm, what about just creating a virtual xattr that can be had with
getfattr user.dirstats?

>  - The 'rbytes' summation is over i_size, not blocks used.  That means 
> sparse files "appear" larger than the storage space they actually consume.

I'd think that in many cases it is more important to accumulate the
blocks count and not the size, since a single core file would throw
off the whole "hunt for the worst space consumer" approach.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

