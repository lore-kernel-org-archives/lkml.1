Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657Ab0AURuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab0AURuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594Ab0AURuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:50:07 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:40409 "HELO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752271Ab0AURuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:50:06 -0500
Message-ID: <4B58935F.4080700@ru.mvista.com>
Date: Thu, 21 Jan 2010 20:48:15 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 46/64] ide: add drive->pio_mode field
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118172028.14623.55296.sendpatchset@localhost> <4B54B656.2090307@ru.mvista.com> <201001191609.46434.bzolnier@gmail.com>
In-Reply-To: <201001191609.46434.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> On Monday 18 January 2010 08:28:22 pm Sergei Shtylyov wrote:
>   
>> Bartlomiej Zolnierkiewicz wrote:
>>
>>     
>>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> Subject: [PATCH] ide: add drive->pio_mode field
>>>
>>> Add pio_mode field to ide_drive_t matching pio_mode field used in
>>> struct ata_device.
>>>
>>> The validity of the field is restricted to ->set_pio_mode method
>>> only currently in IDE subsystem.
>>>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> ---
>>>  drivers/ide/ide-devsets.c   |    2 ++
>>>  drivers/ide/ide-probe.c     |    2 ++
>>>  drivers/ide/ide-xfer-mode.c |    3 +++
>>>  include/linux/ide.h         |    1 +
>>>  4 files changed, 8 insertions(+)
>>>
>>> Index: b/drivers/ide/ide-devsets.c
>>> ===================================================================
>>> --- a/drivers/ide/ide-devsets.c
>>> +++ b/drivers/ide/ide-devsets.c
>>> @@ -105,6 +105,8 @@ static int set_pio_mode(ide_drive_t *dri
>>>  		return -ENOSYS;
>>>  
>>>  	if (set_pio_mode_abuse(drive->hwif, arg)) {
>>> +		drive->pio_mode = arg + XFER_PIO_0;
>>> +
>>>   
>>>       
>>    Er, didn't understand this... these 'arg' values are not really PIO 
>> modes, no?
>>     
>
> In the usual case they are

   But after set_pio_mode_abuse() returned non-zero we know it's not 
usual case, no?

>  and a few 'special' ->set_pio_mode implementations
> will extract the desired 'arg' value just fine by doing '- XFER_PIO_0'..
>   

   I don't understand why we should change drive->pio_mode if we know 
it's not a PIO mode but "abuse value". Perhaps you're dropping the mode 
argument from set_pio_mode() in some of the next patches? Doesn't seem a 
good idea, given that this "abuse case" still exist...

> --
> Bartlomiej Zolnierkiewicz
>   

WBR, Sergei

