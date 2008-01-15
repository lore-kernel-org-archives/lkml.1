Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYAORGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYAORGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYAORF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:05:58 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:12323 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYAORF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:05:57 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2008 12:05:56 EST
Date: Tue, 15 Jan 2008 11:55:55 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Chris Mason <chris.mason@oracle.com>
Cc: btrfs-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs v0.10 (online growing/shrinking, ext3
	conversion, and more)
Message-ID: <20080115165555.GA7164@phobos.i.cabal.ca>
References: <20080115105238.4fc3e992@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115105238.4fc3e992@think.oraclecorp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 10:52:38AM -0500, Chris Mason wrote:
> http://oss.oracle.com/projects/btrfs/
> 
> Btrfs is still in an early alpha state, and the disk format is not finalized.
> v0.10 introduces a new disk format, and is not compatible with v0.9.
> 

Looks like fun. btrfsck fails to check if it actually received a
dev argument though, so if you don't pass a device, we get a nice
segfault.

Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>

---
diff -Nur btrfs-progs-0.10/btrfsck.c btrfs-progs-0.10-kyle/btrfsck.c
--- btrfs-progs-0.10/btrfsck.c	2008-01-15 10:33:32.000000000 -0500
+++ btrfs-progs-0.10-kyle/btrfsck.c	2008-01-15 11:49:24.000000000 -0500
@@ -709,6 +709,11 @@
 	return err;
 }
 
+void print_usage(void) {
+	fprintf(stderr, "usage: btrfsck dev\n");
+	exit(1);
+}
+
 int main(int ac, char **av) {
 	struct btrfs_root *root;
 	struct cache_tree extent_cache;
@@ -727,6 +732,9 @@
 	int slot;
 	struct btrfs_root_item ri;
 
+	if (ac < 2)
+		print_usage();
+
 	radix_tree_init();
 	cache_tree_init(&extent_cache);
 	cache_tree_init(&seen);
