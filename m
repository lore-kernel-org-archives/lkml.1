Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZK1DKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZK1DKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 22:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZK1DKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 22:10:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:44254 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753453AbZK1DKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 22:10:08 -0500
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX18isv1jGWsicnsVuMt6P1pR9Lrz4WB98t+ELUJQ/c
	nl480WtXFFS+Bb
Date: Sat, 28 Nov 2009 08:14:40 +1300
From: Johannes Buchner <buchner.johannes@gmx.at>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: Fw: reiser4 git repo
Message-Id: <20091128081440.36265403.buchner.johannes@gmx.at>
In-Reply-To: <20091127030050.GC5406@nowhere>
References: <20091127155148.dcc5cdee.buchner.johannes@gmx.at>
	<20091127030050.GC5406@nowhere>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__28_Nov_2009_08_14_40_+1300_OMWBIxwDEbQt.Dk."
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__28_Nov_2009_08_14_40_+1300_OMWBIxwDEbQt.Dk.
Content-Type: multipart/mixed;
 boundary="Multipart=_Sat__28_Nov_2009_08_14_40_+1300_n9OQJ.lR5ZJZ+BRR"


--Multipart=_Sat__28_Nov_2009_08_14_40_+1300_n9OQJ.lR5ZJZ+BRR
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I had some issues with the reiser4 patch series from -mm.
First of all, I'm not sure what release they are based on. I used=20
a8a8a669e from Linus' git repository. I applied all reiser4 patches
(except reiser4-disable of course) from
http://userweb.kernel.org/~akpm/mmotm/, which worked fine.

I think these patches are based on the reiser4-2.6.30 patch.=20
I also compared them to the reiser4-2.6.31 patch, which adds some
missing pieces ([1] reiser4-from-2.6.31-patch.patch).

Additionally, some recent commits demand some changes, especially
since current_is_pdflush and generic_sync_sb_inodes are not available
any more (d8a8559cd7a9cc).
[2] reiser4-pdflush-comments.patch only fixes some comments which still
mention pdflush.=20
In [3] reiser4-generic_sync_sb_inodes.patch I tried to
replace generic_sync_sb_inodes. I am not 100% sure that this is
correct, but that is what I understood from the commit diff+message of
d8a8559cd7a9cc.

The original patch
'reiser4-vfs-add-super_operationssync_inodes' introduced the call from
sync_inodes_sb to the super operation sync_inodes(sb, NULL). This NULL
pointer is dereferenced in reiser4_sync_inodes, which is fixed by
[4] reiser4-sync_inodes-null-dereference.patch.

All 4 additional patches are attached. I can only say that it works on
my machine, before I had compilation issues and freezes on 'sync'.=20

Cheers,
Johannes

PS: The git repo mentioned in
http://userweb.kernel.org/~akpm/mmotm/mmotm-readme.txt is not available.

