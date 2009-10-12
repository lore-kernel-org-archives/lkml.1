Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZJLCvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZJLCvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 22:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZJLCve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 22:51:34 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:48552 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZJLCvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 22:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k2XNzRtoSx9tF+M3dpda971790gKteTM2MIi/qJ6rEEfeN16tUmaElrODZlNAR1CAD
         ddtsQnNNDy+5QM/HgZ3YKr0lwdrhS7/5FRq5ubeKNwylJKWmJrFhhH59jV+k/GLBsSgS
         RJ1an0C8hCcxOsfbQ651f6T2qsVPfDGJh54os=
MIME-Version: 1.0
In-Reply-To: <20091012132628.2f709e40.sfr@canb.auug.org.au>
References: <20091012132628.2f709e40.sfr@canb.auug.org.au>
Date: Sun, 11 Oct 2009 22:50:54 -0400
Message-ID: <771cded00910111950y6104fe0fl4f1d10144d938243@mail.gmail.com>
Subject: Re: linux-next: voltage tree build failure
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@openedhand.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 10:26 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Liam,
>
> Today's linux-next build (x86_64 allmodconfig) failed like this:
>
> drivers/built-in.o: In function `pm8607_write_device':
> 88pm8607.c:(.text+0xd1359): undefined reference to `i2c_master_send'
> drivers/built-in.o: In function `pm8607_read_device':
> 88pm8607.c:(.text+0xd13ab): undefined reference to `i2c_master_send'
> 88pm8607.c:(.text+0xd13cc): undefined reference to `i2c_master_recv'
> drivers/built-in.o: In function `pm8607_init':
> 88pm8607.c:(.init.text+0xaa22): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `pm8607_probe':
> 88pm8607.c:(.devinit.text+0x50fb): undefined reference to `mfd_add_devices'
> drivers/built-in.o: In function `pm8607_exit':
> 88pm8607.c:(.exit.text+0x5de): undefined reference to `i2c_del_driver'
> drivers/built-in.o: In function `pm8607_remove':
> 88pm8607.c:(.devexit.text+0x1cc): undefined reference to `mfd_remove_devices'
>
> Caused by commit 258e3427f83a573d738344c2f5499da5e026e1df ("regulator:
> add 88PM8607 PMIC driver").  This is the same driver that has caused the
> mfd tree to fail in the same way since next-20091006.  I have used the
> version of the voltage tree from next-20091009 for today.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>

Hi Samuel & Liam,

Please help review and merge this fix patch. I'm sorry for inconvience.

Stephen,

Thanks for your check.

>From b7d3707263598c4c6671ac592eaaf13535a7b96a Mon Sep 17 00:00:00 2001
From: Haojian Zhuang <haojian.zhuang@marvell.com>
Date: Tue, 6 Oct 2009 08:08:37 -0400
Subject: [PATCH] mfd: fix the dependancy issue on 88PM8607

88PM8607 depends on I2C and MFD_CORE. Since 88PM8607 is built-in
kernel, it also requires that I2C and MFD_CORE are built-in
kernel also.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fbe684b..00064e2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -307,7 +307,7 @@ config EZX_PCAP

 config MFD_88PM8607
 	bool "Support Marvell 88PM8607"
-	depends on I2C
+	depends on I2C=y
 	select MFD_CORE
 	help
 	  This supports for Marvell 88PM8607 Power Management IC. This includes
-- 
1.5.6.5


Best Regards
Haojian
