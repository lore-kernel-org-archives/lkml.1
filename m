Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbZLJIUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbZLJIUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760728AbZLJIUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:20:25 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:45784 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760723AbZLJIUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:20:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C+quPXXpigIoJDNOX9892Wiy64T3N6ULsznAKk79er0xce1CY5gewK1I9OZUz4EInK
         +9rab1WyNEMSfukmAiqXlOz/zxXG1p5yPPI78lrDN0oRLgXnMaQfW/QVBnZ4pGp+SVkS
         i5dy/BnuImo39xvknAto5uhkgMU+FrWBp/dBU=
Subject: Potential NULL pointer reference in platform_device_register()
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Thu, 10 Dec 2009 16:20:02 +0800
Message-ID: <1260433202.7913.24.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Greg KH,

Should we filter the potential NULL pointer in
platform_device_register() like this?

drivers/base/platform.c:

int platform_device_register(struct platform_device *pdev)
{
+	 if (!pdev)
+                return -EINVAL;

        device_initialize(&pdev->dev);
        return platform_device_add(pdev);
}
EXPORT_SYMBOL_GPL(platform_device_register);

Of course, the developers need to ensure they not register a NULL
platform device, but sometimes they will not know that.

Perhaps the above method will hide the real bug, so, what about BUG_ON(!
pdev).

Best Regards,
	Wu Zhangjin

