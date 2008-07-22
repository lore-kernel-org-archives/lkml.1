Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbYGVXYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbYGVXYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbYGVXTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:19:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:57695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257AbYGVXTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:19:12 -0400
Date: Tue, 22 Jul 2008 16:15:34 -0700
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
       Matthew Wilcox <willy@linux.intel.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 19/47] SCSI: ses: Fix timeout
Message-ID: <20080722231534.GT8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-ses-fix-timeout.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Matthew Wilcox <matthew@wil.cx>

commit c95e62ce8905aab62fed224eaaa9b8558a0ef652 upstream

Timeouts are measured in jiffies, not in seconds.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/ses.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -61,7 +61,7 @@ static int ses_probe(struct device *dev)
 	return err;
 }
 
-#define SES_TIMEOUT 30
+#define SES_TIMEOUT (30 * HZ)
 #define SES_RETRIES 3
 
 static int ses_recv_diag(struct scsi_device *sdev, int page_code,

-- 
