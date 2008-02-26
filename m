Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbYBZDYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbYBZDYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbYBZDYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:24:35 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53423 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbYBZDYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:24:34 -0500
X-Sasl-enc: JIucF9Z6D0cjPonKcivj0v/jtsVAzqampfZRqvJKOzlo 1203996273
Date: Tue, 26 Feb 2008 12:21:58 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/4] autofs4 - autofs needs a miscelaneous device for ioctls
Message-ID: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

There is a problem with active restarts in autofs (that is to
say restarting autofs when there are busy mounts).

Currently autofs uses "umount -l" to clear active mounts at
restart. While using lazy umount works for most cases, anything
that needs to walk back up the mount tree to construct a path,
such as getcwd(2) and the proc file system /proc/<pid>/cwd, no
longer works because the point from which the path is constructed
has been detached from the mount tree.

The actual problem with autofs is that it can't reconnect to
existing mounts. Immediately one things of just adding the
ability to remount autofs file systems would solve it, but
alas, that can't work. This is because autofs direct mounts
and the implementation of "on demand mount and expire" of
nested mount trees have the file system mounted on top of
the mount trigger dentry.

To resolve this a miscellaneous device node for routing ioctl
commands to these mount points has been implemented for the
autofs4 kernel module.

For those wishing to test this out an updated user space daemon
is needed. Checking out and building from the git repo or
applying all the current patches to the 5.0.3 tar distribution
will do the trick. This is all available at the usual location
on kernel.org.

Ian
