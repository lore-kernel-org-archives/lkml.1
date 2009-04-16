Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZDPKmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZDPKmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZDPKmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:42:44 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40535 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZDPKmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:42:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=NtLOlPUR8xPFEsLvRVj1YTi3vDkfsnzrAVf966dW9MAE41jYL6EeH9I9DzetwmVKYA
         sj4I7IirJuVHHONku6WH/mj2ezfBBdSMYKgJ35kRvsGSQT9M3a4yMLrcQt7KCKSwaPAd
         4nbO3/SGssYnPBML3TgrpNUC5CDocehZ2oxZY=
Date: Thu, 16 Apr 2009 12:42:36 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, menage@google.com,
       balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
       dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, lizf@cn.fujitsu.com, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
Message-ID: <20090416104234.GA6656@linux>
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ryo Tsuruta <ryov@valinux.co.jp>, menage@google.com,
	balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
	agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
	baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
	dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
	taka@valinux.co.jp, lizf@cn.fujitsu.com, matt@bluehost.com,
	dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
	roberto@unbit.it, s-uchida@ap.jp.nec.com,
	subrata@linux.vnet.ibm.com, yoshikawa.takuya@oss.ntt.co.jp,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1239740480-28125-4-git-send-email-righi.andrea@gmail.com> <20090415111528.b796519a.kamezawa.hiroyu@jp.fujitsu.com> <20090415093716.GA5968@linux> <20090415.213850.226770691.ryov@valinux.co.jp> <20090415132356.GA19270@linux> <20090416085814.8b6d077f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416085814.8b6d077f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 08:58:14AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 15 Apr 2009 15:23:57 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
