Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbXA0RVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbXA0RVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 12:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbXA0RVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 12:21:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:33717 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXA0RVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 12:21:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=iTvDlQQBAC229PP2cxLXkzqmkhqx52LY+vCrdHR0dclTvJc44RN0VE5gTJyybRZY25/V3clOeNecrKE2/ZI0BNw7R6nMuiAkBFLc1MdY9JsUntl3kDYWu3874IvmgmS63tHFDYIeVSRIOdJp7O3OLB5E+S+++Atb5GQmr89VbvE=
Message-ID: <45BB89FB.5000104@googlemail.com>
Date: Sat, 27 Jan 2007 18:20:59 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
In-Reply-To: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@osdl.org napisał(a):
> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> 

git-scsi-misc.patch typo fix.

drivers/scsi/NCR_D700.c: In function ‘NCR_D700_probe_one’:
drivers/scsi/NCR_D700.c:203: error: ‘struct NCR_700_Host_Parameters’ has no member named ‘busrt_length’
make[2]: *** [drivers/scsi/NCR_D700.o] Błąd 1
make[1]: *** [drivers/scsi] Błąd 2
make: *** [drivers] Błąd 2

Regards,
Michal

--
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work-clean/drivers/scsi/NCR_D700.c	2007-01-26 16:47:36.000000000 +0100
+++ linux-work/drivers/scsi/NCR_D700.c	2007-01-27 18:13:42.000000000 +0100
@@ -200,7 +200,7 @@ NCR_D700_probe_one(struct NCR_D700_priva
 	hostdata->base = ioport_map(region, 64);
 	hostdata->differential = (((1<<siop) & differential) != 0);
 	hostdata->clock = NCR_D700_CLOCK_MHZ;
-	hostdata->busrt_length = 8;
+	hostdata->burst_length = 8;

 	/* and register the siop */
 	host = NCR_700_detect(&NCR_D700_driver_template, hostdata, p->dev);
