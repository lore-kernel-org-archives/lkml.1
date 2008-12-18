Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752805AbYLRRYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbYLRRYl (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYLRRYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:24:30 -0500
Received: from h155.mvista.com ([63.81.120.155]:28315 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751553AbYLRRY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:24:29 -0500
Message-ID: <494A8768.4080100@ru.mvista.com>
Date: Thu, 18 Dec 2008 20:24:56 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Mario Schwalbe <schwalbe@inf.tu-dresden.de>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ide: Fix ata_id_has_dword_io to return DWORD I/O support
 properly
References: <494A5BBF.8000807@inf.tu-dresden.de> <494A837A.50801@garzik.org>
In-Reply-To: <494A837A.50801@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jeff Garzik wrote:

>> This patch fixes ata_id_has_dword_io to return 1 (supported) if
>> the drive is compliant to ATA2 or newer and evaluates the config
>> word for older drives.

>> Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>

>> diff --git a/include/linux/ata.h b/include/linux/ata.h
>> index a53318b..d0d6a9c 100644
>> --- a/include/linux/ata.h
>> +++ b/include/linux/ata.h
>> @@ -700,12 +700,12 @@ static inline int ata_id_has_tpm(const u16 *id)

>>  static inline int ata_id_has_dword_io(const u16 *id)
>>  {
>> -    /* ATA 8 reuses this flag for "trusted" computing */
>> -    if (ata_id_major_version(id) > 7)
>> -        return 0;
>> -    if (id[ATA_ID_DWORD_IO] & (1 << 0))
>> -        return 1;
>> -    return 0;
>> +    /* This flag is defined up to ATA1 and deprecated since then
>> +       (ATA 8 reuses this flag for "trusted" computing). */
>> +    if (ata_id_major_version(id) <= 1)
>> +        return (id[ATA_ID_DWORD_IO] & (1 << 0)) != 0;
>> +    /* later revision drives support DWORD I/O just fine */
>> +    return 1;

> This seems like a risky assumption...

    Not at all, I think. It's total mystery how "DWORD I/O" could've been even 
(not) supported by a *drive* at all. Support of "DWORD I/O" is a property of 
the PATA controller. Frankly speaking, I don't think that this function is at 
all useful...

>     Jeff

MBR, Sergei
