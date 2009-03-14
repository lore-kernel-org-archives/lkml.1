Return-Path: <linux-kernel-owner+w=401wt.eu-S1765124AbZCNBwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765124AbZCNBwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZCNBVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:41 -0400
Received: from kroah.org ([198.145.64.141]:35676 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754230AbZCNBVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:08 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:44 2009
Message-Id: <20090314011044.109722459@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:03 -0700
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
Subject: [patch 086/114] V4L: tda8290: fix TDA8290 + TDA18271 initialization
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=0002-V4L-tda8290-fix-TDA8290-TDA18271-initialization.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

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
@@ -724,7 +724,8 @@ struct dvb_frontend *tda829x_attach(stru
 	fe->ops.analog_ops.info.name = name;
 
 	if (priv->ver & TDA8290) {
-		tda8290_init_tuner(fe);
+		if (priv->ver & (TDA8275 | TDA8275A))
+			tda8290_init_tuner(fe);
 		tda8290_init_if(fe);
 	} else if (priv->ver & TDA8295)
 		tda8295_init_if(fe);


