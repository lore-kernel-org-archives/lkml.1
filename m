Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbYIUWMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbYIUWMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 18:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYIUWMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 18:12:34 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:59356 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752515AbYIUWMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 18:12:33 -0400
Message-ID: <48D6C6CA.3080100@ru.mvista.com>
Date: Mon, 22 Sep 2008 02:12:26 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Mark de Wever <koraq@xs4all.nl>
Cc: Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
References: <20080921185138.GA16310@localhost> <48D69F5A.9010201@ru.mvista.com> <48D6A9BB.1070705@ru.mvista.com> <20080921202915.GA17945@localhost>
In-Reply-To: <20080921202915.GA17945@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Mark de Wever wrote:

>>>> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
>>>> index 1bce84b..fd87b43 100644
>>>> --- a/drivers/ide/ide-tape.c
>>>> +++ b/drivers/ide/ide-tape.c
>>>> @@ -2354,6 +2354,10 @@ static void  
>>>> idetape_get_inquiry_results(ide_drive_t *drive)
>>>>      ide_fixstring(product_id, 18, 0);
>>>>      ide_fixstring(fw_rev, 6, 0);
>>>>         
>>    Hm, I see that every string variable declared there has 2 extra  
>> characters, and yet the author have managed to make a mistake... these 
>> extra chars don't seem needed.
>>     
>
> Those extra characters made me believe the intention was setting the
> NULL character, therefore I used that solution in my patch.
>   

   It was wrong to call ide_fixstring() on those "long" stings without 
first setting their last byte to 0 -- this way that function just copied 
the garbage at the end of the passed unterminated strings.
I suggest that you get rid of those extra bytes as well, and use the 
"%.<n>s" format specifiers.

> Regards,
> Mark de Wever
>   

MBR, Sergei