On Fri, 27 Nov 2009 04:00:51 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, Nov 27, 2009 at 03:51:48PM +1300, Johannes Buchner wrote:
> > [ I sent this 2 days ago to linux-fsdevel@vger.kernel.org, maybe
> > I'll get more responses in here. ]
> >=20
> > Hi!
> >=20
> > I would like to keep a git repo up to date with current kernel
> > development, with reiser4 patched in. I am having trouble finding a
> > repo that provides reiser4. Is there one?
> >=20
> > Some people may have noticed the last patch doesn't apply cleanly
> > anymore. I made a few lines of modifications in my local repo. Maybe
> > that repo would be interesting for others too*.
> >=20
> > I plan to catch up with changes from kernel development on a
> > daily/weekly basis; my /home partition is reiser4, so I am fairly
> > serious about it.
> >=20
> > At the moment, I fetch from torvalds/linux-2.6.git and=20
> > stable/linux-2.6.31.y.git. Am I missing any other repositories that
> > I should try to keep up with? (A fs subsystem maintainer repo?)
> > next/linux-next.git is probably moving too fast for me.
>=20
>=20
> You can try the -mm tree, the reiser 4 patches can be found inside:
>=20
> http://userweb.kernel.org/~akpm/mmotm/

--=20
Emails k=F6nnen ge=E4ndert, gef=E4lscht und eingesehen werden. Signiere oder
versch=FCssele deine Mails mit GPG.
http://web.student.tuwien.ac.at/~e0625457/pgp.html



--Multipart=_Sat__28_Nov_2009_08_14_40_+1300_n9OQJ.lR5ZJZ+BRR
Content-Type: application/octet-stream;
 name="series"
Content-Disposition: attachment;
 filename="series"
Content-Transfer-Encoding: base64

cmVpc2VyNC12ZnMtYWRkLXN1cGVyX29wZXJhdGlvbnNzeW5jX2lub2Rlcy0yLnBhdGNoCiNyZWlz
ZXI0LXNiX3N5bmNfaW5vZGVzLnBhdGNoCnJlaXNlcjQtZXhwb3J0LXJlbW92ZV9mcm9tX3BhZ2Vf
Y2FjaGUucGF0Y2gKcmVpc2VyNC1leHBvcnQtcmVtb3ZlX2Zyb21fcGFnZV9jYWNoZS1maXgucGF0
Y2gKcmVpc2VyNC1leHBvcnQtZmluZF9nZXRfcGFnZXMucGF0Y2gKcmVpc2VyNC5wYXRjaApyZWlz
ZXI0LWFkanVzdC10by10aGUtbmV3LWFvcHMucGF0Y2gKcmVpc2VyNC1hZGp1c3QtdG8tdGhlLW5l
dy1hb3BzLWZpeHVwLnBhdGNoCnJlaXNlcjQtcmVtb3ZlLXNpbXBsZV9wcmVwYXJlX3dyaXRlLXVz
YWdlLnBhdGNoCnJlaXNlcjQtcmVtb3ZlLXNpbXBsZV9wcmVwYXJlX3dyaXRlLXVzYWdlLWNoZWNr
cGF0Y2gtZml4ZXMucGF0Y2gKZnMtc3ltbGluay13cml0ZV9iZWdpbi1hbGxvY2F0aW9uLWNvbnRl
eHQtZml4LXJlaXNlcjQtZml4LnBhdGNoCnJlaXNlcjQtaGFuZGxpbmctZXJyb3ItcmV0dXJuZWQt
YnktZF9vYnRhaW5fYWxpYXMtZml4dXAucGF0Y2gKcmVpc2VyNC11cGRhdGUtbmFtZXMtb2YtcXVv
dGEtbWV0aG9kcy5wYXRjaApyZWlzZXI0LXVzZS1zZXRfcGFnZV9kaXJ0eV9ub3RhZy5wYXRjaApm
cy1yZWlzZXI0LWFkZC1wYXJlbnRocy1hcm91bmQteC15LnBhdGNoCmZzLXJlaXNlcjQtY29udGV4
dGMtY3VycmVudF9pc19wZGZsdXNoLWdvdC1yZW1vdmVkLnBhdGNoCnJlaXNlcjQtZml4LnBhdGNo
CnJlaXNlcjQtcmVuYW1lLXBzY2hlZC10by1kaXNwYXRjaC5wYXRjaApyZWlzZXI0LWRyb3Atam91
cm5hbC1pbmZvLnBhdGNoCnJlaXNlcjQtZml4LWNvbXBpbGUtd2FybmluZ3MucGF0Y2gKcmVpc2Vy
NC1yZWR1Y2UtZnJhbWUtc2l6ZS1vZi1yZWlzZXI0X2luaXRfc3VwZXJfZGF0YS5wYXRjaApyZWlz
ZXI0LXJlZHVjZS1mcmFtZS1zaXplLW9mLXJlaXNlcjRfaW5pdF9zdXBlcl9kYXRhLWZpeHVwLnBh
dGNoCnJlaXNlcjQtZnJvbS0yLjYuMzEtcGF0Y2gucGF0Y2gKcmVpc2VyNC1wZGZsdXNoLWNvbW1l
bnRzLnBhdGNoCnJlaXNlcjQtZ2VuZXJpY19zeW5jX3NiX2lub2Rlcy5wYXRjaApyZWlzZXI0LXN5
bmNfaW5vZGVzLW51bGwtZGVyZWZlcmVuY2UucGF0Y2gK

--Multipart=_Sat__28_Nov_2009_08_14_40_+1300_n9OQJ.lR5ZJZ+BRR
Content-Type: text/x-patch;
 name="reiser4-from-2.6.31-patch.patch"
Content-Disposition: attachment;
 filename="reiser4-from-2.6.31-patch.patch"
Content-Transfer-Encoding: quoted-printable

From: Johannes Buchner <buchner.johannes@gmx.at>

some changes from reiser4-2.6.31 patch
from http://www.kernel.org/pub/linux/kernel/people/edward/reiser4/reiser4-f=
or-2.6/

Index: linux/fs/reiser4/carry.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/fs/reiser4/carry.c
+++ linux/fs/reiser4/carry.c
@@ -1095,7 +1095,7 @@ static void fatal_carry_error(carry_leve
  *
  * This function itself only manages changes in carry structures and deleg=
ates
  * all hard work (allocation of znode for new root, changes of parent and
- * sibling pointers to the reiser4_add_tree_root().
+ * sibling pointers) to the reiser4_add_tree_root().
  *
  * Locking: old tree root is locked by carry at this point. Fake znode is =
also
  * locked.
Index: linux/fs/reiser4/carry_ops.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/fs/reiser4/carry_ops.c
+++ linux/fs/reiser4/carry_ops.c
@@ -2015,7 +2015,7 @@ static int carry_estimate_bitmaps(void)
 		int bytes;
=20
 		bytes =3D capped_height() * (0 +	/* bnode should be added, but
-						 * its is private to bitmap.c,
+						 * it is private to bitmap.c,
 						 * skip for now. */
 					   2 * sizeof(jnode));
 						/* working and commit jnodes */
Index: linux/fs/reiser4/coord.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/fs/reiser4/coord.c
+++ linux/fs/reiser4/coord.c
@@ -36,12 +36,12 @@ void coord_normalize(coord_t *coord)
=20
 	coord_clear_iplug(coord);
=20
-	if (node_is_empty(node))
+	if (node_is_empty(node)) {
 		coord_init_first_unit(coord, node);
-	 else if ((coord->between =3D=3D AFTER_ITEM)
-		   || (coord->between =3D=3D AFTER_UNIT))
+	} else if ((coord->between =3D=3D AFTER_ITEM)
+		   || (coord->between =3D=3D AFTER_UNIT)) {
 		return;
-	 else if (coord->item_pos =3D=3D coord_num_items(coord)
+	} else if (coord->item_pos =3D=3D coord_num_items(coord)
 		   && coord->between =3D=3D BEFORE_ITEM) {
 		coord_dec_item_pos(coord);
 		coord->between =3D AFTER_ITEM;
Index: linux/fs/reiser4/entd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/fs/reiser4/entd.c
+++ linux/fs/reiser4/entd.c
@@ -241,7 +241,7 @@ static void entd_flush(struct super_bloc
 	if (rq->wbc->nr_to_write > 0) {
 		rq->wbc->range_start =3D 0;
 		rq->wbc->range_end =3D LLONG_MAX;
-		generic_sync_sb_inodes(rq->wbc);
+		generic_sync_sb_inodes(super, rq->wbc);
 	}
 	rq->wbc->nr_to_write =3D ENTD_CAPTURE_APAGE_BURST;
 	reiser4_writeout(super, rq->wbc);
Index: linux/fs/reiser4/super_ops.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/fs/reiser4/super_ops.c
+++ linux/fs/reiser4/super_ops.c
@@ -412,7 +412,7 @@ static void reiser4_sync_inodes(struct s
 	 * call reiser4_writepages for each of dirty inodes to turn dirty pages
 	 * into transactions if they were not yet.
 	 */
-	generic_sync_sb_inodes(wbc);
+	generic_sync_sb_inodes(super, wbc);
=20
 	/* flush goes here */
 	wbc->nr_to_write =3D to_write;
Index: linux/fs/reiser4/znode.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/fs/reiser4/znode.h
+++ linux/fs/reiser4/znode.h
@@ -18,7 +18,6 @@
=20
 #include <linux/types.h>
 #include <linux/spinlock.h>
-#include <linux/semaphore.h>
 #include <linux/pagemap.h>	/* for PAGE_CACHE_SIZE */
 #include <asm/atomic.h>
=20
Index: linux/include/linux/mm.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
@@ -836,6 +836,7 @@ int redirty_page_for_writepage(struct wr
 void account_page_dirtied(struct page *page, struct address_space *mapping=
);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
+int set_page_dirty_notag(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
=20
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
Index: linux/mm/filemap.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/mm/filemap.c
+++ linux/mm/filemap.c
@@ -139,6 +139,7 @@ void __remove_from_page_cache(struct pag
 		dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
 	}
 }
+EXPORT_SYMBOL(__remove_from_page_cache);
=20
 void remove_from_page_cache(struct page *page)
 {
@@ -151,6 +152,7 @@ void remove_from_page_cache(struct page=20
 	spin_unlock_irq(&mapping->tree_lock);
 	mem_cgroup_uncharge_cache_page(page);
 }
+EXPORT_SYMBOL(remove_from_page_cache);
=20
 static int sync_page(void *word)
 {
@@ -800,7 +802,6 @@ repeat:
 	rcu_read_unlock();
 	return ret;
 }
-EXPORT_SYMBOL(find_get_pages);
=20
 /**
  * find_get_pages_contig - gang contiguous pagecache lookup
@@ -970,6 +971,7 @@ static void shrink_readahead_size_eio(st
 {
 	ra->ra_pages /=3D 4;
 }
+EXPORT_SYMBOL(find_get_pages);
=20
 /**
  * do_generic_file_read - generic file read routine
Index: linux/mm/page-writeback.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/mm/page-writeback.c
+++ linux/mm/page-writeback.c
@@ -1143,6 +1143,32 @@ int __set_page_dirty_nobuffers(struct pa
 EXPORT_SYMBOL(__set_page_dirty_nobuffers);
=20
 /*
+ * set_page_dirty_notag() -- similar to __set_page_dirty_nobuffers()
+ * except it doesn't tag the page dirty in the page-cache radix tree.
+ * This means that the address space using this cannot use the regular
+ * filemap ->writepages() helpers and must provide its own means of
+ * tracking and finding non-tagged dirty pages.
+ *
+ * NOTE: furthermore, this version also doesn't handle truncate races.
+ */
+int set_page_dirty_notag(struct page *page)
+{
+	struct address_space *mapping =3D page->mapping;
+
+	if (!TestSetPageDirty(page)) {
+		unsigned long flags;
+		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
+		local_irq_save(flags);
+		account_page_dirtied(page, mapping);
+		local_irq_restore(flags);
+		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(set_page_dirty_notag);
+
+/*
  * When a writepage implementation decides that it doesn't want to write t=
his
  * page for some reason, it should redirty the locked page via
  * redirty_page_for_writepage() and it should then unlock the page and ret=
urn 0


--Multipart=_Sat__28_Nov_2009_08_14_40_+1300_n9OQJ.lR5ZJZ+BRR
Content-Type: text/x-patch;
 name="reiser4-pdflush-comments.patch"
Content-Disposition: attachment;
 filename="reiser4-pdflush-comments.patch"
Content-Transfer-Encoding: quoted-printable

From: Johannes Buchner <buchner.johannes@gmx.at>

some comments were still mentioning pdflush

diff --git a/fs/reiser4/context.c b/fs/reiser4/context.c
index eed3efa..f80ae13 100644
--- a/fs/reiser4/context.c
+++ b/fs/reiser4/context.c
@@ -147,7 +147,7 @@ static void reiser4_throttle_write_at(reiser4_context *=
context)
 	 * call balance_dirty_pages_ratelimited() to process formatted nodes
 	 * dirtied during this system call. Do that only if we are not in mount
 	 * and there were nodes dirtied in this context and we are not in
-	 * writepage (to avoid deadlock) and not in pdflush
+	 * writepage (to avoid deadlock)
 	 */
 	if (sbinfo !=3D NULL && sbinfo->fake !=3D NULL &&
 	    context->nr_marked_dirty !=3D 0 &&
diff --git a/fs/reiser4/txnmgr.c b/fs/reiser4/txnmgr.c
index 74b49f2..844d19e 100644
--- a/fs/reiser4/txnmgr.c
+++ b/fs/reiser4/txnmgr.c
@@ -1360,7 +1360,7 @@ static int txn_try_to_fuse_small_atom(txn_mgr * tmgr,=
 txn_atom * atom)
    code tries to flush current atom.
=20
    flush_some_atom() is called as part of memory clearing process. It is
-   invoked from balance_dirty_pages(), pdflushd, and entd.
+   invoked from balance_dirty_pages() and entd.
=20
    If we can flush no nodes, atom is committed, because this frees memory.
=20
@@ -1469,7 +1469,7 @@ flush_some_atom(jnode * start, long *nr_submitted, co=
nst struct writeback_contro
 			 * or atom is too old/large,
 			 * we force current atom to commit */
 			/* wait for commit completion but only if this
-			 * wouldn't stall pdflushd and ent thread. */
+			 * wouldn't stall ent thread. */
 			if (!wbc->nonblocking && !ctx->entd)
 				txnh->flags |=3D TXNH_WAIT_COMMIT;
 			atom->flags |=3D ATOM_FORCE_COMMIT;


--Multipart=_Sat__28_Nov_2009_08_14_40_+1300_n9OQJ.lR5ZJZ+BRR
Content-Type: text/x-patch;
 name="reiser4-generic_sync_sb_inodes.patch"
Content-Disposition: attachment;
 filename="reiser4-generic_sync_sb_inodes.patch"
Content-Transfer-Encoding: quoted-printable

From: Johannes Buchner <buchner.johannes@gmx.at>

generic_sync_sb_inodes doesn't exist anymore

Index: linux/fs/reiser4/entd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/fs/reiser4/entd.c
+++ linux/fs/reiser4/entd.c
@@ -241,7 +241,9 @@ static void entd_flush(struct super_bloc
 	if (rq->wbc->nr_to_write > 0) {
 		rq->wbc->range_start =3D 0;
 		rq->wbc->range_end =3D LLONG_MAX;
-		generic_sync_sb_inodes(super, rq->wbc);
+		writeback_inodes_sb(super);
+		if (rq->wbc->sync_mode =3D=3D WB_SYNC_ALL)
+			sync_inodes_sb(super);
 	}
 	rq->wbc->nr_to_write =3D ENTD_CAPTURE_APAGE_BURST;
 	reiser4_writeout(super, rq->wbc);
Index: linux/fs/reiser4/super_ops.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/fs/reiser4/super_ops.c
+++ linux/fs/reiser4/super_ops.c
@@ -412,7 +412,9 @@ static void reiser4_sync_inodes(struct s
 	 * call reiser4_writepages for each of dirty inodes to turn dirty pages
 	 * into transactions if they were not yet.
 	 */
-	generic_sync_sb_inodes(super, wbc);
+	writeback_inodes_sb(super);
+	if (wbc->sync_mode =3D=3D WB_SYNC_ALL)
+		sync_inodes_sb(super);
=20
 	/* flush goes here */
 	wbc->nr_to_write =3D to_write;


--Multipart=_Sat__28_Nov_2009_08_14_40_+1300_n9OQJ.lR5ZJZ+BRR
Content-Type: text/x-patch;
 name="reiser4-sync_inodes-null-dereference.patch"
Content-Disposition: attachment;
 filename="reiser4-sync_inodes-null-dereference.patch"
Content-Transfer-Encoding: quoted-printable

From: Johannes Buchner <buchner.johannes@gmx.at>

the parameter wbc=3DNULL caused a NULL pointer dereference in
reiser4_sync_inodes.

introduced in patch reiser4-vfs-add-super_operationssync_inodes
Index: linux/fs/reiser4/super_ops.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/fs/reiser4/super_ops.c
+++ linux/fs/reiser4/super_ops.c
@@ -395,7 +395,7 @@ static void reiser4_sync_inodes(struct s
 	reiser4_context *ctx;
 	long to_write;
=20
-	if (wbc->for_kupdate)
+	if (wbc =3D=3D NULL || wbc->for_kupdate)
 		/* reiser4 has its own means of periodical write-out */
 		return;
=20


--Multipart=_Sat__28_Nov_2009_08_14_40_+1300_n9OQJ.lR5ZJZ+BRR--

--Signature=_Sat__28_Nov_2009_08_14_40_+1300_OMWBIxwDEbQt.Dk.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAksQJSMACgkQ7X1+MfqVcr3d3ACffiQzj8qTU+LAAWpDhayPeMFy
Pn8An03yhYfoJvN9CfJy9EbOzPwZ0+pu
=r++X
-----END PGP SIGNATURE-----

--Signature=_Sat__28_Nov_2009_08_14_40_+1300_OMWBIxwDEbQt.Dk.--
