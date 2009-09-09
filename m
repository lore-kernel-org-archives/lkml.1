Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZIIVPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZIIVPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZIIVPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:15:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195AbZIIVPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:15:40 -0400
Date: Wed, 9 Sep 2009 14:15:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Valdis.Kletnieks@vt.edu, hugh.dickins@tiscali.co.uk, miklos@szeredi.hu,
       matthew@wil.cx, agruen@suse.de, viro@zeniv.linux.org.uk, hch@lst.de,
       linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [patch 1/2] vfs: seq_file: add helpers for data filling
Message-Id: <20090909141500.5f635c56.akpm@linux-foundation.org>
In-Reply-To: <E1MkZk0-00006N-So@pomaz-ex.szeredi.hu>
References: <2818.1252160549@turing-police.cc.vt.edu>
	<1252312254.4733.12.camel@tucsk>
	<E1MkZk0-00006N-So@pomaz-ex.szeredi.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Sep 2009 10:38:24 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> Add two helpers that allow access to the seq_file's own buffer, but
> hides the internal details of seq_files.
> 
> This allows easier implementation of special purpose filling
> functions.  It also cleans up some existing functions which duplicated
> the seq_file logic.

This patch conflicts with
seq_file-return-a-negative-error-code-when-seq_path_root-fails.patch,
below.

I reworked your patch so that it removes the effects of
seq_file-return-a-negative-error-code-when-seq_path_root-fails.patch
and so that your patch is staged after
seq_file-return-a-negative-error-code-when-seq_path_root-fails.patch.

Your patch appears to fix the same thing as
seq_file-return-a-negative-error-code-when-seq_path_root-fails.patch,
so I _could_ have just dropped
seq_file-return-a-negative-error-code-when-seq_path_root-fails.patch. 
However it's unclear to me at thsi stage that your patch will be
merged.


I have a mountain of VFS patches piled up here:

vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-improve-comment-describing-fget_light.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-inodec-add-dev-id-and-inode-number-for-debugging-in-init_special_inode.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
vfs-optimization-for-touch_atime.patch
vfs-optimize-touch_time-too.patch
vfs-optimize-touch_time-too-fix.patch
ecryptfs-another-lockdep-issue.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
#vfs-fix-d_path-for-unreachable-paths.patch: Valdis.Kletnieks@vt.edu issues
fs-remove-unneeded-dcache_unhashed-tricks.patch
fs-improve-remountro-vs-buffercache-coherency.patch
fs-improve-remountro-vs-buffercache-coherency-fix.patch
#
#
#fs-new-truncate-helpers.patch and friends: TBU?
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
#ext2-convert-to-use-the-new-truncate-convention.patch: Jan wanted update. Nick agreed
ext2-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention-fix.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
#
seq_file-return-a-negative-error-code-when-seq_path_root-fails.patch
vfs-seq_file-add-helpers-for-data-filling.patch
vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints.patch


We're going to have to work out what to do if viro remains disappeared. I
guess I'll just send them all out to you guys to review during the merge
window and we'll go through them.





From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

seq_path_root() is returning a return value of successful __d_path()
instead of returning a negative value when mangle_path() failed.

This is not a bug so far because nobody is using return value of
seq_path_root().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/seq_file.c~seq_file-return-a-negative-error-code-when-seq_path_root-fails fs/seq_file.c
--- a/fs/seq_file.c~seq_file-return-a-negative-error-code-when-seq_path_root-fails
+++ a/fs/seq_file.c
@@ -470,6 +470,7 @@ int seq_path_root(struct seq_file *m, st
 				m->count = s - m->buf;
 				return 0;
 			}
+			err = -ENAMETOOLONG;
 		}
 	}
 	m->count = m->size;
_

