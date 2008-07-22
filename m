Return-Path: <linux-kernel-owner+w=401wt.eu-S1759299AbYGVX3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbYGVX3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbYGVXUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:20:14 -0400
Received: from ns2.suse.de ([195.135.220.15]:57944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737AbYGVXUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:20:12 -0400
Date: Tue, 22 Jul 2008 16:16:45 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Matt Porter <mporter@kernel.crashing.org>
Subject: [patch 33/47] rapidio: fix device reference counting
Message-ID: <20080722231645.GH8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rapidio-fix-device-reference-counting.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Eugene Surovegin <ebs@ebshome.net>

commit a7de3902edce099e4102c1272ec0ab569c1791f7 upstream

Fix RapidIO device reference counting.

Signed-of-by: Eugene Surovegin <ebs@ebshome.net>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rapidio/rio-driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rapidio/rio-driver.c
+++ b/drivers/rapidio/rio-driver.c
@@ -101,8 +101,8 @@ static int rio_device_probe(struct devic
 		if (error >= 0) {
 			rdev->driver = rdrv;
 			error = 0;
+		} else
 			rio_dev_put(rdev);
-		}
 	}
 	return error;
 }

-- 
