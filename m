Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYJFXXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYJFXXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbYJFXVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:21:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:55009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756748AbYJFXVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:21:44 -0400
Date: Mon, 6 Oct 2008 16:17:10 -0700
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
       alan@lxorguk.ukuu.org.uk, Sven Wegener <sven.wegener@stealer.net>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 06/28] i2c-dev: Return correct error code on class_create()
	failure
Message-ID: <20081006231710.GG20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i2c-dev-return-correct-error-code-on-class_create-failure.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Sven Wegener <sven.wegener@stealer.net>

In Linus' tree:
http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commit;h=e74783ec3cb981211689bd2cfd3248f8dc48ec01

We need to convert the error pointer from class_create(), else we'll return the
successful return code from register_chrdev() on failure.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/i2c-dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -574,8 +574,10 @@ static int __init i2c_dev_init(void)
 		goto out;
 
 	i2c_dev_class = class_create(THIS_MODULE, "i2c-dev");
-	if (IS_ERR(i2c_dev_class))
+	if (IS_ERR(i2c_dev_class)) {
+		res = PTR_ERR(i2c_dev_class);
 		goto out_unreg_chrdev;
+	}
 
 	res = i2c_add_driver(&i2cdev_driver);
 	if (res)

-- 
