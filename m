Return-Path: <linux-kernel-owner+w=401wt.eu-S932137Ab0AEUpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab0AEUpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541Ab0AEUpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:45:10 -0500
Received: from [206.15.93.42] ([206.15.93.42]:21187 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755504Ab0AEUpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:45:09 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/dcache.c: CodingStyle cleanup
Date: Tue, 5 Jan 2010 13:45:18 -0700
Cc: linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001051345.18553.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup EXPORT* macros according to Documantation/CodingStyle.

Move EXPORT* macros to the line immediately after the closing
function brace.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/fs/dcache.c b/fs/dcache.c
index 953173a..4365998 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -257,6 +257,7 @@ kill_it:
 	if (dentry)
 		goto repeat;
 }
+EXPORT_SYMBOL(dput);
 
 /**
  * d_invalidate - invalidate a dentry
@@ -314,6 +315,7 @@ int d_invalidate(struct dentry * dentry)
 	spin_unlock(&dcache_lock);
 	return 0;
 }
+EXPORT_SYMBOL(d_invalidate);
 
 /* This should be called _only_ with dcache_lock held */
 
@@ -328,6 +330,7 @@ struct dentry * dget_locked(struct dentry *dentry)
 {
 	return __dget_locked(dentry);
 }
+EXPORT_SYMBOL(dget_locked);
 
 /**
  * d_find_alias - grab a hashed alias of inode
@@ -384,6 +387,7 @@ struct dentry * d_find_alias(struct inode *inode)
 	}
 	return de;
 }
+EXPORT_SYMBOL(d_find_alias);
 
 /*
  *	Try to kill dentries associated with this inode.
@@ -408,6 +412,7 @@ restart:
 	}
 	spin_unlock(&dcache_lock);
 }
+EXPORT_SYMBOL(d_prune_aliases);
 
 /*
  * Throw away a dentry - free the inode, dput the parent.  This requires that
@@ -610,6 +615,7 @@ void shrink_dcache_sb(struct super_block * sb)
 {
 	__shrink_dcache_sb(sb, NULL, 0);
 }
+EXPORT_SYMBOL(shrink_dcache_sb);
 
 /*
  * destroy a single subtree of dentries for unmount
@@ -792,6 +798,7 @@ positive:
 	spin_unlock(&dcache_lock);
 	return 1;
 }
+EXPORT_SYMBOL(have_submounts);
 
 /*
  * Search the dentry child list for the specified parent,
@@ -876,6 +883,7 @@ void shrink_dcache_parent(struct dentry * parent)
 	while ((found = select_parent(parent)) != 0)
 		__shrink_dcache_sb(sb, &found, 0);
 }
+EXPORT_SYMBOL(shrink_dcache_parent);
 
 /*
  * Scan `nr' dentries and return the number which remain.
@@ -968,6 +976,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 
 	return dentry;
 }
+EXPORT_SYMBOL(d_alloc);
 
 struct dentry *d_alloc_name(struct dentry *parent, const char *name)
 {
@@ -1012,6 +1021,7 @@ void d_instantiate(struct dentry *entry, struct inode * inode)
 	spin_unlock(&dcache_lock);
 	security_d_instantiate(entry, inode);
 }
+EXPORT_SYMBOL(d_instantiate);
 
 /**
  * d_instantiate_unique - instantiate a non-aliased dentry
@@ -1108,6 +1118,7 @@ struct dentry * d_alloc_root(struct inode * root_inode)
 	}
 	return res;
 }
+EXPORT_SYMBOL(d_alloc_root);
 
 static inline struct hlist_head *d_hash(struct dentry *parent,
 					unsigned long hash)
@@ -1225,6 +1236,7 @@ struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
 		d_add(dentry, inode);
 	return new;
 }
+EXPORT_SYMBOL(d_splice_alias);
 
 /**
  * d_add_ci - lookup or allocate new dentry with case-exact name
@@ -1314,6 +1326,7 @@ err_out:
 	iput(inode);
 	return ERR_PTR(error);
 }
+EXPORT_SYMBOL(d_add_ci);
 
 /**
  * d_lookup - search for a dentry
@@ -1357,6 +1370,7 @@ struct dentry * d_lookup(struct dentry * parent, struct qstr * name)
 	} while (read_seqretry(&rename_lock, seq));
 	return dentry;
 }
+EXPORT_SYMBOL(d_lookup);
 
 struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
 {
@@ -1483,6 +1497,7 @@ int d_validate(struct dentry *dentry, struct dentry *dparent)
 out:
 	return 0;
 }
+EXPORT_SYMBOL(d_validate);
 
 /*
  * When a file is deleted, we have two options:
@@ -1528,6 +1543,7 @@ void d_delete(struct dentry * dentry)
 
 	fsnotify_nameremove(dentry, isdir);
 }
+EXPORT_SYMBOL(d_delete);
 
 static void __d_rehash(struct dentry * entry, struct hlist_head *list)
 {
@@ -1556,6 +1572,7 @@ void d_rehash(struct dentry * entry)
 	spin_unlock(&entry->d_lock);
 	spin_unlock(&dcache_lock);
 }
+EXPORT_SYMBOL(d_rehash);
 
 /*
  * When switching names, the actual string doesn't strictly have to
@@ -1702,6 +1719,7 @@ void d_move(struct dentry * dentry, struct dentry * target)
 	d_move_locked(dentry, target);
 	spin_unlock(&dcache_lock);
 }
+EXPORT_SYMBOL(d_move);
 
 /**
  * d_ancestor - search for an ancestor
@@ -1868,6 +1886,7 @@ shouldnt_be_hashed:
 	spin_unlock(&dcache_lock);
 	BUG();
 }
+EXPORT_SYMBOL_GPL(d_materialise_unique);
 
 static int prepend(char **buffer, int *buflen, const char *str, int namelen)
 {
@@ -2005,6 +2024,7 @@ char *d_path(const struct path *path, char *buf, int buflen)
 	path_put(&root);
 	return res;
 }
+EXPORT_SYMBOL(d_path);
 
 /*
  * Helper function for dentry_operations.d_dname() members
@@ -2228,6 +2248,7 @@ ino_t find_inode_number(struct dentry *dir, struct qstr *name)
 	}
 	return ino;
 }
+EXPORT_SYMBOL(find_inode_number);
 
 static __initdata unsigned long dhash_entries;
 static int __init set_dhash_entries(char *str)
@@ -2297,6 +2318,7 @@ static void __init dcache_init(void)
 
 /* SLAB cache for __getname() consumers */
 struct kmem_cache *names_cachep __read_mostly;