> > On Wed, Apr 15, 2009 at 09:38:50PM +0900, Ryo Tsuruta wrote:
> > > Hi Andrea and Kamezawa-san,
> > > 
> > > > Ryo, it would be great if you can look at this and fix/integrate into
> > > > the mainstream bio-cgroup. Otherwise I can try to to schedule this in my
> > > > work.
> > > 
> > > O.K. I'll apply those fixes and post patches as soon as I can.
> > > 
> > 
> > Very good! I've just tested the bio_cgroup_id inclusion in
> > page_cgroup->flags. I'm posting the patch on-top-of my patchset.
> > 
> > If you're interested, it should apply cleanly to the original
> > bio-cgroup, except for the get/put_cgroup_from_page() part.
> > 
> > Thanks,
> > -Andrea
> > ---
> > bio-cgroup: encode bio_cgroup_id in page_cgroup->flags
> > 
> > Encode the bio_cgroup_id into the flags argument of page_cgroup as
> > suggested by Kamezawa.
> > 
> > Lower 16-bits of the flags attribute are used for the actual page_cgroup
> > flags. The rest is reserved to store the bio-cgroup id.
> > 
> > This allows to save 4 bytes (in 32-bit architectures) or 8 bytes (in
> > 64-bit) for each page_cgroup element.
> > 
> > Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> > ---
> >  include/linux/biotrack.h    |    2 +-
> >  include/linux/page_cgroup.h |   24 +++++++++++++++++++++---
> >  mm/biotrack.c               |   26 ++++++++++++--------------
> >  3 files changed, 34 insertions(+), 18 deletions(-)
> > 
> > diff --git a/include/linux/biotrack.h b/include/linux/biotrack.h
> > index 25b8810..4bd0242 100644
> > --- a/include/linux/biotrack.h
> > +++ b/include/linux/biotrack.h
> > @@ -28,7 +28,7 @@ struct bio_cgroup {
> >  
> >  static inline void __init_bio_page_cgroup(struct page_cgroup *pc)
> >  {
> > -	pc->bio_cgroup_id = 0;
> > +	page_cgroup_set_bio_id(pc, 0);
> >  }
> >  
> >  extern struct cgroup *get_cgroup_from_page(struct page *page);
> > diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> > index 00a49c5..af780a4 100644
> > --- a/include/linux/page_cgroup.h
> > +++ b/include/linux/page_cgroup.h
> > @@ -16,12 +16,30 @@ struct page_cgroup {
> >  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
> >  	struct mem_cgroup *mem_cgroup;
> >  #endif
> > -#ifdef CONFIG_CGROUP_BIO
> > -	int bio_cgroup_id;
> > -#endif
> >  	struct list_head lru;		/* per cgroup LRU list */
> >  };
> >  
> > +#ifdef CONFIG_CGROUP_BIO
> > +/*
> > + * use lower 16 bits for flags and reserve the rest for the bio-cgroup id
> > + */
> > +#define BIO_CGROUP_ID_SHIFT	(16)
> > +#define BIO_CGROUP_ID_BITS (8 * sizeof(unsigned long) - BIO_CGROUP_ID_SHIFT)
> > +
> > +static inline unsigned long page_cgroup_get_bio_id(struct page_cgroup *pc)
> > +{
> > +	return pc->flags >> BIO_CGROUP_ID_SHIFT;
> > +}
> > +
> > +static inline void page_cgroup_set_bio_id(struct page_cgroup *pc,
> > +				unsigned long id)
> > +{
> > +	WARN_ON(id >= (1UL << BIO_CGROUP_ID_BITS));
> > +	pc->flags &= (1UL << BIO_CGROUP_ID_SHIFT) - 1;
> > +	pc->flags |= (unsigned long)(id << BIO_CGROUP_ID_SHIFT);
> > +}
> > +#endif
> > +
> Ah, there is "Lock" bit in pc->flags and above "set" code does read-modify-write
> without lock_page_cgroup().
> 
> Could you use lock_page_cgroup() or cmpxchg ? (or using something magical technique ?)

If I'm not wrong this should guarantee atomicity without using
lock_page_cgroup().

Thanks,
-Andrea
---
bio-cgroup: encode bio_cgroup_id in page_cgroup->flags

Encode the bio_cgroup_id into the flags argument of page_cgroup as
suggested by Kamezawa.

Lower 16 bits (in 32-bit archs) or lower 32 bits (in 64-bit archs) of
the flags attribute are used for the actual page_cgroup flags. The upper
bits are reserved to store the bio-cgroup id.

This allows to save 4 bytes (in 32-bit architectures) or 8 bytes (in
64-bit) for each page_cgroup element.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 include/linux/page_cgroup.h |   42 +++++++++++++++++++++++++++++++++++++-----
 mm/biotrack.c               |   24 +++++++++++-------------
 2 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index a7249bb..864ad6f 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -16,14 +16,46 @@ struct page_cgroup {
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 	struct mem_cgroup *mem_cgroup;
 #endif
-#ifdef CONFIG_CGROUP_BIO
-	int bio_cgroup_id;
-#endif
-#if defined(CONFIG_CGROUP_MEM_RES_CTLR) || defined(CONFIG_CGROUP_BIO)
 	struct list_head lru;		/* per cgroup LRU list */
-#endif
 };
 
+#ifdef CONFIG_CGROUP_BIO
+/*
+ * Use the lower 16 bits (in 32-bit archs) or lower 32 bits (in 64-bit archs)
+ * of page_cgroup->flags for the actual flags and reserve the rest for the
+ * bio-cgroup id.
+ *
+ * This allows to atomically read and write the bio-cgroup id without using
+ * lock/unlock_page_cgroup().
+ */
+#if defined(CONFIG_64BIT)
+typedef uint32_t bio_cgroup_id_t;
+#elif defined(CONFIG_32BIT)
+typedef uint16_t bio_cgroup_id_t;
+#else
+#error "unsupported architecture"
+#endif
+
+#define BIO_CGROUP_ID_SHIFT	(sizeof(bio_cgroup_id_t) * 8)
+#define BIO_CGROUP_ID_BITS	(sizeof(bio_cgroup_id_t) * 8)
+#define BIO_CGROUP_ID_MASK	((1UL << BIO_CGROUP_ID_BITS) - 1)
+
+static inline unsigned long page_cgroup_get_bio_id(struct page_cgroup *pc)
+{
+	return (pc->flags >> BIO_CGROUP_ID_SHIFT) & BIO_CGROUP_ID_MASK;
+}
+
+static inline void page_cgroup_set_bio_id(struct page_cgroup *pc,
+				unsigned long id)
+{
+	bio_cgroup_id_t *ptr = (bio_cgroup_id_t *)((unsigned char *)&pc->flags +
+					(BIO_CGROUP_ID_SHIFT / 8));
+
+	WARN_ON(id >= (1UL << BIO_CGROUP_ID_BITS));
+	*ptr = (bio_cgroup_id_t)id;
+}
+#endif /* CONFIG_CGROUP_BIO */
+
 void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
 void __init page_cgroup_init(void);
 struct page_cgroup *lookup_page_cgroup(struct page *page);
diff --git a/mm/biotrack.c b/mm/biotrack.c
index d3a35f1..01f83ba 100644
--- a/mm/biotrack.c
+++ b/mm/biotrack.c
@@ -80,7 +80,7 @@ void bio_cgroup_set_owner(struct page *page, struct mm_struct *mm)
 	if (unlikely(!pc))
 		return;
 
-	pc->bio_cgroup_id = 0;	/* 0: default bio_cgroup id */
+	__init_bio_page_cgroup(pc);
 	if (!mm)
 		return;
 	/*
@@ -93,11 +93,11 @@ void bio_cgroup_set_owner(struct page *page, struct mm_struct *mm)
 		goto out;
 	/*
 	 * css_get(&bio->css) isn't called to increment the reference
-	 * count of this bio_cgroup "biog" so pc->bio_cgroup_id might turn
-	 * invalid even if this page is still active.
-	 * This approach is chosen to minimize the overhead.
+	 * count of this bio_cgroup "biog" so the bio-cgroup id might turn
+	 * invalid even if this page is still active. This approach is chosen
+	 * to minimize the overhead.
 	 */
-	pc->bio_cgroup_id = biog->id;
+	page_cgroup_set_bio_id(pc, biog->id);
 out:
 	rcu_read_unlock();
 }
