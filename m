Return-Path: <linux-kernel-owner+w=401wt.eu-S1751136AbYBHW1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136AbYBHW1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYBHW0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:26:47 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54764 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbYBHW0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:26:46 -0500
Subject: [RFC][PATCH 00/30] Read-only bind mounts (-mm resend)
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, viro@ZenIV.linux.org.uk, viro@ftp.linux.org.uk,
       miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 08 Feb 2008 14:26:41 -0800
Message-Id: <20080208222641.6024A7CC@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against current Linus git
(a4ffc0a0b240a29cbe489f6db9dae112a49ef1c1).

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

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
