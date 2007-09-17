Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXIQS1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXIQS1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbXIQS1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43828 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbXIQS1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:22 -0400
Subject: [PATCH 00/24] Read-only bind mounts
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 17 Sep 2007 11:27:18 -0700
Message-Id: <20070917182718.70494C9B@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we can't pull the entire series into -mm, can we just put the
first three patches for now?  They can stand on their own.

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
your filesystem read-only (such as when you don't trust your
FTP server), when you don't want to have entire new filesystems
mounted, or when you want atime selectively updated.
I've been using the following script to test that the feature is
working as desired.  It takes a directory and makes a regular
bind and a r/o bind mount of it.  It then performs some normal
filesystem operations on the three directories, including ones
that are expected to fail, like creating a file on the r/o
mount.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
