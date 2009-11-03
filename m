Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbZKCX1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbZKCX1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZKCX1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:27:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:29918 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZKCX1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:27:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=aoFddUy0SAC2+Z49f6c+g42L2fuciUxgWFZAw7sloSOfJ+KLWF5ri5O+6pfpBZ5MGC
         IfsXg0j8UeUHb5Yugf8CE2bGfwZWhyKIG1J8dluCpNZEY9AM1jH4g/Z7Jm69cSSCjAWD
         ixFp+0iCqdpkEbs2H+vYvwkZPSl8JzwwIsGnY=
Message-ID: <4AF0BF04.9030203@gmail.com>
Date: Wed, 04 Nov 2009 00:38:44 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "James E.J. Bottomley" <James.Bottomley@suse.de>,
       linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] qlogicpti: add missing parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`+' has a higher precedence than `?' so the condition always
evaluates to true and this is preprocessed to `7*((ql) - 1)'

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/qlogicpti.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

This one must be right, I think.

QLOGICPTI_MAX_SG is used here:

drivers/scsi/qlogicpti.c:964:   host->sg_tablesize = QLOGICPTI_MAX_SG(num_free);
drivers/scsi/qlogicpti.c:1288:  .sg_tablesize           = QLOGICPTI_MAX_SG(QLOGICPTI_REQ_QUEUE_LEN),

Thanks, Roel

diff --git a/drivers/scsi/qlogicpti.h b/drivers/scsi/qlogicpti.h
index 9c053bb..e3c74d1 100644
--- a/drivers/scsi/qlogicpti.h
+++ b/drivers/scsi/qlogicpti.h
@@ -43,7 +43,7 @@
  * determined for each queue request anew.
  */
 #define QLOGICPTI_REQ_QUEUE_LEN	255	/* must be power of two - 1 */
-#define QLOGICPTI_MAX_SG(ql)	(4 + ((ql) > 0) ? 7*((ql) - 1) : 0)
+#define QLOGICPTI_MAX_SG(ql)	(4 + (((ql) > 0) ? 7*((ql) - 1) : 0))
 
 /* mailbox command complete status codes */
 #define MBOX_COMMAND_COMPLETE		0x4000
