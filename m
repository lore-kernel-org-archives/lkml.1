Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbZIYXsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbZIYXsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 19:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZIYXsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 19:48:03 -0400
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:48636 "HELO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751858AbZIYXsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 19:48:00 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] fs/dcache.c: CodingStyle cleanups
Date: Fri, 25 Sep 2009 19:48:07 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901D42773@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fs/dcache.c: CodingStyle cleanups
Thread-Index: Aco+OqHV4Wuf5l/jRK2tY4nwj7XSXg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>
X-OriginalArrivalTime: 25 Sep 2009 23:48:03.0383 (UTC) FILETIME=[9F392C70:01CA3E3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Fix whitespace issues where spaces are used instead of tabs.
2) Remove unnecessary extra whitespace.
3) Move EXPORT* macro's to the line immediately after the closing
   function brace line.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/fs/dcache.c b/fs/dcache.c
index a100fa3..cb023f3 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -38,7 +38,7 @@
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
- __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(dcache_lock);
@@ -211,7 +211,6 @@ static struct dentry *d_kill(struct dentry *dentry)
  *
  * no dcache lock, please.
  */
-
 void dput(struct dentry *dentry)
 {
 	if (!dentry)
@@ -238,13 +237,13 @@ repeat:
 			goto unhash_it;
 	}
 	/* Unreachable? Get rid of it */
- 	if (d_unhashed(dentry))
+	if (d_unhashed(dentry))
 		goto kill_it;
-  	if (list_empty(&dentry->d_lru)) {
-  		dentry->d_flags |= DCACHE_REFERENCED;
+	if (list_empty(&dentry->d_lru)) {
+		dentry->d_flags |= DCACHE_REFERENCED;
 		dentry_lru_add(dentry);
-  	}
- 	spin_unlock(&dentry->d_lock);
+	}
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 	return;
 
@@ -257,6 +256,7 @@ kill_it:
 	if (dentry)
 		goto repeat;
 }
+EXPORT_SYMBOL(dput);
 
 /**
  * d_invalidate - invalidate a dentry
@@ -269,7 +269,6 @@ kill_it:
  *
  * no dcache lock.
  */
