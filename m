Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZA1Xd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZA1Xd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbZA1XbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:31:08 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:33571 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546AbZA1XbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:31:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dyIbLGfnHmPTOzlUyBG+O+63t+8t4TdmwMJZY772FGJFukexnCEwBOixHSox7l6Vyl
         G9dlDlwrh0WzXXjCkRwT3WIXQ4sNaP9EqBs0mvedfUSuUfZx4o1hyzFdor7Rmu1HRqwJ
         +H/WxvvLPqH4Lw4voeyCNyjL2NhPWnNxU/Tmc=
Date: Thu, 29 Jan 2009 02:30:56 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: jeff@garzik.org, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH] sata_sil: Fix build breakage
Message-ID: <20090128233056.GA30358@orion>
References: <1233118922-15350-1-git-send-email-galak@kernel.crashing.org> <1233118922-15350-2-git-send-email-galak@kernel.crashing.org> <1233118922-15350-3-git-send-email-galak@kernel.crashing.org> <5B9826B6-792F-4C66-A4C1-E002B0DD60B1@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B9826B6-792F-4C66-A4C1-E002B0DD60B1@kernel.crashing.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:08:56AM -0600, Kumar Gala wrote:
>
> On Jan 27, 2009, at 11:02 PM, Kumar Gala wrote:
>
>> The following commit introduces:
>>
>> commit e57db7bde7bff95ae812736ca00c73bd5271455b
>> Author: Rafael J. Wysocki <rjw@sisk.pl>
>> Date:   Mon Jan 19 20:58:29 2009 +0100
>>
>>    SATA Sil: Blacklist system that spins off disks during ACPI power off
>>
>> the following build errors on non-x86 systems:
>>
>> drivers/ata/sata_sil.c: In function 'sil_broken_system_poweroff':
>> drivers/ata/sata_sil.c:713: error: implicit declaration of function 
>> 'dmi_first_match'
>> drivers/ata/sata_sil.c:713: warning: initialization makes pointer from 
>> integer without a cast
>>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>> ---
>> drivers/ata/sata_sil.c |    2 ++
>> 1 files changed, 2 insertions(+), 0 deletions(-)
>
>
> it was pointed out that fixing include/linux/dmi.h was the better way to 
> fix this.  I've posted a patch for fixing dmi.h that supersedes this patch.
>

It breaks build for me in the same way even after your fix
(d8204ee2: dmi: Fix build breakage)

Subject: [PATCH] sata_sil: Fix build breakage
From: Alexander Beregalov <a.beregalov@gmail.com>

 Commit e57db7b (SATA Sil: Blacklist system that spins off disks during ACPI power off)
 breaks build like the following, in both cases when CONFIG_DMI set or not.

        drivers/ata/sata_sil.c: In function 'sil_broken_system_poweroff':
        drivers/ata/sata_sil.c:713: error: implicit declaration of function 'dmi_first_match'
        drivers/ata/sata_sil.c:713: warning: initialization makes pointer from integer without a cast

  sata_sil.c should include dmi.h

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---


 drivers/ata/sata_sil.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index bfd55b0..9f02959 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -44,6 +44,7 @@
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
+#include <linux/dmi.h>
 
 #define DRV_NAME	"sata_sil"
 #define DRV_VERSION	"2.4"
