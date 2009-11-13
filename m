Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZKMP14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZKMP14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbZKMP1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:27:51 -0500
Received: from mail.atmel.fr ([81.80.104.162]:64371 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753471AbZKMP1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:27:50 -0500
Message-ID: <4AFD7AE5.9010901@atmel.com>
Date: Fri, 13 Nov 2009 16:27:33 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>, plagnioj@jcrosoft.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       avictor.za@gmail.com
Subject: Re: [RFC PATCH] atmel_lcdfb Kconfig: remove long dependency line
References: <4A40D695.5000302@atmel.com> <1245767456-6434-1-git-send-email-nicolas.ferre@atmel.com> <20090623153556.0e574899@hskinnemoen-d830> <4A40E2E6.9060904@atmel.com> <20090625084631.GA7985@n2100.arm.linux.org.uk> <4AF04148.8070103@atmel.com> <20091103210542.GA8719@n2100.arm.linux.org.uk>
In-Reply-To: <20091103210542.GA8719@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux :
> On Tue, Nov 03, 2009 at 03:42:16PM +0100, Nicolas Ferre wrote:
>> The problem is that if I do not setup the dependency here the menu entry
>> will not be available at the proper level. In fact I will see the Atmel
>> LCD entry here:
>> "Graphics support"
>>  <*> Support for frame buffer devices  --->
>>  <*> AT91/AT32 LCD Controller support
>>
>> instead of here:
>> "Graphics support"
>>  ---> "Support for frame buffer devices"
>>       [..]
>>       <*> "AT91/AT32 LCD Controller support"
>>       [..]
>>
>> So I keep the depend.
> 
> The depend is on ARCH_ATMEL_HAS_FB which has no description (and therefore
> does not appear in the menus) not the symbol for "AT91/AT32 LCD Controller
> support".

The issue with the menu was that the additional variable was in the middle 
of the list of frame buffer devices.

Here is a snippet of the solution I propose without the not needed depend. 
I cook a v2 patch just now.

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 9bbb285..6d3f291 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -5,6 +5,9 @@
 menu "Graphics support"
        depends on HAS_IOMEM
 
+config HAVE_FB_ATMEL
+       bool
+
 source "drivers/char/agp/Kconfig"
 
 source "drivers/gpu/vga/Kconfig"
@@ -937,7 +940,7 @@ config FB_S1D13XXX
 
 config FB_ATMEL
        tristate "AT91/AT32 LCD Controller support"
-       depends on FB && (ARCH_AT91SAM9261 || ARCH_AT91SAM9G10 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45 || ARCH_AT9
+       depends on FB && HAVE_FB_ATMEL
        select FB_CFB_FILLRECT
        select FB_CFB_COPYAREA
        select FB_CFB_IMAGEBLIT

Best regards,
-- 
Nicolas Ferre

