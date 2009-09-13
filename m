Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZIMUgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZIMUgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 16:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbZIMUgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 16:36:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:49315 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZIMUgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 16:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NwsG7krqhjzhSrOcRnN7CsPuTEwbZKTUrT2iXxnMuDS16rRmid3bf8quXQdSq++YVh
         pooMaNusKaXiUARB5CEbomIZknLMwamnO4LAq5z8JdlMKhxvLqbQgJFXLDRM3OFQudal
         YDryAZS6Zc0umvER+mNXJOI/Zpbz8RCJFN554=
MIME-Version: 1.0
In-Reply-To: <1252873141-20496-1-git-send-email-felipe.contreras@gmail.com>
References: <1252873141-20496-1-git-send-email-felipe.contreras@gmail.com>
Date: Sun, 13 Sep 2009 23:36:50 +0300
Message-ID: <94a0d4530909131336i4612b0c0jf19adaa4e6c3f166@mail.gmail.com>
Subject: Re: [PATCH] omap3-iommu: reorganize
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Russell King <linux@arm.linux.org.uk>,
       "Tony Lindgren <tony@atomide.com> <tony@atomide.com>, Hiroshi DOYU
	<Hiroshi.DOYU@nokia.com>," <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 13, 2009 at 11:19 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> This way it's more object oriented and easier to see what is happening.
> No functional changes.
@@ -16,7 +16,7 @@

Sorry, I forgot to address some comments from Russell from a previous
version. I'll resend.

 struct iommu_device {
        resource_size_t base;
-       resource_size_t irq;
+       int irq;
        struct iommu_platform_data pdata;
        struct resource res[2];
 };
@@ -67,7 +67,7 @@ static int __init omap3_iommu_init(void)

                res[0].start = d->base;
                res[0].end = d->base + MMU_REG_SIZE - 1;
-               res[1].start = d->irq;
+               res[1].start = res[1].end = d->irq;

                err = platform_device_add_resources(pdev, res,
                                                    ARRAY_SIZE(res));

-- 
Felipe Contreras
