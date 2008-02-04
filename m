Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYBDLiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYBDLiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 06:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYBDLhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 06:37:42 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:2314 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbYBDLhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 06:37:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=OIXpzkBCZHi9Nd7vfWeHZJlKIBiUdLuG329xryqlak32MkowErsxEcmg0+6HC4sGf4pAHG3XVtAdNk/KxpB8Zf12XbftNwSZJp/fePYIBlHXHCwr2/w9POn0+Y5Hy5pSjBz0slw2/YyljXIbpMPJFFcYWKHxIJQuXxzPbRNAujY=
Date: Mon, 4 Feb 2008 12:36:35 +0100
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-tape: dump gcw fields on error in
	idetape_identify_device()
Message-ID: <20080204113635.GC5268@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Sergei Shtylyov <sshtylyov@ru.mvista.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200802021922.56703.bzolnier@gmail.com> <47A5F6FA.3000107@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47A5F6FA.3000107@ru.mvista.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 08:16:42PM +0300, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>
>> Index: b/drivers/ide/ide-tape.c
>> ===================================================================
>> --- a/drivers/ide/ide-tape.c
>> +++ b/drivers/ide/ide-tape.c
>> @@ -3852,16 +3852,17 @@ static int idetape_identify_device (ide_
>>   	/* Check that we can support this device */
>>  -	if (gcw.protocol !=2 )
>> -		printk(KERN_ERR "ide-tape: Protocol is not ATAPI\n");
>> +	if (gcw.protocol != 2)
>> +		printk(KERN_ERR "ide-tape: Protocol (0x%02x) is not ATAPI\n",
>> +				gcw.protocol);
>>  	else if (gcw.device_type != 1)
>> -		printk(KERN_ERR "ide-tape: Device type is not set to tape\n");
>> +		printk(KERN_ERR "ide-tape: Device type (0x%02x) is not set "
>> +				"to tape\n", gcw.device_type);
>>  	else if (!gcw.removable)
>>  		printk(KERN_ERR "ide-tape: The removable flag is not set\n");
>>  	else if (gcw.packet_size != 0) {
>> -		printk(KERN_ERR "ide-tape: Packet size is not 12 bytes long\n");
>> -		if (gcw.packet_size == 1)
>> -			printk(KERN_ERR "ide-tape: Sorry, padding to 16 bytes is still not supported\n");
>> +		printk(KERN_ERR "ide-tape: Packet size (0x%02x) is not 12 "
>> +				"bytes long\n", gcw.packet_size);
>
>    Shouldn't it be either "packet size is not 12 byted" or "packet is not 
> 12 bytes long"?

I like the last one better. Will send a correction later on to Bart. Thanks.

-- 
Regards/Gruﬂ,
    Boris.
