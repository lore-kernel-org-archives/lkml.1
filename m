Return-Path: <linux-kernel-owner+w=401wt.eu-S932132AbXB0MQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbXB0MQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 07:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933041AbXB0MQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 07:16:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132AbXB0MQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 07:16:21 -0500
Message-ID: <45E4210D.3070504@redhat.com>
Date: Tue, 27 Feb 2007 07:16:13 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH]: Fix __devinit & __devexit declarations in de2104x driver
References: <20070226183611.11886.61545.sendpatchset@prarit.boston.redhat.com> <45E3F853.3010302@garzik.org>
In-Reply-To: <45E3F853.3010302@garzik.org>
Content-Type: multipart/mixed;
 boundary="------------010406070506020103030507"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010406070506020103030507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Jeff Garzik wrote:
> Prarit Bhargava wrote:
>> Resending (originally sent 2007-02-14).
>>
>> __devinit & __devexit cleanups for de2104x driver.
>>
>> Fixes MODPOST warnings similar to:
>>
>> WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to
>> .init.text:de_init_one from .data.rel.local after 'de_driver' (at 
>> offset 0x20)
>> WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to
>> .exit.text:de_remove_one from .data.rel.local after 'de_driver' (at 
>> offset 0x28)
>>
>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>
> doesn't apply to current kernel

Updated patch to latest git...

P.

>
>

--------------010406070506020103030507
Content-Type: text/plain;
 name="228736-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="228736-v2.patch"

__devinit & __devexit cleanups for de2104x driver.

Fixes MODPOST warnings similar to:

WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to
.init.text:de_init_one from .data.rel.local after 'de_driver' (at offset 0x20)
WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to
.exit.text:de_remove_one from .data.rel.local after 'de_driver' (at offset 0x28)

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/net/tulip/de2104x.c b/drivers/net/tulip/de2104x.c
index 9d67f11..55739c7 100644
--- a/drivers/net/tulip/de2104x.c
+++ b/drivers/net/tulip/de2104x.c
@@ -1685,7 +1685,7 @@ static const struct ethtool_ops de_ethtool_ops = {
 	.get_regs		= de_get_regs,
 };
 
-static void __init de21040_get_mac_address (struct de_private *de)
+static void __devinit de21040_get_mac_address (struct de_private *de)
 {
 	unsigned i;
 
@@ -1703,7 +1703,7 @@ static void __init de21040_get_mac_address (struct de_private *de)
 	}
 }
 
-static void __init de21040_get_media_info(struct de_private *de)
+static void __devinit de21040_get_media_info(struct de_private *de)
 {
 	unsigned int i;
 
@@ -1765,7 +1765,7 @@ static unsigned __devinit tulip_read_eeprom(void __iomem *regs, int location, in
 	return retval;
 }
 
-static void __init de21041_get_srom_info (struct de_private *de)
+static void __devinit de21041_get_srom_info (struct de_private *de)
 {
 	unsigned i, sa_offset = 0, ofs;
 	u8 ee_data[DE_EEPROM_SIZE + 6] = {};

--------------010406070506020103030507--
