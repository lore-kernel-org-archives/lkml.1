Return-Path: <linux-kernel-owner+w=401wt.eu-S1759846AbZCaOGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846AbZCaOGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbZCaOGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:06:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:62327 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZCaOGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xAT1hHSZyJGdFx5T5b85Ug0OnzndaZOqjObp6TwcEpU4hK6ppdADiKgX24leNJof4O
         JAoHOpp8ZH46EoRPV/eY93wfojKGbqXWvY3Q6nVsYq59GxJX51G1ZNgooH/GZdFzMz37
         OJMrYfEam73ae19aEdENABka9Hav3uT5VqmZk=
MIME-Version: 1.0
In-Reply-To: <20090331091653.GU28946@ZenIV.linux.org.uk>
References: <ea11fea30903222039r4bec470crfd9825e37a926d56@mail.gmail.com> 
	<20090330163619.d08ba85e.akpm@linux-foundation.org> <ea11fea30903301943m34a04f08hc4251c6a6039e97@mail.gmail.com> 
	<20090331060423.GR28946@ZenIV.linux.org.uk> <ea11fea30903310202i738c1f05y754ea0a1a56574eb@mail.gmail.com> 
	<20090331091653.GU28946@ZenIV.linux.org.uk>
Date: Tue, 31 Mar 2009 19:35:54 +0530
Message-ID: <ea11fea30903310705n44bdc53cre76418ebc566d069@mail.gmail.com>
Subject: Re: [PATCH] : Code cleanup for fs/inode.c as per checkpatch.pl
From: Manish Katiyar <mkatiyar@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mkatiyar@gmail.com
Content-Type: multipart/mixed; boundary=00163645730a65e08204666ab3f8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00163645730a65e08204666ab3f8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2009 at 2:46 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Mar 31, 2009 at 02:32:37PM +0530, Manish Katiyar wrote:
>
>> -static struct inode * find_inode(struct super_block * sb, struct hlist_=
head *head, int (*test)(struct inode *, void *), void *data)
>> +static struct inode *find_inode(struct super_block *sb, struct hlist_he=
ad *head,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int (*test)(st=
ruct inode *, void *), void *data)
>
> If you are splitting it, split it all the way, esp. the last line.
>
>> -static struct inode * get_new_inode(struct super_block *sb, struct hlis=
t_head *head, int (*test)(struct inode *, void *), int (*set)(struct inode =
*, void *), void *data)
>> +static struct inode *get_new_inode(struct super_block *sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct hlist_h=
ead *head,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int (*test)(st=
ruct inode *, void *),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int (*set)(str=
uct inode *, void *), void *data)
>
> Ditto, and that's even more serious case - here 'void *data' part is
> really obfuscated.

Hi Al Viro,

Thanks for suggestions. Below is the updated patch. I have also attached it=
.

Code cleanup for fs/inode.c as per checkpatch.pl
Before:
total: 24 errors, 25 warnings, 1546 lines checked
After:
total: 0 errors, 0 warnings, 1539 lines checked

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/inode.c |   81 ++++++++++++++++++++++++++------------------------------=
----
 1 files changed, 35 insertions(+), 46 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 913ab2d..c44b199 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -98,7 +98,7 @@ static DEFINE_MUTEX(iprune_mutex);
  */
 struct inodes_stat_t inodes_stat;

-static struct kmem_cache * inode_cachep __read_mostly;
+static struct kmem_cache *inode_cachep __read_mostly;

 static void wake_up_inode(struct inode *inode)
 {
@@ -123,7 +123,7 @@ struct inode *inode_init_always(struct super_block
*sb, struct inode *inode)
 	static struct inode_operations empty_iops;
 	static const struct file_operations empty_fops;

-	struct address_space * const mapping =3D &inode->i_data;
+	struct address_space *const mapping =3D &inode->i_data;

 	inode->i_sb =3D sb;
 	inode->i_blkbits =3D sb->s_blocksize_bits;
@@ -206,7 +206,7 @@ static struct inode *alloc_inode(struct super_block *sb=
)
 	return NULL;
 }

-void destroy_inode(struct inode *inode)
+void destroy_inode(struct inode *inode)
 {
 	BUG_ON(inode_has_buffers(inode));
 	security_inode_free(inode);
@@ -242,12 +242,11 @@ void inode_init_once(struct inode *inode)
 	mutex_init(&inode->inotify_mutex);
 #endif
 }
-
 EXPORT_SYMBOL(inode_init_once);

 static void init_once(void *foo)
 {
-	struct inode * inode =3D (struct inode *) foo;
+	struct inode *inode =3D (struct inode *) foo;

 	inode_init_once(inode);
 }
@@ -255,7 +254,7 @@ static void init_once(void *foo)
 /*
  * inode_lock must be held
  */
