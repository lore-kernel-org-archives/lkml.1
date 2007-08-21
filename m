Return-Path: <linux-kernel-owner+w=401wt.eu-S1761844AbXHUPHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761844AbXHUPHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760755AbXHUPHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:07:43 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:10099 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760381AbXHUPHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:07:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PBHsKHYRu84O36E3UKAopwVR5tMbL3qAMsfuMVORVFMFJw1KK8Z8Y8kv70fFwEJlNUxIPMs90xk6ceU9pJnvIALEGsuzg13xhfpUXngAWezrq+sdqMDXlLaA7PdLTndClpVVvMSMqPbbJbGnIo2822TEOX1U+yUJ/y83KQs3NG4=
Date: Tue, 21 Aug 2007 23:07:14 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       astarikovskiy@suse.de, len.brown@intel.com,
       Andrew Morton <akpm@osdl.org>
Subject: [Git Patch] ACPI: Fix a warning of discarding qualifiers from
	pointer target type
Message-ID: <20070821150714.GA7591@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070821132038.GA22254@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821132038.GA22254@ff.dom.local>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix this warning:

drivers/acpi/ec.c: In function `acpi_ec_ecdt_probe':
drivers/acpi/ec.c:873: warning: passing arg 1 of `acpi_get_devices' discards qualifiers from pointer target type

(I don't know whether this fix hits the real problem.)

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 drivers/acpi/ec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.23-rc3-git3/drivers/acpi/ec.c
===================================================================
--- linux-2.6.23-rc3-git3.orig/drivers/acpi/ec.c
+++ linux-2.6.23-rc3-git3/drivers/acpi/ec.c
@@ -869,8 +869,8 @@ int __init acpi_ec_ecdt_probe(void)
 		boot_ec->handle = ACPI_ROOT_OBJECT;
 	} else {
 		printk(KERN_DEBUG PREFIX "Look up EC in DSDT\n");
-		status = acpi_get_devices(ec_device_ids[0].id, ec_parse_device,
-						boot_ec, NULL);
+		status = acpi_get_devices((char *)ec_device_ids[0].id,
+						ec_parse_device, boot_ec, NULL);
 		if (ACPI_FAILURE(status))
 			goto error;
 	}