- 
 int d_invalidate(struct dentry * dentry)
 {
 	/*
@@ -314,6 +313,7 @@ int d_invalidate(struct dentry * dentry)
 	spin_unlock(&dcache_lock);
 	return 0;
 }
+EXPORT_SYMBOL(d_invalidate);
 
 /* This should be called _only_ with dcache_lock held */
 
@@ -328,6 +328,7 @@ struct dentry * dget_locked(struct dentry *dentry)
 {
 	return __dget_locked(dentry);
 }
+EXPORT_SYMBOL(dget_locked);
 
 /**
  * d_find_alias - grab a hashed alias of inode
@@ -358,7 +359,7 @@ static struct dentry * __d_find_alias(struct inode *inode, int want_discon)
 		next = tmp->next;
 		prefetch(next);
 		alias = list_entry(tmp, struct dentry, d_alias);
- 		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
+		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
 			    (alias->d_flags & DCACHE_DISCONNECTED))
 				discon_alias = alias;
@@ -384,6 +385,7 @@ struct dentry * d_find_alias(struct inode *inode)
 	}
 	return de;
 }
+EXPORT_SYMBOL(d_find_alias);
 
 /*
  *	Try to kill dentries associated with this inode.
@@ -408,6 +410,7 @@ restart:
 	}
 	spin_unlock(&dcache_lock);
 }
+EXPORT_SYMBOL(d_prune_aliases);
 
 /*
  * Throw away a dentry - free the inode, dput the parent.  This requires that
@@ -610,6 +613,7 @@ void shrink_dcache_sb(struct super_block * sb)
 {
 	__shrink_dcache_sb(sb, NULL, 0);
 }
+EXPORT_SYMBOL(shrink_dcache_sb);
 
 /*
  * destroy a single subtree of dentries for unmount
@@ -746,7 +750,7 @@ void shrink_dcache_for_umount(struct super_block *sb)
  * We descend to the next level whenever the d_subdirs
  * list is non-empty and continue searching.
  */
- 
+
 /**
  * have_submounts - check for mounts over a dentry
  * @parent: dentry to check.
@@ -754,7 +758,6 @@ void shrink_dcache_for_umount(struct super_block *sb)
  * Return true if the parent or its subdirectories contain
  * a mount point
  */
- 
 int have_submounts(struct dentry *parent)
 {
 	struct dentry *this_parent = parent;
@@ -792,6 +795,7 @@ positive:
 	spin_unlock(&dcache_lock);
 	return 1;
 }
+EXPORT_SYMBOL(have_submounts);
 
 /*
  * Search the dentry child list for the specified parent,
@@ -867,7 +871,6 @@ out:
  *
  * Prune the dcache to remove unused children of the parent dentry.
  */
- 
 void shrink_dcache_parent(struct dentry * parent)
 {
 	struct super_block *sb = parent->d_sb;
@@ -876,6 +879,7 @@ void shrink_dcache_parent(struct dentry * parent)
 	while ((found = select_parent(parent)) != 0)
 		__shrink_dcache_sb(sb, &found, 0);
 }
+EXPORT_SYMBOL(shrink_dcache_parent);
 
 /*
  * Scan `nr' dentries and return the number which remain.
@@ -905,7 +909,7 @@ static struct shrinker dcache_shrinker = {
 };
 
 /**
- * d_alloc	-	allocate a dcache entry
+ * d_alloc - allocate a dcache entry
  * @parent: parent of entry to allocate
  * @name: qstr of the name
  *
@@ -913,7 +917,6 @@ static struct shrinker dcache_shrinker = {
  * available. On a success the dentry is returned. The name passed in is
  * copied and the copy passed in may be reused after this call.
  */
- 
 struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 {
 	struct dentry *dentry;
@@ -968,6 +971,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 
 	return dentry;
 }
+EXPORT_SYMBOL(d_alloc);
 
 struct dentry *d_alloc_name(struct dentry *parent, const char *name)
 {
@@ -1002,7 +1006,6 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
  * (or otherwise set) by the caller to indicate that it is now
  * in use by the dcache.
  */
- 
 void d_instantiate(struct dentry *entry, struct inode * inode)
 {
 	BUG_ON(!list_empty(&entry->d_alias));
@@ -1011,6 +1014,7 @@ void d_instantiate(struct dentry *entry, struct inode * inode)
 	spin_unlock(&dcache_lock);
 	security_d_instantiate(entry, inode);
 }
+EXPORT_SYMBOL(d_instantiate);
 
 /**
  * d_instantiate_unique - instantiate a non-aliased dentry
@@ -1079,7 +1083,6 @@ struct dentry *d_instantiate_unique(struct dentry *entry, struct inode *inode)
 	iput(inode);
 	return result;
 }
-
 EXPORT_SYMBOL(d_instantiate_unique);
 
 /**
@@ -1090,7 +1093,6 @@ EXPORT_SYMBOL(d_instantiate_unique);
  * instantiated and returned. %NULL is returned if there is insufficient
  * memory or the inode passed is %NULL.
  */
- 
 struct dentry * d_alloc_root(struct inode * root_inode)
 {
 	struct dentry *res = NULL;
@@ -1107,6 +1109,7 @@ struct dentry * d_alloc_root(struct inode * root_inode)
 	}
 	return res;
 }
+EXPORT_SYMBOL(d_alloc_root);
 
 static inline struct hlist_head *d_hash(struct dentry *parent,
 					unsigned long hash)
@@ -1224,6 +1227,7 @@ struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
 		d_add(dentry, inode);
 	return new;
 }
+EXPORT_SYMBOL(d_splice_alias);
 
 /**
  * d_add_ci - lookup or allocate new dentry with case-exact name
@@ -1313,6 +1317,7 @@ err_out:
 	iput(inode);
 	return ERR_PTR(error);
 }
+EXPORT_SYMBOL(d_add_ci);
 
 /**
  * d_lookup - search for a dentry
@@ -1342,7 +1347,6 @@ err_out:
  * d_lookup() is protected against the concurrent renames in some unrelated
  * directory using the seqlockt_t rename_lock.
  */
-
 struct dentry * d_lookup(struct dentry * parent, struct qstr * name)
 {
 	struct dentry * dentry = NULL;
@@ -1356,6 +1360,7 @@ struct dentry * d_lookup(struct dentry * parent, struct qstr * name)
 	} while (read_seqretry(&rename_lock, seq));
 	return dentry;
 }
+EXPORT_SYMBOL(d_lookup);
 
 struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
 {
@@ -1412,10 +1417,10 @@ struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
 		break;
 next:
 		spin_unlock(&dentry->d_lock);
- 	}
- 	rcu_read_unlock();
+	}
+	rcu_read_unlock();
 
- 	return found;
+	return found;
 }
 
 /**
@@ -1453,7 +1458,6 @@ out:
  * This is used by ncpfs in its readdir implementation.
  * Zero is returned in the dentry is invalid.
  */
- 
 int d_validate(struct dentry *dentry, struct dentry *dparent)
 {
 	struct hlist_head *base;
@@ -1482,6 +1486,7 @@ int d_validate(struct dentry *dentry, struct dentry *dparent)
 out:
 	return 0;
 }
+EXPORT_SYMBOL(d_validate);
 
 /*
  * When a file is deleted, we have two options:
@@ -1495,7 +1500,7 @@ out:
  * it from the hash queues and waiting for
  * it to be deleted later when it has no users
  */
