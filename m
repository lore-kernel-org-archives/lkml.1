Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbZJHF7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbZJHF7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 01:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZJHF7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 01:59:50 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:39641 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZJHF7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 01:59:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rWzHF6pmrwiT/iSGkNESbFLwPqInqDX9WqMN8ASJaHh8gi+MLi4/T7aEFwdrMP4cN7
         s5N+d/R/cWtPaTooB75FXXabjqHKs6uEwdA4Sp5OzSxLIu0dhTsnmi+V9HbqR+bEBzyI
         fbtnODJbrHyLEPJdJhP8Sm0hfNJIUoIgl4y30=
MIME-Version: 1.0
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C04B6A37960@SC-VEXCH1.marvell.com>
References: <20091006130202.5e18a332.sfr@canb.auug.org.au>
	 <25B60CDC2F704E4E9D88FFD52780CB4C04B6A3794F@SC-VEXCH1.marvell.com>
	 <20091006145425.a9cc611a.sfr@canb.auug.org.au>
	 <25B60CDC2F704E4E9D88FFD52780CB4C04B6A37960@SC-VEXCH1.marvell.com>
Date: Thu, 8 Oct 2009 01:59:12 -0400
Message-ID: <771cded00910072259m5aeaf900w376deb99b7f2b081@mail.gmail.com>
Subject: Re: linux-next: mfd tree build failure
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sfr@canb.auug.org.au
Cc: Samuel Ortiz <sameo@openedhand.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: 2009Äê10ÔÂ6ÈÕ 11:54 AM
> To: Haojian Zhuang
> Cc: Samuel Ortiz; linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Mark Brown
> Subject: Re: linux-next: mfd tree build failure
>
> Hi Haojian,
>
> On Mon, 5 Oct 2009 19:35:05 -0700 Haojian Zhuang <hzhuang1@marvell.com> wrote:
>>
>> Could you send your .config file to me? The 88pm8607 patch is just for mfd-2.6 git tree. I didn't try it in linux-next git tree before. I can try it now. If I could have your .config file, it would be better.
>
> I am sorry, but I don't have the exact .config file any more (I have
> moved on in my creation of linux-next)  however, as I said, this was an
> allmodconfig build on x86_64.  I also noted that CONFIG_I2C=m and
> CONFIG_MFD_CORE=m, while the config entry that controls the building of
> this driver is a bool so must have been 'y'.  So from a builtin driver,
> you are referring to symbols that are only defined in modules.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>

Hi Stephen & Samuel,

Please ignore the original fix patch on 88pm8607 dependancy. I write a
new patch on it and paste it in below. Please help to review it.

Thanks
Haojian

>From 26174b67184759ac2fe33748eeb43d3738732e21 Mon Sep 17 00:00:00 2001
From: Haojian Zhuang <haojian.zhuang@marvell.com>
Date: Thu, 8 Oct 2009 09:07:05 -0400
Subject: [PATCH] mfd: fix the dependancy of 88PM8607

88PM8607 module is dependant on I2C. I2C module must be built-in.

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
-       depends on I2C
+       depends on I2C=y
        select MFD_CORE
        help
          This supports for Marvell 88PM8607 Power Management IC. This includes
--
1.5.6.5
