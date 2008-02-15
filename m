Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbYBOWjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbYBOWjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762484AbYBOWhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:37 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39143 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760835AbYBOWhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:32 -0500
Subject: [PATCH 00/30] Read-only bind mounts (-mm resend)
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:21 -0800
Message-Id: <20080215223721.9E0A088A@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against current Linus git.

Miklos, if you send me a copy of your current unprivledged mount
code merged against mainline, I'll merge with this.

git://git.kernel.org/pub/scm/linux/kernel/git/daveh/linux-2.6-robind.git

This rolls up all the -mm bugfixes that were accumulated, and
addresses some new review comments from Al.  Also contains some
reworking from hch and a patch from Jeff Dike.

Just posting here to let everyone have a sniff before we resend
it back to -mm.

---

Why do we need r/o bind mounts?

This feature allows a read-only view into a read-write filesystem.
In the process of doing that, it also provides infrastructure for
keeping track of the number of writers to any given mount.

This has a number of uses.  It allows chroots to have parts of
filesystems writable.  It will be useful for containers in the future
because users may have root inside a container, but should not
be allowed to write to somefilesystems.  This also replaces 
patches that vserver has had out of the tree for several years.

It allows security enhancement by making sure that parts of
your filesystem are read-only (such as when you don't trust your
FTP server), when you don't want to have entire new filesystems
mounted, or when you want atime selectively updated.
I've been using this script:

	http://sr71.net/~dave/linux/robind-test.sh

to test that the feature is working as desired.  It takes a
directory and makes a regular bind and a r/o bind mount of it.
It then performs some normal filesystem operations on the
three directories, including ones that are expected to fail,
like creating a file on the r/o mount.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
