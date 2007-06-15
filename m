Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbXFOWX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbXFOWX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbXFOWXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:23:48 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:57846
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948AbXFOWXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:23:47 -0400
Message-ID: <46731169.2090002@hawkeye.stone.uk.eu.org>
Date: Fri, 15 Jun 2007 23:23:37 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Versioning file system
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I hope I got the CC list right. Apologies to anyone in didn't include
and anyone I shouldn't have included.

The basic idea is to include an idea from VMS that seems to be quite
useful: version numbers for files.

The idea is that whenever you modify a file the system saves it to na
new copy leaving the old file intact. This could be a great advantage
from many view points:
	1) it would be much easier to do package management as the old
		version would be automatically saved for a package
		management system to deal with.

	2) backups would also be easier as all versions of a file
		are automatically saved so it could be potentially very
		useful for a company or the like.

There are probably many others but these were the two that I liked best.

Revision numbers could be specified as follows:
	/path/to/file:revision_number


I think that this can be done without breaking userspace if the default
was to open the highest revision file if no revision number is
specified. The userspace tools would need to be updated to take full
advantage of the new system but if the delimiter between the path and
revision number were chosen sensibly then the changes to most of
userspace would be minimal to non-existant.

Personally, I think that the bulk of the implementation could be in the
core fs code and the modifications to individual filesystems would be
minimal. The main implementation ideas I have (however, I am no kernel
expert =) are adding an extra field to struct file and struct inode
called int revision (as version is already taken) that would hold the
number of the file revision being accessed.

Another problem could be the increased usage of disk space. However if
only deltas from the first version were stored then this could cut down
on space, or if this were too slow to open a file then the deltas could
be off every tenth revision (ie 0,10,20,30... where 0,10,20... are full
copies of the file).

There would need to be a tool of some describtion to remove old
revisions but this should not be a major undertaking as it may be
something as simple as a new system call. This would have to be careful
to update any deltas that were affected by the removal of previous
revisions but that could be taken care of in kernel space.

Thanks to anyone who stuck with me this far =). I don't know how widely
useful this may be but that's the reason I posted before trying to code
anything. I would very much value any contributions even a reasoned NAK
as I'm still learning how kernel development works (and I would love any
implementation directions)

Jack
