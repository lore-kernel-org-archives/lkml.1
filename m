Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbZDRKi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbZDRKi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 06:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbZDRKiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 06:38:16 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:36656 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbZDRKiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 06:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=lrmy1e5z4eYACqwjVFi5RRtmpNRksfGH1LY8qU59eOyCghpvNgHjI8ImdtmPm27GkK
         9imPB1R2h5y/wNlFhIpHVH/WAZm63nTj7IX1YhZ1ofa8kBY9W48r+La7NlJYLUY5s8jN
         h3Au2Ab0Ftz0qiFhIkWwyt3zoa2oszmtXFbZ0=
Date: Sat, 18 Apr 2009 18:36:42 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Subject: [PATCH]fix a warning on drivers/scsi/NCR_D700.c
Message-ID: <20090418103642.GA4432@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix this warning:

drivers/scsi/NCR_D700.c: In function ‘NCR_D700_probe’:
drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of ‘request_irq’ from incompatible pointer type
drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of ‘request_irq’ from incompatible pointer type
drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of ‘request_irq’ from incompatible pointer type


Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 drivers/scsi/NCR_D700.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index c889d84..1cdf09a 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -224,7 +224,7 @@ NCR_D700_probe_one(struct NCR_D700_private *p, int siop, int irq,
 	return ret;
 }
 
-static int
+static irqreturn_t
 NCR_D700_intr(int irq, void *data)
 {
 	struct NCR_D700_private *p = (struct NCR_D700_private *)data;
-- 
1.5.6.5

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn
