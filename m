Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbYHRSuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbYHRSuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759255AbYHRStp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:49:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759252AbYHRSto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:49:44 -0400
Date: Mon, 18 Aug 2008 11:42:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Petr Vandrovec <VANDROVE@vc.cvut.cz>
Subject: [patch 12/60] matrox maven: fix a broken error path
Message-ID: <20080818184216.GM29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="matrox-maven-fix-a-broken-error-path.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit 5ede40f87957c6ededf9284c8339722a97b9dfb6 upstream

I broke an error path with d03c21ec0be7787ff6b75dcf56c0e96209ccbfbd,
sorry about that.

The machine will crash if the i2c_attach_client() or maven_init_client()
calls fail, although nobody has yet reported this happening.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/matrox/matroxfb_maven.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/matrox/matroxfb_maven.c
+++ b/drivers/video/matrox/matroxfb_maven.c
@@ -1266,7 +1266,7 @@ static int maven_detect_client(struct i2
 ERROR4:;
 	i2c_detach_client(new_client);
 ERROR3:;
-	kfree(new_client);
+	kfree(data);
 ERROR0:;
 	return err;
 }

-- 
