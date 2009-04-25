Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZDYB3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZDYB3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZDYB2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:28:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38451 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbZDYB2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:47 -0400
Message-Id: <20090425012020.457460929@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:20 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/27] [rfc] vfs scalability patchset
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my current patchset for improving vfs locking scalability. Since
last posting, I have fixed several bugs, solved several more problems, and
done an initial sweep of filesystems (autofs4 is probably the trickiest,
and unfortunately I don't have a good test setup here for that yet, but
at least I've looked through it).

Also started to tackle files_lock, vfsmount_lock, and inode_lock.
(I included my mnt_want_write patches before the vfsmount_lock scalability
stuff because that just made it a bit easier...). These appear to be the
problematic global locks in the vfs.

It's running stably here so far on basic stress testing here on several file
systems (xfs, tmpfs, ext?). But it still might eat your data of course.

Would be very interested in any feedback.

Thanks,
Nick


