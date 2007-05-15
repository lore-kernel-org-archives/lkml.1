Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbXEOH7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbXEOH7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbXEOH67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:58:59 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:39896 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbXEOH66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:58:58 -0400
Date: Tue, 15 May 2007 09:57:24 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  8/14] Union-mount lookup
In-Reply-To: <20070514094218.GJ4139@in.ibm.com>
Message-ID: <Pine.LNX.4.61.0705150937590.9570@yvahk01.tjqt.qr>
References: <20070514093722.GB4139@in.ibm.com> <20070514094218.GJ4139@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 15:12, Bharata B Rao wrote:
> 
>+struct dentry * d_lookup_single(struct dentry *parent, struct qstr *name)
>+{
>+	struct dentry *dentry;
>+	unsigned long seq;
>+
>+        do {
>+                seq = read_seqbegin(&rename_lock);
>+                dentry = __d_lookup_single(parent, name);
>+                if (dentry)
>+			break;
>+	} while (read_seqretry(&rename_lock, seq));
>+	return dentry;
>+}

Replace with tabs.

>+lookup_union:
>+	do {
>+		struct vfsmount *mnt = find_mnt(topmost);
>+		UM_DEBUG_DCACHE("name=\"%s\", inode=%p, device=%s\n",
>+				topmost->d_name.name, topmost->d_inode,
>+				mnt->mnt_devname);
>+		mntput(mnt);
>+	} while (0);

Why the extra do{}while? [elsewhere too]

>+	if (topmost->d_union) {
>+		union_lock_spinlock(topmost, &topmost->d_lock);
>+	}

Extra {} could go [elsewhere too].

>+		if (last->d_overlaid
>+		    && (last->d_overlaid != dentry)) {

As can these extra () [elsewhere too].

>+static inline struct dentry * __lookup_hash_single(struct qstr *name, struct dentry *base, struct nameidata *nd)
>+{
>+	struct dentry *dentry;
>+	struct inode *inode;
>+	int err;
>+
>+	inode = base->d_inode;
>+
>+	err = permission(inode, MAY_EXEC, nd);
>+	dentry = ERR_PTR(err);
>+	if (err)
>+		goto out;
>+
>+	dentry = __lookup_hash_kern_single(name, base, nd);
>+out:
>+	return dentry;
>+}

This looks a little big for being inline.



	Jan
-- 
