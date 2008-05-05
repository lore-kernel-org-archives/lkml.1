Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbYEEN6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbYEEN6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYEEN5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:57:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50471 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbYEEN5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:57:51 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, menage@google.com
In-reply-to: <20080505134617.GA18472@infradead.org> (message from Christoph
	Hellwig on Mon, 5 May 2008 09:46:17 -0400)
Subject: Re: [patch 03/15] cgroup: dont call vfs_mkdir
References: <20080505095440.820370974@szeredi.hu> <20080505095511.217634550@szeredi.hu> <20080505110016.GC20910@infradead.org> <E1Jszri-0005uq-4x@pomaz-ex.szeredi.hu> <20080505130804.GA1809@infradead.org> <E1Jt0l8-00066L-NC@pomaz-ex.szeredi.hu> <20080505133322.GA14370@infradead.org> <E1Jt0yf-00069Q-1M@pomaz-ex.szeredi.hu> <20080505134617.GA18472@infradead.org>
Message-Id: <E1Jt1CK-0006CN-NN@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 05 May 2008 15:57:44 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well, I'd hardly call this whole patchset messing up the kernel, and
> > you seemed to agree with most of the patches.
> 
> Of course.  Good patches will always again, but preparing for apparmor
> is not an excuse for bad patches.

It's not an excuse.  It's one of *several* reasons for why the patches
are good.  And no, "help *cleanly* integrate AA" is not a reason
against patches.

Please try to keep your arguments technical (like code duplication in
reiserfs, etc), which are perfectly valid.  I don't like the reiserfs
duplication, but as I've said, it's needed anyway for some other
reason.  I can dig out the original patch and include the description
in this one if that helps.

And yes, all these are cleanups.  Recursing into the vfs_ functions
from inside the filesystems is plain wrong most of the time.

For example fsnotify_change() call in fat_generic_ioctl() would
actually *break* after the IS_IMMUTABLE() cleanups, because it's
actually calling this function before changing the "SYS" attribute
(which is interpreted as immutable) on the inode.  So without this
cleanup that notify_change() would always fail.

Miklos
