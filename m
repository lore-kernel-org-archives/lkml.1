Return-Path: <linux-kernel-owner+w=401wt.eu-S1759647AbYBIAGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbYBIAGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYBIAGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:06:33 -0500
Received: from twin.jikos.cz ([213.151.79.26]:37467 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbYBIAGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:06:32 -0500
Date: Sat, 9 Feb 2008 01:05:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Adrian Bunk <bunk@kernel.org>
cc: Miklos Szeredi <mszeredi@suse.cz>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: uml compile error
In-Reply-To: <20080208223228.GD6505@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0802090102590.30873@twin.jikos.cz>
References: <20080208223228.GD6505@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Adrian Bunk wrote:

> Commit dd2cc4dff3b08ab54c4c177a080046bcc84ac41d broke uml:
> <-- snip  -->
> ...
>   CC      fs/hostfs/hostfs_kern.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/hostfs/hostfs_kern.c: In function 'hostfs_show_options':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/hostfs/hostfs_kern.c:328: error: dereferencing pointer to incomplete type
> make[3]: *** [fs/hostfs/hostfs_kern.o] Error 1

I guess we need this one?



From: Jiri Kosina <jkosina@suse.cz>

UML: fix hostfs build

We need to include mount.h to get vfsmount.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index d0549cb..5222345 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -12,6 +12,7 @@
 #include <linux/pagemap.h>
 #include <linux/statfs.h>
 #include <linux/seq_file.h>
+#include <linux/mount.h>
 #include "hostfs.h"
 #include "init.h"
 #include "kern.h"
