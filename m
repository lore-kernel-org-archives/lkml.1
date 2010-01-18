Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971Ab0ARS67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab0ARS67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929Ab0ARS66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:58:58 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:59237 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754090Ab0ARS65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:58:57 -0500
Message-ID: <4B54AF06.3060800@ru.mvista.com>
Date: Mon, 18 Jan 2010 21:57:10 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/64] libata: fix CFA handling in ide_timing_compute()
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171357.14623.36435.sendpatchset@localhost> <4B54A724.6080701@ru.mvista.com> <201001181929.17136.bzolnier@gmail.com>
In-Reply-To: <201001181929.17136.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> Subject: [PATCH] libata: fix CFA handling in ide_timing_compute()
>>>
>>> Use standard cycle timing for CFA PIO5 and PIO6 modes.
>>>
>>> Based on commit 74638c8 for IDE subsystem.
>>>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> ---
>>>  drivers/ata/libata-core.c |   17 +++++++++++------
>>>  1 file changed, 11 insertions(+), 6 deletions(-)
>>>
>>> Index: b/drivers/ata/libata-core.c
>>> ===================================================================
>>> --- a/drivers/ata/libata-core.c
>>> +++ b/drivers/ata/libata-core.c
>>> @@ -3211,6 +3211,7 @@ const struct ata_timing *ata_timing_find
>>>  int ata_timing_compute(struct ata_device *adev, unsigned short speed,
>>>  		       struct ata_timing *t, int T, int UT)
>>>  {
>>> +	const u16 *id = adev->id;
>>>  	const struct ata_timing *s;
>>>  	struct ata_timing p;
>>>  
>>> @@ -3228,14 +3229,18 @@ int ata_timing_compute(struct ata_device
>>>  	 * PIO/MW_DMA cycle timing.
>>>  	 */
>>>  
>>> -	if (adev->id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
>>> +	if (id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
>>>  		memset(&p, 0, sizeof(p));
>>> +
>>>  		if (speed >= XFER_PIO_0 && speed <= XFER_SW_DMA_0) {
>>>   
>>>       
>>    BTW, shouldn't this actually be 'speed < XFER_SW_DMA_0'?
>>     
>
> Good catch, I'll fix the patch later (would you be willing to fix
> ide-timings.c side of things?).
>   

   I don't see what to fix there?..

MBR, Sergei

