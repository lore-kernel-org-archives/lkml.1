Return-Path: <linux-kernel-owner+w=401wt.eu-S1764223AbYEMU02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764223AbYEMU02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761259AbYEMUQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:16:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:38666 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbYEMUQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:16:57 -0400
Date: Tue, 13 May 2008 13:12:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 35/37] SCSI: aha152x: fix init suspiciously returned 1, it
	should follow 0/-E convention
Message-ID: <20080513201251.GJ31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-aha152x-fix-init-suspiciously-returned-1-it-should-follow-0-e-convention.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit ad2fa42d044b98469449880474a9662fb689f7f9 upstream

Reported-by: Frank de Jong <frapex@xs4all.nl>
> [1.] One line summary of the problem:
> linux-2.6.25.3, aha152x'->init suspiciously returned 1, it should
> follow 0/-E convention. The module / driver works okay. Unloading the
> module is impossible.

The driver is apparently returning 0 on failure and 1 on success.
That's a bit unfortunate.  Fix it by altering to -ENODEV and 0.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/aha152x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3835,7 +3835,7 @@ static int __init aha152x_init(void)
 			iounmap(p);
 		}
 		if (!ok && setup_count == 0)
-			return 0;
+			return -ENODEV;
 
 		printk(KERN_INFO "aha152x: BIOS test: passed, ");
 #else
@@ -3914,7 +3914,7 @@ static int __init aha152x_init(void)
 #endif
 	}
 
-	return 1;
+	return 0;
 }
 
 static void __exit aha152x_exit(void)

-- 
