Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815Ab0ASJFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab0ASJFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735Ab0ASJFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:05:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:51553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788Ab0ASJFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:05:22 -0500
Message-ID: <4B5575C8.4030205@kernel.org>
Date: Tue, 19 Jan 2010 18:05:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: =?UTF-8?B?Q2VuZ2l6IEfDvG5heQ==?= <cgunay@emory.edu>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: sata_nv times out for BD-ROM iHOS104-08
References: <Pine.LNX.4.64.0912221105010.5876@stg.biology.emory.edu> 	<4B31C8EE.3030003@kernel.org> <d2d378040912232302u4b550dap687fcadced237935@mail.gmail.com> 	<4B331771.3090309@kernel.org> <d2d378041001161334r6fe3ee65w39cf98a6c2d1d399@mail.gmail.com> <4B532CB7.4060005@pardus.org.tr>
In-Reply-To: <4B532CB7.4060005@pardus.org.tr>
Content-Type: multipart/mixed;
 boundary="------------090005050101000106000403"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Jan 2010 09:05:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090005050101000106000403
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

On 01/18/2010 12:28 AM, Ozan Çağlayan wrote:
> [    9.769407] ata1: nv_mode_filter: 0x739f&0x739f->0x739f, BIOS=0x7000 (0xc000c700) ACPI=0x701f (60:600:0x13)                                                  
> [    9.775326] ata1.00: configured for UDMA/33                                  
> [    9.775408] ata1.00: TEST_UNIT_READY failed (err_mask=0x2)                 

Hmmm... err_mask=0x2 is HSM error.  Strange.  Does the attached patch
make any difference?

Thanks.

-- 
tejun

--------------090005050101000106000403
Content-Type: text/x-patch;
 name="disable-clear-ua.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="disable-clear-ua.patch"

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 0ea97c9..df261ac 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3530,7 +3530,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		/* If reset has been issued, clear UA to avoid
 		 * disrupting the current users of the device.
 		 */
-		if (ehc->i.flags & ATA_EHI_DID_RESET) {
+		/*if (ehc->i.flags & ATA_EHI_DID_RESET) {
 			ata_for_each_dev(dev, link, ALL) {
 				if (dev->class != ATA_DEV_ATAPI)
 					continue;
@@ -3538,7 +3538,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 				if (rc)
 					goto dev_fail;
 			}
-		}
+		}*/
 
 		/* retry flush if necessary */
 		ata_for_each_dev(dev, link, ALL) {

--------------090005050101000106000403--