@@ -110,7 +110,7 @@ void bio_cgroup_reset_owner(struct page *page, struct mm_struct *mm)
 	/*
 	 * A little trick:
 	 * Just call bio_cgroup_set_owner() for pages which are already
-	 * active since the bio_cgroup_id member of page_cgroup can be
+	 * active since the bio-cgroup id member of page_cgroup can be
 	 * updated without any locks. This is because an integer type of
 	 * variable can be set a new value at once on modern cpus.
 	 */
@@ -146,12 +146,10 @@ void bio_cgroup_copy_owner(struct page *npage, struct page *opage)
 	opc = lookup_page_cgroup(opage);
 	if (unlikely(!opc))
 		return;
-
 	/*
-	 * Do this without any locks. The reason is the same as
-	 * bio_cgroup_reset_owner().
+	 * XXX: is it safe to do this without locking?
 	 */
-	npc->bio_cgroup_id = opc->bio_cgroup_id;
+	page_cgroup_set_bio_id(npc, page_cgroup_get_bio_id(opc));
 }
 
 /* Create a new bio-cgroup. */
@@ -248,7 +246,7 @@ struct cgroup *get_cgroup_from_page(struct page *page)
 	if (!pc)
 		return NULL;
 	lock_page_cgroup(pc);
-	biog = find_bio_cgroup(pc->bio_cgroup_id);
+	biog = find_bio_cgroup(page_cgroup_get_bio_id(pc));
 	if (biog) {
 		css_get(&biog->css);
 		cgrp = biog->css.cgroup;
@@ -266,7 +264,7 @@ void put_cgroup_from_page(struct page *page)
 	if (!pc)
 		return;
 	lock_page_cgroup(pc);
-	biog = find_bio_cgroup(pc->bio_cgroup_id);
+	biog = find_bio_cgroup(page_cgroup_get_bio_id(pc));
 	if (biog)
 		css_put(&biog->css);
 	unlock_page_cgroup(pc);
@@ -281,7 +279,7 @@ int get_bio_cgroup_id(struct bio *bio)
 
 	pc = lookup_page_cgroup(page);
 	if (pc)
-		id = pc->bio_cgroup_id;
+		id = page_cgroup_get_bio_id(pc);
 	return id;
 }
 EXPORT_SYMBOL(get_bio_cgroup_id);
