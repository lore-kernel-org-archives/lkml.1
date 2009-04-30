Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbZD3ROf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbZD3ROf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764292AbZD3RHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:33 -0400
Received: from kroah.org ([198.145.64.141]:56273 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764352AbZD3RH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:40 2009
Message-Id: <20090430165740.804413330@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:06 -0700
From: Greg KH <gregkh@suse.de>
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
       Jonathan Corbet <corbet@lwn.net>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 17/88] Add a missing unlock_kernel() in raw_open()
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0032-Add-a-missing-unlock_kernel-in-raw_open.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

upstream commit: 996ff68d8b358885c1de82a45517c607999947c7

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
 


