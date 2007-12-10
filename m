Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbXLJDjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbXLJDjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 22:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXLJDjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 22:39:35 -0500
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:43543 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbXLJDjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 22:39:35 -0500
X-Greylist: delayed 1098 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2007 22:39:35 EST
From: hooanon05@yahoo.co.jp
Subject: Re: [UNIONFS] 00/42 Unionfs and related patches review 
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Date: Mon, 10 Dec 2007 12:20:20 +0900
Message-Id: <E1J1ZBs-0006M0-VL@jroun>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Erez Zadok:
> (1) Cache coherency: by far, the biggest concern had been around cache
	:::
> unionfs.  The solution we have implemented is to compare the mtime/ctime of
> upper/lower objects during revalidation (esp. of dentries); and if the lower
> times are newer, we reconstruct the union object (drop the older objects,
> and re-lookup them).  This time-based cache-coherency works well and is
	:::

The resolution of mtime/ctime may be too low since some filesystems sets
them in unit of a second, which means you cannot detect the changes made
within a second.
I think it is better to use inotify for every directory while it
consumes a little more resources.
Additionally, if you implement vm_operations instead of
struggling along address_space_operations or VFS patches, in order to
share the mmap-ed memory pages between lower inode and unionfs inode,
then most of issues will be gone.
You can see this approach and how it is working in http://aufs.sf.net
(and get the source file from CVS).

But I am afraid the approach sharing memory pages will not be avaiable
for ecryptfs.


Junjiro Okajima
