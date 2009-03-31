Return-Path: <linux-kernel-owner+w=401wt.eu-S1765225AbZCaXf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765225AbZCaXf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764129AbZCaXV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:21:57 -0400
Received: from sous-sol.org ([216.99.217.87]:33299 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764105AbZCaXV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:21:56 -0400
Message-Id: <20090331231719.586886888@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:20 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dan Carpenter <error27@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>
Subject: [patch 35/45] Add a missing unlock_kernel() in raw_open()
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=add-a-missing-unlock_kernel-in-raw_open.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dan Carpenter <error27@gmail.com>

upstream commit: 996ff68d8b358885c1de82a45517c607999947c7

Cc: stable@kernel.org
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/char/raw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -90,6 +90,7 @@ out1:
 	blkdev_put(bdev, filp->f_mode);
 out:
 	mutex_unlock(&raw_mutex);
+	unlock_kernel();
 	return err;
 }
 

