Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYELNhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYELNhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYELNhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:37:15 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:58479 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbYELNhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:37:13 -0400
Date: Mon, 12 May 2008 15:37:09 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/6] arch/ia64/kernel: remove null pointer dereference
Message-ID: <Pine.LNX.4.64.0805121536370.3694@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If data is NULL, it is not possible to access data->ret.

The problem was detected using the following semantic match
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

* if (E == NULL)
{
  ... when != if (E == NULL) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
--- a/arch/ia64/kernel/palinfo.c	2008-05-09 16:46:57.000000000 +0200
+++ b/arch/ia64/kernel/palinfo.c	2008-05-12 08:43:35.000000000 +0200
@@ -902,7 +902,6 @@ palinfo_smp_call(void *info)
 	palinfo_smp_data_t *data = (palinfo_smp_data_t *)info;
 	if (data == NULL) {
 		printk(KERN_ERR "palinfo: data pointer is NULL\n");
-		data->ret = 0; /* no output */
 		return;
 	}
 	/* does this actual call */