-void __iget(struct inode * inode)
+void __iget(struct inode *inode)
 {
 	if (atomic_read(&inode->i_count)) {
 		atomic_inc(&inode->i_count);
@@ -279,7 +278,7 @@ void clear_inode(struct inode *inode)
 {
 	might_sleep();
 	invalidate_inode_buffers(inode);
-
+
 	BUG_ON(inode->i_data.nrpages);
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
@@ -293,7 +292,6 @@ void clear_inode(struct inode *inode)
 		cd_forget(inode);
 	inode->i_state =3D I_CLEAR;
 }
-
 EXPORT_SYMBOL(clear_inode);

 /*
@@ -341,8 +339,8 @@ static int invalidate_list(struct list_head *head,
struct list_head *dispose)

 	next =3D head->next;
 	for (;;) {
-		struct list_head * tmp =3D next;
-		struct inode * inode;
+		struct list_head *tmp =3D next;
+		struct inode *inode;

 		/*
 		 * We can reschedule here without worrying about the list's
@@ -378,7 +376,7 @@ static int invalidate_list(struct list_head *head,
struct list_head *dispose)
  *	fails because there are busy inodes then a non zero value is returned.
  *	If the discard is successful all the inodes have been discarded.
  */
-int invalidate_inodes(struct super_block * sb)
+int invalidate_inodes(struct super_block *sb)
 {
 	int busy;
 	LIST_HEAD(throw_away);
@@ -394,7 +392,6 @@ int invalidate_inodes(struct super_block * sb)

 	return busy;
 }
-
 EXPORT_SYMBOL(invalidate_inodes);

 static int can_unuse(struct inode *inode)
@@ -490,7 +487,7 @@ static int shrink_icache_memory(int nr, gfp_t gfp_mask)
 		 * Nasty deadlock avoidance.  We may hold various FS locks,
 		 * and we don't want to recurse into the FS that called us
 		 * in clear_inode() and friends..
-	 	 */
+		 */
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
 		prune_icache(nr);
@@ -510,10 +507,13 @@ static void __wait_on_freeing_inode(struct inode *ino=
de);
  * by hand after calling find_inode now! This simplifies iunique and won't
  * add any additional branch in the common code.
  */
-static struct inode * find_inode(struct super_block * sb, struct
hlist_head *head, int (*test)(struct inode *, void *), void *data)
+static struct inode *find_inode(struct super_block *sb,
+				struct hlist_head *head,
+				int (*test)(struct inode *, void *),
+				void *data)
 {
 	struct hlist_node *node;
-	struct inode * inode =3D NULL;
+	struct inode *inode =3D NULL;

 repeat:
 	hlist_for_each_entry(inode, node, head, i_hash) {
@@ -534,10 +534,11 @@ repeat:
  * find_inode_fast is the fast path version of find_inode, see the comment=
 at
  * iget_locked for details.
  */
-static struct inode * find_inode_fast(struct super_block * sb, struct
hlist_head *head, unsigned long ino)
+static struct inode *find_inode_fast(struct super_block *sb,
+				struct hlist_head *head, unsigned long ino)
 {
 	struct hlist_node *node;
-	struct inode * inode =3D NULL;
+	struct inode *inode =3D NULL;

 repeat:
 	hlist_for_each_entry(inode, node, head, i_hash) {
@@ -617,10 +618,10 @@ struct inode *new_inode(struct super_block *sb)
 	 * here to attempt to avoid that.
 	 */
 	static unsigned int last_ino;
-	struct inode * inode;
+	struct inode *inode;

 	spin_lock_prefetch(&inode_lock);
-=09
+
 	inode =3D alloc_inode(sb);
 	if (inode) {
 		spin_lock(&inode_lock);
@@ -631,7 +632,6 @@ struct inode *new_inode(struct super_block *sb)
 	}
 	return inode;
 }
-
 EXPORT_SYMBOL(new_inode);

 void unlock_new_inode(struct inode *inode)
@@ -659,7 +659,6 @@ void unlock_new_inode(struct inode *inode)
 	inode->i_state &=3D ~(I_LOCK|I_NEW);
 	wake_up_inode(inode);
 }
-
 EXPORT_SYMBOL(unlock_new_inode);

 /*
@@ -668,13 +667,17 @@ EXPORT_SYMBOL(unlock_new_inode);
  * We no longer cache the sb_flags in i_flags - see fs.h
  *	-- rmk@arm.uk.linux.org
  */
-static struct inode * get_new_inode(struct super_block *sb, struct
hlist_head *head, int (*test)(struct inode *, void *), int
(*set)(struct inode *, void *), void *data)
+static struct inode *get_new_inode(struct super_block *sb,
+				struct hlist_head *head,
+				int (*test)(struct inode *, void *),
+				int (*set)(struct inode *, void *),
+				void *data)
 {
-	struct inode * inode;
+	struct inode *inode;

 	inode =3D alloc_inode(sb);
 	if (inode) {
-		struct inode * old;
+		struct inode *old;

 		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
@@ -716,13 +719,14 @@ set_failed:
  * get_new_inode_fast is the fast path version of get_new_inode, see the
  * comment at iget_locked for details.
  */
-static struct inode * get_new_inode_fast(struct super_block *sb,
struct hlist_head *head, unsigned long ino)
+static struct inode *get_new_inode_fast(struct super_block *sb,
+				struct hlist_head *head, unsigned long ino)
 {
-	struct inode * inode;
+	struct inode *inode;

 	inode =3D alloc_inode(sb);
 	if (inode) {
-		struct inode * old;
+		struct inode *old;

 		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
@@ -808,7 +812,6 @@ struct inode *igrab(struct inode *inode)
 	spin_unlock(&inode_lock);
 	return inode;
 }
-
 EXPORT_SYMBOL(igrab);

 /**
@@ -909,7 +912,6 @@ struct inode *ilookup5_nowait(struct super_block
*sb, unsigned long hashval,

 	return ifind(sb, head, test, data, 0);
 }
-
 EXPORT_SYMBOL(ilookup5_nowait);

 /**
@@ -938,7 +940,6 @@ struct inode *ilookup5(struct super_block *sb,
unsigned long hashval,

 	return ifind(sb, head, test, data, 1);
 }
-
 EXPORT_SYMBOL(ilookup5);

 /**
@@ -961,7 +962,6 @@ struct inode *ilookup(struct super_block *sb,
unsigned long ino)

 	return ifind_fast(sb, head, ino);
 }
-
 EXPORT_SYMBOL(ilookup);

 /**
@@ -1000,7 +1000,6 @@ struct inode *iget5_locked(struct super_block
*sb, unsigned long hashval,
 	 */
 	return get_new_inode(sb, head, test, set, data);
 }
-
 EXPORT_SYMBOL(iget5_locked);

 /**
@@ -1032,7 +1031,6 @@ struct inode *iget_locked(struct super_block
*sb, unsigned long ino)
 	 */
 	return get_new_inode_fast(sb, head, ino);
 }
-
 EXPORT_SYMBOL(iget_locked);

 int insert_inode_locked(struct inode *inode)
@@ -1061,7 +1059,6 @@ int insert_inode_locked(struct inode *inode)
 		iput(old);
 	}
 }
-
 EXPORT_SYMBOL(insert_inode_locked);

 int insert_inode_locked4(struct inode *inode, unsigned long hashval,
@@ -1091,7 +1088,6 @@ int insert_inode_locked4(struct inode *inode,
unsigned long hashval,
 		iput(old);
 	}
 }
-
 EXPORT_SYMBOL(insert_inode_locked4);

 /**
@@ -1109,7 +1105,6 @@ void __insert_inode_hash(struct inode *inode,
unsigned long hashval)
 	hlist_add_head(&inode->i_hash, head);
 	spin_unlock(&inode_lock);
 }
-
 EXPORT_SYMBOL(__insert_inode_hash);

 /**
@@ -1124,7 +1119,6 @@ void remove_inode_hash(struct inode *inode)
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_lock);
 }
-
 EXPORT_SYMBOL(remove_inode_hash);

 /*
@@ -1171,7 +1165,6 @@ void generic_delete_inode(struct inode *inode)
 	BUG_ON(inode->i_state !=3D I_CLEAR);
 	destroy_inode(inode);
 }
-
 EXPORT_SYMBOL(generic_delete_inode);

 static void generic_forget_inode(struct inode *inode)
@@ -1218,12 +1211,11 @@ void generic_drop_inode(struct inode *inode)
 	else
 		generic_forget_inode(inode);
 }
-
 EXPORT_SYMBOL_GPL(generic_drop_inode);

 /*
  * Called when we're dropping the last reference
- * to an inode.
+ * to an inode.
  *
  * Call the FS "drop()" function, defaulting to
  * the legacy UNIX filesystem behaviour..
@@ -1243,7 +1235,7 @@ static inline void iput_final(struct inode *inode)
 }

 /**
- *	iput	- put an inode
+ *	iput	- put an inode
  *	@inode: inode to put
  *
  *	Puts an inode, dropping its usage count. If the inode use count hits
@@ -1260,7 +1252,6 @@ void iput(struct inode *inode)
 			iput_final(inode);
 	}
 }
-
 EXPORT_SYMBOL(iput);

 /**
@@ -1271,10 +1262,10 @@ EXPORT_SYMBOL(iput);
  *	Returns the block number on the device holding the inode that
  *	is the disk block number for the block of the file requested.
  *	That is, asked for block 4 of inode 1 the function will return the
- *	disk block relative to the disk start that holds that block of the
+ *	disk block relative to the disk start that holds that block of the
  *	file.
  */
-sector_t bmap(struct inode * inode, sector_t block)
+sector_t bmap(struct inode *inode, sector_t block)
 {
 	sector_t res =3D 0;
 	if (inode->i_mapping->a_ops->bmap)
@@ -1377,7 +1368,6 @@ void file_update_time(struct file *file)
 		mark_inode_dirty_sync(inode);
 	mnt_drop_write(file->f_path.mnt);
 }
-
 EXPORT_SYMBOL(file_update_time);

 int inode_needs_sync(struct inode *inode)
@@ -1388,7 +1378,6 @@ int inode_needs_sync(struct inode *inode)
 		return 1;
 	return 0;
 }
-
 EXPORT_SYMBOL(inode_needs_sync);

 int inode_wait(void *word)
--=20
1.5.4.3


Thanks -
Manish

>

--00163645730a65e08204666ab3f8
Content-Type: text/x-diff; charset=US-ASCII; name="0001-do-cleanups-in-fs-inode.c.patch"
Content-Disposition: attachment; 
	filename="0001-do-cleanups-in-fs-inode.c.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fsyo5wo70

RnJvbSBhOGJjMzIwOWQ0N2Q5ZWE4ODgwN2Y1NDA0MGZhMjc3YTQ2ODAzNjFkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW5pc2ggS2F0aXlhciA8bWthdGl5YXJAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDMxIE1hciAyMDA5IDE5OjM4OjQ5ICswNTMwClN1YmplY3Q6IFtQQVRDSF0gZG8g
Y2xlYW51cHMgaW4gZnMvaW5vZGUuYwoKClNpZ25lZC1vZmYtYnk6IE1hbmlzaCBLYXRpeWFyIDxt
a2F0aXlhckBnbWFpbC5jb20+Ci0tLQogZnMvaW5vZGUuYyB8ICAgODEgKysrKysrKysrKysrKysr
KysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGVzIGNo
YW5nZWQsIDM1IGluc2VydGlvbnMoKyksIDQ2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Zz
L2lub2RlLmMgYi9mcy9pbm9kZS5jCmluZGV4IDkxM2FiMmQuLmM0NGIxOTkgMTAwNjQ0Ci0tLSBh
L2ZzL2lub2RlLmMKKysrIGIvZnMvaW5vZGUuYwpAQCAtOTgsNyArOTgsNyBAQCBzdGF0aWMgREVG
SU5FX01VVEVYKGlwcnVuZV9tdXRleCk7CiAgKi8KIHN0cnVjdCBpbm9kZXNfc3RhdF90IGlub2Rl
c19zdGF0OwogCi1zdGF0aWMgc3RydWN0IGttZW1fY2FjaGUgKiBpbm9kZV9jYWNoZXAgX19yZWFk
X21vc3RseTsKK3N0YXRpYyBzdHJ1Y3Qga21lbV9jYWNoZSAqaW5vZGVfY2FjaGVwIF9fcmVhZF9t
b3N0bHk7CiAKIHN0YXRpYyB2b2lkIHdha2VfdXBfaW5vZGUoc3RydWN0IGlub2RlICppbm9kZSkK
IHsKQEAgLTEyMyw3ICsxMjMsNyBAQCBzdHJ1Y3QgaW5vZGUgKmlub2RlX2luaXRfYWx3YXlzKHN0
cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBpbm9kZSAqaW5vZGUpCiAJc3RhdGljIHN0cnVj
dCBpbm9kZV9vcGVyYXRpb25zIGVtcHR5X2lvcHM7CiAJc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxl
X29wZXJhdGlvbnMgZW1wdHlfZm9wczsKIAotCXN0cnVjdCBhZGRyZXNzX3NwYWNlICogY29uc3Qg
bWFwcGluZyA9ICZpbm9kZS0+aV9kYXRhOworCXN0cnVjdCBhZGRyZXNzX3NwYWNlICpjb25zdCBt
YXBwaW5nID0gJmlub2RlLT5pX2RhdGE7CiAKIAlpbm9kZS0+aV9zYiA9IHNiOwogCWlub2RlLT5p
X2Jsa2JpdHMgPSBzYi0+c19ibG9ja3NpemVfYml0czsKQEAgLTIwNiw3ICsyMDYsNyBAQCBzdGF0
aWMgc3RydWN0IGlub2RlICphbGxvY19pbm9kZShzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQogCXJl
dHVybiBOVUxMOwogfQogCi12b2lkIGRlc3Ryb3lfaW5vZGUoc3RydWN0IGlub2RlICppbm9kZSkg
Cit2b2lkIGRlc3Ryb3lfaW5vZGUoc3RydWN0IGlub2RlICppbm9kZSkKIHsKIAlCVUdfT04oaW5v
ZGVfaGFzX2J1ZmZlcnMoaW5vZGUpKTsKIAlzZWN1cml0eV9pbm9kZV9mcmVlKGlub2RlKTsKQEAg
LTI0MiwxMiArMjQyLDExIEBAIHZvaWQgaW5vZGVfaW5pdF9vbmNlKHN0cnVjdCBpbm9kZSAqaW5v
ZGUpCiAJbXV0ZXhfaW5pdCgmaW5vZGUtPmlub3RpZnlfbXV0ZXgpOwogI2VuZGlmCiB9Ci0KIEVY
UE9SVF9TWU1CT0woaW5vZGVfaW5pdF9vbmNlKTsKIAogc3RhdGljIHZvaWQgaW5pdF9vbmNlKHZv
aWQgKmZvbykKIHsKLQlzdHJ1Y3QgaW5vZGUgKiBpbm9kZSA9IChzdHJ1Y3QgaW5vZGUgKikgZm9v
OworCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSAoc3RydWN0IGlub2RlICopIGZvbzsKIAogCWlub2Rl
X2luaXRfb25jZShpbm9kZSk7CiB9CkBAIC0yNTUsNyArMjU0LDcgQEAgc3RhdGljIHZvaWQgaW5p
dF9vbmNlKHZvaWQgKmZvbykKIC8qCiAgKiBpbm9kZV9sb2NrIG11c3QgYmUgaGVsZAogICovCi12
b2lkIF9faWdldChzdHJ1Y3QgaW5vZGUgKiBpbm9kZSkKK3ZvaWQgX19pZ2V0KHN0cnVjdCBpbm9k
ZSAqaW5vZGUpCiB7CiAJaWYgKGF0b21pY19yZWFkKCZpbm9kZS0+aV9jb3VudCkpIHsKIAkJYXRv
bWljX2luYygmaW5vZGUtPmlfY291bnQpOwpAQCAtMjc5LDcgKzI3OCw3IEBAIHZvaWQgY2xlYXJf
aW5vZGUoc3RydWN0IGlub2RlICppbm9kZSkKIHsKIAltaWdodF9zbGVlcCgpOwogCWludmFsaWRh
dGVfaW5vZGVfYnVmZmVycyhpbm9kZSk7Ci0gICAgICAgCisKIAlCVUdfT04oaW5vZGUtPmlfZGF0
YS5ucnBhZ2VzKTsKIAlCVUdfT04oIShpbm9kZS0+aV9zdGF0ZSAmIElfRlJFRUlORykpOwogCUJV
R19PTihpbm9kZS0+aV9zdGF0ZSAmIElfQ0xFQVIpOwpAQCAtMjkzLDcgKzI5Miw2IEBAIHZvaWQg
Y2xlYXJfaW5vZGUoc3RydWN0IGlub2RlICppbm9kZSkKIAkJY2RfZm9yZ2V0KGlub2RlKTsKIAlp
bm9kZS0+aV9zdGF0ZSA9IElfQ0xFQVI7CiB9Ci0KIEVYUE9SVF9TWU1CT0woY2xlYXJfaW5vZGUp
OwogCiAvKgpAQCAtMzQxLDggKzMzOSw4IEBAIHN0YXRpYyBpbnQgaW52YWxpZGF0ZV9saXN0KHN0
cnVjdCBsaXN0X2hlYWQgKmhlYWQsIHN0cnVjdCBsaXN0X2hlYWQgKmRpc3Bvc2UpCiAKIAluZXh0
ID0gaGVhZC0+bmV4dDsKIAlmb3IgKDs7KSB7Ci0JCXN0cnVjdCBsaXN0X2hlYWQgKiB0bXAgPSBu
ZXh0OwotCQlzdHJ1Y3QgaW5vZGUgKiBpbm9kZTsKKwkJc3RydWN0IGxpc3RfaGVhZCAqdG1wID0g
bmV4dDsKKwkJc3RydWN0IGlub2RlICppbm9kZTsKIAogCQkvKgogCQkgKiBXZSBjYW4gcmVzY2hl
ZHVsZSBoZXJlIHdpdGhvdXQgd29ycnlpbmcgYWJvdXQgdGhlIGxpc3QncwpAQCAtMzc4LDcgKzM3
Niw3IEBAIHN0YXRpYyBpbnQgaW52YWxpZGF0ZV9saXN0KHN0cnVjdCBsaXN0X2hlYWQgKmhlYWQs
IHN0cnVjdCBsaXN0X2hlYWQgKmRpc3Bvc2UpCiAgKglmYWlscyBiZWNhdXNlIHRoZXJlIGFyZSBi
dXN5IGlub2RlcyB0aGVuIGEgbm9uIHplcm8gdmFsdWUgaXMgcmV0dXJuZWQuCiAgKglJZiB0aGUg
ZGlzY2FyZCBpcyBzdWNjZXNzZnVsIGFsbCB0aGUgaW5vZGVzIGhhdmUgYmVlbiBkaXNjYXJkZWQu
CiAgKi8KLWludCBpbnZhbGlkYXRlX2lub2RlcyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKiBzYikKK2lu
dCBpbnZhbGlkYXRlX2lub2RlcyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQogewogCWludCBidXN5
OwogCUxJU1RfSEVBRCh0aHJvd19hd2F5KTsKQEAgLTM5NCw3ICszOTIsNiBAQCBpbnQgaW52YWxp
ZGF0ZV9pbm9kZXMoc3RydWN0IHN1cGVyX2Jsb2NrICogc2IpCiAKIAlyZXR1cm4gYnVzeTsKIH0K
LQogRVhQT1JUX1NZTUJPTChpbnZhbGlkYXRlX2lub2Rlcyk7CiAKIHN0YXRpYyBpbnQgY2FuX3Vu
dXNlKHN0cnVjdCBpbm9kZSAqaW5vZGUpCkBAIC00OTAsNyArNDg3LDcgQEAgc3RhdGljIGludCBz
aHJpbmtfaWNhY2hlX21lbW9yeShpbnQgbnIsIGdmcF90IGdmcF9tYXNrKQogCQkgKiBOYXN0eSBk
ZWFkbG9jayBhdm9pZGFuY2UuICBXZSBtYXkgaG9sZCB2YXJpb3VzIEZTIGxvY2tzLAogCQkgKiBh
bmQgd2UgZG9uJ3Qgd2FudCB0byByZWN1cnNlIGludG8gdGhlIEZTIHRoYXQgY2FsbGVkIHVzCiAJ
CSAqIGluIGNsZWFyX2lub2RlKCkgYW5kIGZyaWVuZHMuLgotCSAJICovCisJCSAqLwogCQlpZiAo
IShnZnBfbWFzayAmIF9fR0ZQX0ZTKSkKIAkJCXJldHVybiAtMTsKIAkJcHJ1bmVfaWNhY2hlKG5y
KTsKQEAgLTUxMCwxMCArNTA3LDEzIEBAIHN0YXRpYyB2b2lkIF9fd2FpdF9vbl9mcmVlaW5nX2lu
b2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUpOwogICogYnkgaGFuZCBhZnRlciBjYWxsaW5nIGZpbmRf
aW5vZGUgbm93ISBUaGlzIHNpbXBsaWZpZXMgaXVuaXF1ZSBhbmQgd29uJ3QKICAqIGFkZCBhbnkg
YWRkaXRpb25hbCBicmFuY2ggaW4gdGhlIGNvbW1vbiBjb2RlLgogICovCi1zdGF0aWMgc3RydWN0
IGlub2RlICogZmluZF9pbm9kZShzdHJ1Y3Qgc3VwZXJfYmxvY2sgKiBzYiwgc3RydWN0IGhsaXN0
X2hlYWQgKmhlYWQsIGludCAoKnRlc3QpKHN0cnVjdCBpbm9kZSAqLCB2b2lkICopLCB2b2lkICpk
YXRhKQorc3RhdGljIHN0cnVjdCBpbm9kZSAqZmluZF9pbm9kZShzdHJ1Y3Qgc3VwZXJfYmxvY2sg
KnNiLAorCQkJCXN0cnVjdCBobGlzdF9oZWFkICpoZWFkLAorCQkJCWludCAoKnRlc3QpKHN0cnVj
dCBpbm9kZSAqLCB2b2lkICopLAorCQkJCXZvaWQgKmRhdGEpCiB7CiAJc3RydWN0IGhsaXN0X25v
ZGUgKm5vZGU7Ci0Jc3RydWN0IGlub2RlICogaW5vZGUgPSBOVUxMOworCXN0cnVjdCBpbm9kZSAq
aW5vZGUgPSBOVUxMOwogCiByZXBlYXQ6CiAJaGxpc3RfZm9yX2VhY2hfZW50cnkoaW5vZGUsIG5v
ZGUsIGhlYWQsIGlfaGFzaCkgewpAQCAtNTM0LDEwICs1MzQsMTEgQEAgcmVwZWF0OgogICogZmlu
ZF9pbm9kZV9mYXN0IGlzIHRoZSBmYXN0IHBhdGggdmVyc2lvbiBvZiBmaW5kX2lub2RlLCBzZWUg
dGhlIGNvbW1lbnQgYXQKICAqIGlnZXRfbG9ja2VkIGZvciBkZXRhaWxzLgogICovCi1zdGF0aWMg
c3RydWN0IGlub2RlICogZmluZF9pbm9kZV9mYXN0KHN0cnVjdCBzdXBlcl9ibG9jayAqIHNiLCBz
dHJ1Y3QgaGxpc3RfaGVhZCAqaGVhZCwgdW5zaWduZWQgbG9uZyBpbm8pCitzdGF0aWMgc3RydWN0
IGlub2RlICpmaW5kX2lub2RlX2Zhc3Qoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwKKwkJCQlzdHJ1
Y3QgaGxpc3RfaGVhZCAqaGVhZCwgdW5zaWduZWQgbG9uZyBpbm8pCiB7CiAJc3RydWN0IGhsaXN0
X25vZGUgKm5vZGU7Ci0Jc3RydWN0IGlub2RlICogaW5vZGUgPSBOVUxMOworCXN0cnVjdCBpbm9k
ZSAqaW5vZGUgPSBOVUxMOwogCiByZXBlYXQ6CiAJaGxpc3RfZm9yX2VhY2hfZW50cnkoaW5vZGUs
IG5vZGUsIGhlYWQsIGlfaGFzaCkgewpAQCAtNjE3LDEwICs2MTgsMTAgQEAgc3RydWN0IGlub2Rl
ICpuZXdfaW5vZGUoc3RydWN0IHN1cGVyX2Jsb2NrICpzYikKIAkgKiBoZXJlIHRvIGF0dGVtcHQg
dG8gYXZvaWQgdGhhdC4KIAkgKi8KIAlzdGF0aWMgdW5zaWduZWQgaW50IGxhc3RfaW5vOwotCXN0
cnVjdCBpbm9kZSAqIGlub2RlOworCXN0cnVjdCBpbm9kZSAqaW5vZGU7CiAKIAlzcGluX2xvY2tf
cHJlZmV0Y2goJmlub2RlX2xvY2spOwotCQorCiAJaW5vZGUgPSBhbGxvY19pbm9kZShzYik7CiAJ
aWYgKGlub2RlKSB7CiAJCXNwaW5fbG9jaygmaW5vZGVfbG9jayk7CkBAIC02MzEsNyArNjMyLDYg
QEAgc3RydWN0IGlub2RlICpuZXdfaW5vZGUoc3RydWN0IHN1cGVyX2Jsb2NrICpzYikKIAl9CiAJ
cmV0dXJuIGlub2RlOwogfQotCiBFWFBPUlRfU1lNQk9MKG5ld19pbm9kZSk7CiAKIHZvaWQgdW5s
b2NrX25ld19pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2RlKQpAQCAtNjU5LDcgKzY1OSw2IEBAIHZv
aWQgdW5sb2NrX25ld19pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2RlKQogCWlub2RlLT5pX3N0YXRl
ICY9IH4oSV9MT0NLfElfTkVXKTsKIAl3YWtlX3VwX2lub2RlKGlub2RlKTsKIH0KLQogRVhQT1JU
X1NZTUJPTCh1bmxvY2tfbmV3X2lub2RlKTsKIAogLyoKQEAgLTY2OCwxMyArNjY3LDE3IEBAIEVY
UE9SVF9TWU1CT0wodW5sb2NrX25ld19pbm9kZSk7CiAgKiBXZSBubyBsb25nZXIgY2FjaGUgdGhl
IHNiX2ZsYWdzIGluIGlfZmxhZ3MgLSBzZWUgZnMuaAogICoJLS0gcm1rQGFybS51ay5saW51eC5v
cmcKICAqLwotc3RhdGljIHN0cnVjdCBpbm9kZSAqIGdldF9uZXdfaW5vZGUoc3RydWN0IHN1cGVy
X2Jsb2NrICpzYiwgc3RydWN0IGhsaXN0X2hlYWQgKmhlYWQsIGludCAoKnRlc3QpKHN0cnVjdCBp
bm9kZSAqLCB2b2lkICopLCBpbnQgKCpzZXQpKHN0cnVjdCBpbm9kZSAqLCB2b2lkICopLCB2b2lk
ICpkYXRhKQorc3RhdGljIHN0cnVjdCBpbm9kZSAqZ2V0X25ld19pbm9kZShzdHJ1Y3Qgc3VwZXJf
YmxvY2sgKnNiLAorCQkJCXN0cnVjdCBobGlzdF9oZWFkICpoZWFkLAorCQkJCWludCAoKnRlc3Qp
KHN0cnVjdCBpbm9kZSAqLCB2b2lkICopLAorCQkJCWludCAoKnNldCkoc3RydWN0IGlub2RlICos
IHZvaWQgKiksCisJCQkJdm9pZCAqZGF0YSkKIHsKLQlzdHJ1Y3QgaW5vZGUgKiBpbm9kZTsKKwlz
dHJ1Y3QgaW5vZGUgKmlub2RlOwogCiAJaW5vZGUgPSBhbGxvY19pbm9kZShzYik7CiAJaWYgKGlu
b2RlKSB7Ci0JCXN0cnVjdCBpbm9kZSAqIG9sZDsKKwkJc3RydWN0IGlub2RlICpvbGQ7CiAKIAkJ
c3Bpbl9sb2NrKCZpbm9kZV9sb2NrKTsKIAkJLyogV2UgcmVsZWFzZWQgdGhlIGxvY2ssIHNvLi4g
Ki8KQEAgLTcxNiwxMyArNzE5LDE0IEBAIHNldF9mYWlsZWQ6CiAgKiBnZXRfbmV3X2lub2RlX2Zh
c3QgaXMgdGhlIGZhc3QgcGF0aCB2ZXJzaW9uIG9mIGdldF9uZXdfaW5vZGUsIHNlZSB0aGUKICAq
IGNvbW1lbnQgYXQgaWdldF9sb2NrZWQgZm9yIGRldGFpbHMuCiAgKi8KLXN0YXRpYyBzdHJ1Y3Qg
aW5vZGUgKiBnZXRfbmV3X2lub2RlX2Zhc3Qoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgc3RydWN0
IGhsaXN0X2hlYWQgKmhlYWQsIHVuc2lnbmVkIGxvbmcgaW5vKQorc3RhdGljIHN0cnVjdCBpbm9k
ZSAqZ2V0X25ld19pbm9kZV9mYXN0KHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsCisJCQkJc3RydWN0
IGhsaXN0X2hlYWQgKmhlYWQsIHVuc2lnbmVkIGxvbmcgaW5vKQogewotCXN0cnVjdCBpbm9kZSAq
IGlub2RlOworCXN0cnVjdCBpbm9kZSAqaW5vZGU7CiAKIAlpbm9kZSA9IGFsbG9jX2lub2RlKHNi
KTsKIAlpZiAoaW5vZGUpIHsKLQkJc3RydWN0IGlub2RlICogb2xkOworCQlzdHJ1Y3QgaW5vZGUg
Km9sZDsKIAogCQlzcGluX2xvY2soJmlub2RlX2xvY2spOwogCQkvKiBXZSByZWxlYXNlZCB0aGUg
bG9jaywgc28uLiAqLwpAQCAtODA4LDcgKzgxMiw2IEBAIHN0cnVjdCBpbm9kZSAqaWdyYWIoc3Ry
dWN0IGlub2RlICppbm9kZSkKIAlzcGluX3VubG9jaygmaW5vZGVfbG9jayk7CiAJcmV0dXJuIGlu
b2RlOwogfQotCiBFWFBPUlRfU1lNQk9MKGlncmFiKTsKIAogLyoqCkBAIC05MDksNyArOTEyLDYg
QEAgc3RydWN0IGlub2RlICppbG9va3VwNV9ub3dhaXQoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwg
dW5zaWduZWQgbG9uZyBoYXNodmFsLAogCiAJcmV0dXJuIGlmaW5kKHNiLCBoZWFkLCB0ZXN0LCBk
YXRhLCAwKTsKIH0KLQogRVhQT1JUX1NZTUJPTChpbG9va3VwNV9ub3dhaXQpOwogCiAvKioKQEAg
LTkzOCw3ICs5NDAsNiBAQCBzdHJ1Y3QgaW5vZGUgKmlsb29rdXA1KHN0cnVjdCBzdXBlcl9ibG9j
ayAqc2IsIHVuc2lnbmVkIGxvbmcgaGFzaHZhbCwKIAogCXJldHVybiBpZmluZChzYiwgaGVhZCwg
dGVzdCwgZGF0YSwgMSk7CiB9Ci0KIEVYUE9SVF9TWU1CT0woaWxvb2t1cDUpOwogCiAvKioKQEAg
LTk2MSw3ICs5NjIsNiBAQCBzdHJ1Y3QgaW5vZGUgKmlsb29rdXAoc3RydWN0IHN1cGVyX2Jsb2Nr
ICpzYiwgdW5zaWduZWQgbG9uZyBpbm8pCiAKIAlyZXR1cm4gaWZpbmRfZmFzdChzYiwgaGVhZCwg
aW5vKTsKIH0KLQogRVhQT1JUX1NZTUJPTChpbG9va3VwKTsKIAogLyoqCkBAIC0xMDAwLDcgKzEw
MDAsNiBAQCBzdHJ1Y3QgaW5vZGUgKmlnZXQ1X2xvY2tlZChzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNi
LCB1bnNpZ25lZCBsb25nIGhhc2h2YWwsCiAJICovCiAJcmV0dXJuIGdldF9uZXdfaW5vZGUoc2Is
IGhlYWQsIHRlc3QsIHNldCwgZGF0YSk7CiB9Ci0KIEVYUE9SVF9TWU1CT0woaWdldDVfbG9ja2Vk
KTsKIAogLyoqCkBAIC0xMDMyLDcgKzEwMzEsNiBAQCBzdHJ1Y3QgaW5vZGUgKmlnZXRfbG9ja2Vk
KHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHVuc2lnbmVkIGxvbmcgaW5vKQogCSAqLwogCXJldHVy
biBnZXRfbmV3X2lub2RlX2Zhc3Qoc2IsIGhlYWQsIGlubyk7CiB9Ci0KIEVYUE9SVF9TWU1CT0wo
aWdldF9sb2NrZWQpOwogCiBpbnQgaW5zZXJ0X2lub2RlX2xvY2tlZChzdHJ1Y3QgaW5vZGUgKmlu
b2RlKQpAQCAtMTA2MSw3ICsxMDU5LDYgQEAgaW50IGluc2VydF9pbm9kZV9sb2NrZWQoc3RydWN0
IGlub2RlICppbm9kZSkKIAkJaXB1dChvbGQpOwogCX0KIH0KLQogRVhQT1JUX1NZTUJPTChpbnNl
cnRfaW5vZGVfbG9ja2VkKTsKIAogaW50IGluc2VydF9pbm9kZV9sb2NrZWQ0KHN0cnVjdCBpbm9k
ZSAqaW5vZGUsIHVuc2lnbmVkIGxvbmcgaGFzaHZhbCwKQEAgLTEwOTEsNyArMTA4OCw2IEBAIGlu
dCBpbnNlcnRfaW5vZGVfbG9ja2VkNChzdHJ1Y3QgaW5vZGUgKmlub2RlLCB1bnNpZ25lZCBsb25n
IGhhc2h2YWwsCiAJCWlwdXQob2xkKTsKIAl9CiB9Ci0KIEVYUE9SVF9TWU1CT0woaW5zZXJ0X2lu
b2RlX2xvY2tlZDQpOwogCiAvKioKQEAgLTExMDksNyArMTEwNSw2IEBAIHZvaWQgX19pbnNlcnRf
aW5vZGVfaGFzaChzdHJ1Y3QgaW5vZGUgKmlub2RlLCB1bnNpZ25lZCBsb25nIGhhc2h2YWwpCiAJ
aGxpc3RfYWRkX2hlYWQoJmlub2RlLT5pX2hhc2gsIGhlYWQpOwogCXNwaW5fdW5sb2NrKCZpbm9k
ZV9sb2NrKTsKIH0KLQogRVhQT1JUX1NZTUJPTChfX2luc2VydF9pbm9kZV9oYXNoKTsKIAogLyoq
CkBAIC0xMTI0LDcgKzExMTksNiBAQCB2b2lkIHJlbW92ZV9pbm9kZV9oYXNoKHN0cnVjdCBpbm9k
ZSAqaW5vZGUpCiAJaGxpc3RfZGVsX2luaXQoJmlub2RlLT5pX2hhc2gpOwogCXNwaW5fdW5sb2Nr
KCZpbm9kZV9sb2NrKTsKIH0KLQogRVhQT1JUX1NZTUJPTChyZW1vdmVfaW5vZGVfaGFzaCk7CiAK
IC8qCkBAIC0xMTcxLDcgKzExNjUsNiBAQCB2b2lkIGdlbmVyaWNfZGVsZXRlX2lub2RlKHN0cnVj
dCBpbm9kZSAqaW5vZGUpCiAJQlVHX09OKGlub2RlLT5pX3N0YXRlICE9IElfQ0xFQVIpOwogCWRl
c3Ryb3lfaW5vZGUoaW5vZGUpOwogfQotCiBFWFBPUlRfU1lNQk9MKGdlbmVyaWNfZGVsZXRlX2lu
b2RlKTsKIAogc3RhdGljIHZvaWQgZ2VuZXJpY19mb3JnZXRfaW5vZGUoc3RydWN0IGlub2RlICpp
bm9kZSkKQEAgLTEyMTgsMTIgKzEyMTEsMTEgQEAgdm9pZCBnZW5lcmljX2Ryb3BfaW5vZGUoc3Ry
dWN0IGlub2RlICppbm9kZSkKIAllbHNlCiAJCWdlbmVyaWNfZm9yZ2V0X2lub2RlKGlub2RlKTsK
IH0KLQogRVhQT1JUX1NZTUJPTF9HUEwoZ2VuZXJpY19kcm9wX2lub2RlKTsKIAogLyoKICAqIENh
bGxlZCB3aGVuIHdlJ3JlIGRyb3BwaW5nIHRoZSBsYXN0IHJlZmVyZW5jZQotICogdG8gYW4gaW5v
ZGUuIAorICogdG8gYW4gaW5vZGUuCiAgKgogICogQ2FsbCB0aGUgRlMgImRyb3AoKSIgZnVuY3Rp
b24sIGRlZmF1bHRpbmcgdG8KICAqIHRoZSBsZWdhY3kgVU5JWCBmaWxlc3lzdGVtIGJlaGF2aW91
ci4uCkBAIC0xMjQzLDcgKzEyMzUsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgaXB1dF9maW5hbChz
dHJ1Y3QgaW5vZGUgKmlub2RlKQogfQogCiAvKioKLSAqCWlwdXQJLSBwdXQgYW4gaW5vZGUgCisg
KglpcHV0CS0gcHV0IGFuIGlub2RlCiAgKglAaW5vZGU6IGlub2RlIHRvIHB1dAogICoKICAqCVB1
dHMgYW4gaW5vZGUsIGRyb3BwaW5nIGl0cyB1c2FnZSBjb3VudC4gSWYgdGhlIGlub2RlIHVzZSBj
b3VudCBoaXRzCkBAIC0xMjYwLDcgKzEyNTIsNiBAQCB2b2lkIGlwdXQoc3RydWN0IGlub2RlICpp
bm9kZSkKIAkJCWlwdXRfZmluYWwoaW5vZGUpOwogCX0KIH0KLQogRVhQT1JUX1NZTUJPTChpcHV0
KTsKIAogLyoqCkBAIC0xMjcxLDEwICsxMjYyLDEwIEBAIEVYUE9SVF9TWU1CT0woaXB1dCk7CiAg
KglSZXR1cm5zIHRoZSBibG9jayBudW1iZXIgb24gdGhlIGRldmljZSBob2xkaW5nIHRoZSBpbm9k
ZSB0aGF0CiAgKglpcyB0aGUgZGlzayBibG9jayBudW1iZXIgZm9yIHRoZSBibG9jayBvZiB0aGUg
ZmlsZSByZXF1ZXN0ZWQuCiAgKglUaGF0IGlzLCBhc2tlZCBmb3IgYmxvY2sgNCBvZiBpbm9kZSAx
IHRoZSBmdW5jdGlvbiB3aWxsIHJldHVybiB0aGUKLSAqCWRpc2sgYmxvY2sgcmVsYXRpdmUgdG8g
dGhlIGRpc2sgc3RhcnQgdGhhdCBob2xkcyB0aGF0IGJsb2NrIG9mIHRoZSAKKyAqCWRpc2sgYmxv
Y2sgcmVsYXRpdmUgdG8gdGhlIGRpc2sgc3RhcnQgdGhhdCBob2xkcyB0aGF0IGJsb2NrIG9mIHRo
ZQogICoJZmlsZS4KICAqLwotc2VjdG9yX3QgYm1hcChzdHJ1Y3QgaW5vZGUgKiBpbm9kZSwgc2Vj
dG9yX3QgYmxvY2spCitzZWN0b3JfdCBibWFwKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHNlY3Rvcl90
IGJsb2NrKQogewogCXNlY3Rvcl90IHJlcyA9IDA7CiAJaWYgKGlub2RlLT5pX21hcHBpbmctPmFf
b3BzLT5ibWFwKQpAQCAtMTM3Nyw3ICsxMzY4LDYgQEAgdm9pZCBmaWxlX3VwZGF0ZV90aW1lKHN0
cnVjdCBmaWxlICpmaWxlKQogCQltYXJrX2lub2RlX2RpcnR5X3N5bmMoaW5vZGUpOwogCW1udF9k
cm9wX3dyaXRlKGZpbGUtPmZfcGF0aC5tbnQpOwogfQotCiBFWFBPUlRfU1lNQk9MKGZpbGVfdXBk
YXRlX3RpbWUpOwogCiBpbnQgaW5vZGVfbmVlZHNfc3luYyhzdHJ1Y3QgaW5vZGUgKmlub2RlKQpA
QCAtMTM4OCw3ICsxMzc4LDYgQEAgaW50IGlub2RlX25lZWRzX3N5bmMoc3RydWN0IGlub2RlICpp
bm9kZSkKIAkJcmV0dXJuIDE7CiAJcmV0dXJuIDA7CiB9Ci0KIEVYUE9SVF9TWU1CT0woaW5vZGVf
bmVlZHNfc3luYyk7CiAKIGludCBpbm9kZV93YWl0KHZvaWQgKndvcmQpCi0tIAoxLjUuNC4zCgo=
--00163645730a65e08204666ab3f8--
