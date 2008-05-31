Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbYEaNf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbYEaNf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 09:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYEaNfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 09:35:19 -0400
Received: from mx1.riseup.net ([204.13.164.18]:58830 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYEaNfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 09:35:18 -0400
Date: Sat, 31 May 2008 15:35:11 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 1/2] MTD: use list_for_each_entry() in add_mtd_device()
Message-ID: <20080531133511.GA8734@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	dwmw2@infradead.org, linux-mtd@lists.infradead.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20080531132808.644758754@kaehlcke.net> <20080531132808.984625508@kaehlcke.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531132808.984625508@kaehlcke.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry, i forgot to tell quilt to refresh the patch, here comes the
good one

--

MTD: use list_for_each_entry() instead of list_for_each() in add_mtd_device()

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Index: linux-2.6/drivers/mtd/mtdcore.c
===================================================================
--- linux-2.6.orig/drivers/mtd/mtdcore.c        2008-05-31
15:31:17.000000000 +0200
+++ linux-2.6/drivers/mtd/mtdcore.c     2008-05-31 15:32:19.000000000
+0200
@@ -53,7 +53,7 @@

        for (i=0; i < MAX_MTD_DEVICES; i++)
                if (!mtd_table[i]) {
-                       struct list_head *this;
+                       struct mtd_notifier *not;

                        mtd_table[i] = mtd;
                        mtd->index = i;
@@ -72,8 +72,7 @@
                        DEBUG(0, "mtd: Giving out device %d to
												%s\n",i, mtd->name);
                        /* No need to get a refcount on the module
												containing
                           the notifier, since we hold the
													 mtd_table_mutex */
-                       list_for_each(this, &mtd_notifiers) {
-                               struct mtd_notifier *not =
list_entry(this, struct mtd_notifier, list);
+                       list_for_each_entry(not, &mtd_notifiers, list)
{
                                not->add(mtd);
                        }

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

    I am incapable of conceiving infinity, and yet I do not accept finity
                          (Simone de Beauvoir)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