- 
+
 /**
  * d_delete - delete a dentry
  * @dentry: The dentry to delete
@@ -1503,7 +1508,6 @@ out:
  * Turn the dentry into a negative dentry if possible, otherwise
  * remove it from the hash queues so it can be deleted later
  */
- 
 void d_delete(struct dentry * dentry)
 {
 	int isdir = 0;
@@ -1527,12 +1531,12 @@ void d_delete(struct dentry * dentry)
 
 	fsnotify_nameremove(dentry, isdir);
 }
+EXPORT_SYMBOL(d_delete);
 
 static void __d_rehash(struct dentry * entry, struct hlist_head *list)
 {
-
- 	entry->d_flags &= ~DCACHE_UNHASHED;
- 	hlist_add_head_rcu(&entry->d_hash, list);
+	entry->d_flags &= ~DCACHE_UNHASHED;
+	hlist_add_head_rcu(&entry->d_hash, list);
 }
 
 static void _d_rehash(struct dentry * entry)
@@ -1541,12 +1545,11 @@ static void _d_rehash(struct dentry * entry)
 }
 
 /**
- * d_rehash	- add an entry back to the hash
+ * d_rehash - add an entry back to the hash
  * @entry: dentry to add to the hash
  *
  * Adds a dentry to the hash according to its name.
  */
- 
 void d_rehash(struct dentry * entry)
 {
 	spin_lock(&dcache_lock);
@@ -1555,6 +1558,7 @@ void d_rehash(struct dentry * entry)
 	spin_unlock(&entry->d_lock);
 	spin_unlock(&dcache_lock);
 }
+EXPORT_SYMBOL(d_rehash);
 
 /*
  * When switching names, the actual string doesn't strictly have to
@@ -1619,7 +1623,7 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
  * up under the name it had before it was deleted rather than
  * under the original name of the file that was moved on top of it.
  */
- 
+
 /*
  * d_move_locked - move a dentry
  * @dentry: entry to move
@@ -1694,13 +1698,13 @@ already_unhashed:
  * Update the dcache to reflect the move of a file name. Negative
  * dcache entries should not be moved in this way.
  */
-
 void d_move(struct dentry * dentry, struct dentry * target)
 {
 	spin_lock(&dcache_lock);
 	d_move_locked(dentry, target);
 	spin_unlock(&dcache_lock);
 }
+EXPORT_SYMBOL(d_move);
 
 /**
  * d_ancestor - search for an ancestor
@@ -1867,6 +1871,7 @@ shouldnt_be_hashed:
 	spin_unlock(&dcache_lock);
 	BUG();
 }
+EXPORT_SYMBOL_GPL(d_materialise_unique);
 
 static int prepend(char **buffer, int *buflen, const char *str, int namelen)
 {
@@ -2004,6 +2009,7 @@ char *d_path(const struct path *path, char *buf, int buflen)
 	path_put(&root);
 	return res;
 }
+EXPORT_SYMBOL(d_path);
 
 /*
  * Helper function for dentry_operations.d_dname() members
@@ -2143,7 +2149,6 @@ out:
  * Returns 0 otherwise.
  * Caller must ensure that "new_dentry" is pinned before calling is_subdir()
  */
-  
 int is_subdir(struct dentry *new_dentry, struct dentry *old_dentry)
 {
 	int result;
@@ -2199,6 +2204,7 @@ resume:
 	}
 	spin_unlock(&dcache_lock);
 }
+EXPORT_SYMBOL(d_genocide);
 
 /**
  * find_inode_number - check for dentry with name
@@ -2213,7 +2219,6 @@ resume:
  * filesystems using synthetic inode numbers, and is necessary
  * to keep getcwd() working.
  */
- 
 ino_t find_inode_number(struct dentry *dir, struct qstr *name)
 {
 	struct dentry * dentry;
@@ -2227,6 +2232,7 @@ ino_t find_inode_number(struct dentry *dir, struct qstr *name)
 	}
 	return ino;
 }
+EXPORT_SYMBOL(find_inode_number);
 
 static __initdata unsigned long dhash_entries;
 static int __init set_dhash_entries(char *str)
@@ -2296,8 +2302,7 @@ static void __init dcache_init(void)
 
 /* SLAB cache for __getname() consumers */
 struct kmem_cache *names_cachep __read_mostly;
-
-EXPORT_SYMBOL(d_genocide);
+EXPORT_SYMBOL(names_cachep);
 
 void __init vfs_caches_init_early(void)
 {
@@ -2310,8 +2315,8 @@ void __init vfs_caches_init(unsigned long mempages)
 	unsigned long reserve;
 
 	/* Base hash sizes on available memory, with a reserve equal to
-           150% of current kernel size */
-
+	 * 150% of current kernel size.
+	 */
 	reserve = min((mempages - nr_free_pages()) * 3/2, mempages - 1);
 	mempages -= reserve;
 
@@ -2325,26 +2330,3 @@ void __init vfs_caches_init(unsigned long mempages)
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