+EXPORT_SYMBOL(names_cachep);
 
 EXPORT_SYMBOL(d_genocide);
 
@@ -2326,26 +2348,3 @@ void __init vfs_caches_init(unsigned long mempages)
 	bdev_cache_init();
 	chrdev_init();
 }
-
-EXPORT_SYMBOL(d_alloc);
-EXPORT_SYMBOL(d_alloc_root);
-EXPORT_SYMBOL(d_delete);
-EXPORT_SYMBOL(d_find_alias);
-EXPORT_SYMBOL(d_instantiate);
-EXPORT_SYMBOL(d_invalidate);
-EXPORT_SYMBOL(d_lookup);
-EXPORT_SYMBOL(d_move);
-EXPORT_SYMBOL_GPL(d_materialise_unique);
-EXPORT_SYMBOL(d_path);
-EXPORT_SYMBOL(d_prune_aliases);
-EXPORT_SYMBOL(d_rehash);
-EXPORT_SYMBOL(d_splice_alias);
-EXPORT_SYMBOL(d_add_ci);
-EXPORT_SYMBOL(d_validate);
-EXPORT_SYMBOL(dget_locked);
-EXPORT_SYMBOL(dput);
-EXPORT_SYMBOL(find_inode_number);
-EXPORT_SYMBOL(have_submounts);
-EXPORT_SYMBOL(names_cachep);
-EXPORT_SYMBOL(shrink_dcache_parent);
-EXPORT_SYMBOL(shrink_dcache_sb);
