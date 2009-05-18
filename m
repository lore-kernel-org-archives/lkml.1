Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbZERVkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbZERVkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 17:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZERVkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 17:40:35 -0400
Received: from h155.mvista.com ([63.81.120.155]:62610 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753516AbZERVke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 17:40:34 -0400
Message-ID: <4A11D5CC.5070909@ru.mvista.com>
Date: Tue, 19 May 2009 01:40:28 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Joe Perches <joe@perches.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] ide: merge ide_disk_special() into do_special()
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain> <1242248102.4639.17.camel@Joe-AcerAspire> <4A0C0D44.9020308@ru.mvista.com> <200905171900.45661.bzolnier@gmail.com>
In-Reply-To: <200905171900.45661.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>>> While at it:
>>>> - change debug printk() level to KERN_DEBUG
>>>> - update documentation
>>>>         
>>>> There should be no functional changes caused by this patch.
>>>>         
>>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>> ---
>>>> drivers/ide/ide-io.c |   44 ++++++++++++++++++--------------------------
>>>> 1 file changed, 18 insertions(+), 26 deletions(-)
>>>>         
>>>> Index: b/drivers/ide/ide-io.c
>>>> ===================================================================
>>>> --- a/drivers/ide/ide-io.c
>>>> +++ b/drivers/ide/ide-io.c
>>>> @@ -184,11 +184,28 @@ static void ide_tf_set_setmult_cmd(ide_d
>>>>         
>>> []
>>>       
>>>> +#ifdef DEBUG
>>>> +	printk(KERN_DEBUG "%s: %s: 0x%02x\n", drive->name, s->all);
>>>> +#endif
>>>>         
>>> pr_debug?
>>>       
>>     Yes, and the number of arguments doesn't correspond to the number of the 
>> format specifiers.
>>     
>
> Ugh :)  Fixed in the revised version (interdiff below)...
>
> When it comes to pr_debug() & co. I will warmly welcome patches converting
> drivers/ide/*.[ch] to use them.
>
> ...
> v2:
> - fix DEBUG build (noticed by Sergei)
> ...
>
> diff -u b/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> --- b/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -198,7 +198,7 @@
>  	struct ide_cmd cmd;
>  
>  #ifdef DEBUG
> -	printk(KERN_DEBUG "%s: %s: 0x%02x\n", drive->name, s->all);
> +	printk(KERN_DEBUG "%s: %s: 0x%02x\n", drive->name, __func__, s->all);
>  #endif
>  	if (drive->media != ide_disk) {
>  		s->all = 0;
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei




