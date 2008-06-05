Return-Path: <linux-kernel-owner+w=401wt.eu-S1763397AbYFEVCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397AbYFEVCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYFEVB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:01:59 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:30561 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbYFEVB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=voOcdbR/4fCwu+fW6qDAGGCWNj9Ff0OTupTodhFGjv+4MyezxMBR0gqRYYjD/jt13A
         PSzeGZj/ke6wY+xYoBwSW4Hb+m8irLpNRD63kMcah2CsGaavCRO4v9aXzxjEEnkBd77k
         K67R2kMlOfOjR5PLv6stUTF4m5z7XASrz4jDA=
Message-ID: <dd18b0c30806051401j28a57871ke4e1c76a4c8ea425@mail.gmail.com>
Date: Thu, 5 Jun 2008 21:01:55 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: GPE storm detected, disabling EC GPE
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW I noticed a post where the person had changed 5 to 20, and it
seemed to work for them;
So with that in mind I decide to give that a go, here is the location:
drivers/acpi/ec.c
@@ -527,47 +488,51 @@ static u32 acpi_ec_gpe_handler(void *data)
 {
        acpi_status status = AE_OK;
        struct acpi_ec *ec = data;
       u8 state = acpi_ec_read_status(ec);

        pr_debug(PREFIX "~~~> interrupt\n");
       atomic_inc(&ec->irq_count);
-       if (atomic_read(&ec->irq_count) > 5) {
+       if (atomic_read(&ec->irq_count) > 20) {
               pr_err(PREFIX "GPE storm detected, disabling EC GPE\n");
               ec_switch_to_poll_mode(ec);
               goto end;
       }

Now I don't know if this will work for other brands, but for
me(Macbook Pro ATI chipset) I have not received the
GPE storm detected, disabling EC GPE message, but it's only been an
hour, maybe after two or three this might appear.
Also is this good or bad to set 5 to 20 for the system?
regards;

-- 
Justin P. Mattock
