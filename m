Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbYCKIAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbYCKIAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYCKIAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:00:47 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:33671 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYCKIAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:00:44 -0400
Message-ID: <47D63C29.90304@tiscali.nl>
Date: Tue, 11 Mar 2008 09:00:41 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: Pierre Ossman <drzeus-mmc@drzeus.cx>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] MMC: DATA_CARRY is not boolean in tifm_sd_transfer_data()
 (was: MMC: logical-bitwise and confusion in  tifm_sd_transfer_data()?)
References: <854975.87080.qm@web36710.mail.mud.yahoo.com>
In-Reply-To: <854975.87080.qm@web36710.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> --- Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> 
>> On Sun, 09 Mar 2008 21:31:08 +0100
>> Roel Kluin <12o3l@tiscali.nl> wrote:
>>
>>> from drivers/mmc/host/tifm_sd.c:183:
>>>
>>> if ((r_data->flags & MMC_DATA_WRITE)
>>>     && DATA_CARRY)
>>>
>>> shouldn't this be bit-wise &?
>> First off, I'm not the maintainer of that driver, Alex Dubov is.
>>
>> Second, the code seems broken, but not in the way you suggest. It should probably have been:
>>
>> if ((r_data->flags & MMC_DATA_WRITE)
>> 	&& (host->cmd_flags & DATA_CARRY))
>>
> 
> Yes, this is the intended meaning. Can you fix it yourself or should I send a separate patch?

Thanks,
---
DATA_CARRY is not boolean

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 20d5c7b..1c14a18 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -180,7 +180,7 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
 			host->sg_pos++;
 			if (host->sg_pos == host->sg_len) {
 				if ((r_data->flags & MMC_DATA_WRITE)
-				    && DATA_CARRY)
+				    && (host->cmd_flags & DATA_CARRY))
 					writel(host->bounce_buf_data[0],
 					       host->dev->addr
 					       + SOCK_MMCSD_DATA);
