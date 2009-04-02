Return-Path: <linux-kernel-owner+w=401wt.eu-S934882AbZDBHE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882AbZDBHE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbZDBHDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:03:24 -0400
Received: from sous-sol.org ([216.99.217.87]:49081 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755469AbZDBHDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:03:22 -0400
Date: Wed, 1 Apr 2009 23:58:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Eugene Teo <eteo@redhat.com>, Justin Forbes <jmforbes@linuxtx.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, Jake Edge <jake@lwn.net>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>, hverkuil@xs4all.nl,
       g.liakhovetski@gmx.de, mchehab@redhat.com
Subject: [PATCH 49/45] V4L: v4l2-common: remove incorrect MODULE test
Message-ID: <20090402065815.GE18394@sequoia.sous-sol.org>
References: <20090331231045.719396245@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331231045.719396245@sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

upstream commit: d64260d58865004c6354e024da3450fdd607ea07

v4l2-common doesn't have to be a module for it to call request_module().
Just remove that test.

Without this patch loading ivtv as a module while v4l2-common is compiled
into the kernel will cause a delayed load of the i2c modules that ivtv
needs since request_module is never called directly.

While it is nice to see the delayed load in action, it is not so nice in
that ivtv fails to do a lot of necessary i2c initializations and will oops
later on with a division-by-zero.

Thanks to Mark Lord for reporting this and helping me figure out what was
wrong.

Thanks-to: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Thanks-to: Mark Lord <lkml@rtr.ca>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/media/video/v4l2-common.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -910,10 +910,10 @@ struct v4l2_subdev *v4l2_i2c_new_subdev(
 	struct i2c_board_info info;
 
 	BUG_ON(!dev);
-#ifdef MODULE
+
 	if (module_name)
 		request_module(module_name);
-#endif
+
 	/* Setup the i2c board info with the device type and
 	   the device address. */
 	memset(&info, 0, sizeof(info));
@@ -958,10 +958,10 @@ struct v4l2_subdev *v4l2_i2c_new_probed_
 	struct i2c_board_info info;
 
 	BUG_ON(!dev);
-#ifdef MODULE
+
 	if (module_name)
 		request_module(module_name);
-#endif
+
 	/* Setup the i2c board info with the device type and
 	   the device address. */
 	memset(&info, 0, sizeof(info));
