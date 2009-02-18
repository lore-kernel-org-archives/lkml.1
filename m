Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbZBRVsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbZBRVsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbZBRVgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:36:36 -0500
Received: from kroah.org ([198.145.64.141]:56439 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754254AbZBRVgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:36:04 -0500
Date: Wed, 18 Feb 2009 13:33:23 -0800
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
       alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org
Subject: [patch 37/39] jbd2: On a __journal_expect() assertion failure
	printk "JBD2", not "EXT3-fs"
Message-ID: <20090218213323.GL19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="jbd2-on-a-__journal_expect-assertion-failure-printk-jbd2-not-ext3-fs.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 08ec8c3878cea0bf91f2ba3c0badf44b383752d0)

Otherwise it can be very confusing to find a "EXT3-fs: " failure in
the middle of EXT4-fs failures, and it makes it harder to track the
source of the failure.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/jbd2.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -308,7 +308,8 @@ void buffer_assertion_failure(struct buf
 		int val = (expr);					     \
 		if (!val) {						     \
 			printk(KERN_ERR					     \
-				"EXT3-fs unexpected failure: %s;\n",# expr); \
+			       "JBD2 unexpected failure: %s: %s;\n",	     \
+			       __func__, #expr);			     \
 			printk(KERN_ERR why "\n");			     \
 		}							     \
 		val;							     \

