Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYLVXUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYLVXUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYLVXUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:20:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54088 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbYLVXUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:20:42 -0500
Date: Mon, 22 Dec 2008 23:20:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "C. Scott Ananian" <cscott@laptop.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
Message-ID: <20081222232040.GP28946@ZenIV.linux.org.uk>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com> <c6d9bea0812181536p2a3aaeacmbd6af0474279b7b@mail.gmail.com> <1229916126.29604.47.camel@localhost.localdomain> <c6d9bea0812221159h30b0501dm8f48d93e0cb53bfa@mail.gmail.com> <20081222210410.GL28946@ZenIV.linux.org.uk> <c6d9bea0812221508n75f03ebdsff5bcbabe56eae56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6d9bea0812221508n75f03ebdsff5bcbabe56eae56@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 06:08:08PM -0500, C. Scott Ananian wrote:

> That's not correct, as /proc/self/fd/<num> and the getcwd syscall make
> clear.  struct inode has a i_dentry member, and via its d_parent links
> you can reconstruct the path, as __d_path in fs/dcache.c does.

Think for a minute

a) you might have any number of links to given inode, *including* *zero*
b) any subset of these links may be in dcache (including empty)
c) any number of bindings might exist to file in question *or* to its
ancestors (again, including zero).
d) none of the relative paths from fs root to file has to be visible
as a path leading to file in question from anywhere (again, think of
bindings)
e) all of that can change before information reaches userland.

> inotify *almost* lets us do that last thing (though the code
> duplication pains me) but is too racy for reliable use. Give me a
> kernel interface without races and I'll call it a good start.  If you
> can save me the trouble of duplicating all of the filesystem's
> directory information in my userspace database in order to handle
> directory moves, I'll actually grin a little.

_WHAT_ interface without races?  Anything along the lines of "somebody had
done something to <pathname>" is racy by definition.  Simply because the
next operation might have changed the mapping from pathnames to files.

What are you actually trying to do?
