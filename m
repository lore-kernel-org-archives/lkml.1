Return-Path: <linux-kernel-owner+w=401wt.eu-S1764293AbYBOI5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764293AbYBOI5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYBOI5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:57:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYBOI47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:56:59 -0500
Reply-To: <kmpark@infradead.org>
From: "Kyungmin Park" <kmpark@infradead.org>
To: <joakim.tjernlund@transmode.se>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <004601c86fa2$201a78d0$1fa9580a@swcenter.sec.samsung.co.kr> <1203065237.5419.74.camel@gentoo-jocke.transmode.se>
Subject: RE: Abnormal behavior with JFFS2 on latest kernel
Date: Fri, 15 Feb 2008 17:56:56 +0900
Organization: infradead
Message-ID: <005001c86fb0$b9bc6d00$1fa9580a@swcenter.sec.samsung.co.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-reply-to: <1203065237.5419.74.camel@gentoo-jocke.transmode.se>
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-index: Achvr2e2axSxc73/SxGdWn4OqdtwyQAARn0w
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I got following messages.
> > INFO: task pdflush:56 blocked for more than 120 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >
> > What are the meanings?
> > Too mush running GC in JFFS2 or others?
> >
> > BR,
> > Kyungmin Park
> 
> It is probably erasing lots of blocks and that takes a while, minutes
> some times. I once sent a patch to address this but the patch is racy
> w.r.t module unload. Look in the archive after patches from me.
> 

You mean this one?
diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index d1d4f27..b2e71c7 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -115,7 +115,7 @@ static inline void jffs2_refile_wbuf_blocks(struct jffs2_sb_

                D1(printk(KERN_DEBUG "Removing eraseblock at 0x%08x from erasabl
                list_del(this);
-               if ((jiffies + (n++)) & 127) {
+               if ((jiffies + (n++)) & 127 && !list_empty(&c->erasable_list)) {
                        /* Most of the time, we just erase it immediately. Other
                           spend ages scanning it on mount, etc. */
                        D1(printk(KERN_DEBUG "...and adding to erase_pending_lis

It's already applied, but it's same.

BR,
Kyungmin Park

