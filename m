Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbYFLEQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbYFLEQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 00:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYFLEQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 00:16:09 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:65133 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbYFLEP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 00:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=GaXtHt778mzxgQBZIZb9ZWJcPwmVIfgMNmuuAt+jwlWrxggJ63rK1IhkaeaPFWWtBj
         FpsphFMl+VGiuufHYChljDYAJx+Usm0ZdtDoBJCAnxhbSNP7XLzWO897rmkCcpwO0YGI
         Rw0rlXgbSnv3wDmDah+Yr7jxwQQk6npMO1jfc=
Message-ID: <4850A2F8.3050404@gmail.com>
Date: Thu, 12 Jun 2008 13:15:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: macbook pro dvd playback after suspend Buffer I/O error
References: <dd18b0c30804032207u36bd1f43l358e9949f0c94f79@mail.gmail.com>	 <20080404012147.abf8a598.akpm@linux-foundation.org>	 <484F31B8.8030001@gmail.com>	 <dd18b0c30806110045s6d19a034yd89b892441bd1621@mail.gmail.com>	 <dd18b0c30806111131gc1b506cva12f577ebb4afdf9@mail.gmail.com>	 <485048EC.2080608@gmail.com>	 <dd18b0c30806111527x22fa895em230ceade4712f073@mail.gmail.com>	 <4850794F.3000200@gmail.com>	 <dd18b0c30806111910j4b127c32rbd546f885731e18c@mail.gmail.com> <dd18b0c30806111913gf505c05j479a6a682c2cdd28@mail.gmail.com>
In-Reply-To: <dd18b0c30806111913gf505c05j479a6a682c2cdd28@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------020908080006080203010206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020908080006080203010206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

Please do the followings.

1. apply the attached patch
2. turn on device drivers -> SCSI -> SCSI verbose logging
3. rebuild the kernel and boot the new kernel.
4. run "sysctl -w dev.scsi.logging_level=1"
5. run the suspend/resume test w/ dd and report the result.

Thanks.

-- 
tejun

--------------020908080006080203010206
Content-Type: text/plain;
 name="debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="debug"

---
 drivers/ata/libata-eh.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: work/drivers/ata/libata-eh.c
===================================================================
--- work.orig/drivers/ata/libata-eh.c
+++ work/drivers/ata/libata-eh.c
@@ -2507,6 +2507,9 @@ static int atapi_eh_clear_ua(struct ata_
 			return -EIO;
 		}
 
+		ata_dev_printk(dev, KERN_WARNING, "XXX: TUR err_mask=0x%x sense_key=0x%x\n",
+			       err_mask, sense_key);
+
 		if (!err_mask || sense_key != UNIT_ATTENTION)
 			return 0;
 
@@ -2516,6 +2519,9 @@ static int atapi_eh_clear_ua(struct ata_
 				"UNIT ATTENTION (err_mask=0x%x)\n", err_mask);
 			return -EIO;
 		}
+
+		ata_dev_printk(dev, KERN_WARNING, "XXX: REQUEST SENSE err_mask=0x%x ASC=0x%x ASCQ=0x%x\n",
+			       err_mask, sense_buffer[12], sense_buffer[13]);
 	}
 
 	ata_dev_printk(dev, KERN_WARNING,

--------------020908080006080203010206--
