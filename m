Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbZCNApn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbZCNApn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbZCNATw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:52 -0400
Received: from kroah.org ([198.145.64.141]:34972 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752541AbZCNATi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:50 2009
Message-Id: <20090314000750.777191151@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:25 -0700
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
       alan@lxorguk.ukuu.org.uk, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 77/96] [PATCH] V4L: tda8290: fix TDA8290 + TDA18271 initialization
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=0002-V4L-tda8290-fix-TDA8290-TDA18271-initialization.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Krufky <mkrufky@linuxtv.org>

(cherry picked from commit 439b72b69e4992e9ec34b74304f0fa95623934eb)

Don't call tda8290_init_tuner unless we have either a TDA8275 or TDA8275A
present. Calling this function will cause a TDA18271 to get sick, so we
should only call it when needed.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/common/tuners/tda8290.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/common/tuners/tda8290.c
+++ b/drivers/media/common/tuners/tda8290.c
@@ -726,7 +726,8 @@ struct dvb_frontend *tda829x_attach(stru
 	fe->ops.analog_ops.info.name = name;
 
 	if (priv->ver & TDA8290) {
-		tda8290_init_tuner(fe);
+		if (priv->ver & (TDA8275 | TDA8275A))
+			tda8290_init_tuner(fe);
 		tda8290_init_if(fe);
 	} else if (priv->ver & TDA8295)
 		tda8295_init_if(fe);


