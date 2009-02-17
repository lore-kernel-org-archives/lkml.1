Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZBQAPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZBQAPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 19:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbZBQAPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 19:15:05 -0500
Received: from h155.mvista.com ([63.81.120.155]:3920 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750863AbZBQAPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 19:15:03 -0500
Message-ID: <499A0181.8000008@ru.mvista.com>
Date: Tue, 17 Feb 2009 03:14:57 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] ide: use ->tf_read in ide_read_error()
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <49995856.0@ru.mvista.com> <49995B44.6090604@ru.mvista.com> <200902162217.08541.bzolnier@gmail.com>
In-Reply-To: <200902162217.08541.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>>>>   register and handle it in ->tf_read.
>>>>>   
>>>>>           
>>>>  Doesn't seem like a good name -- you can't read the features 
>>>> register. I should've commented to this patch earlier, of course...
>>>>         
>
> [ Yeah... preferably in June 2008 when this patch was posted... ]
>   

   I was too busy acquainting myself with the wonderful world of ARM and 
MUSB back then... :-/

>>> * Add IDE_TFLAG_IN_FEATURE taskfile flag for reading Feature
>>>       
>
> Trivial s/IN_*FEATURE/IN_*ERROR/ should do the job.
>
> I will fix it later unless you beat me to it.
>   

   Well, if I'm going to get my hands in the transport methods anyway, I 
think I'll address it.

>>>   Moreover, the error register shoudn't be affeceted by the HOB bit, 
>>> so this flag doesn't make sense.
>>>       
>>    I meant IDE_TFLAG_IN_HOB_FEATURE, of course.
>>     
>
> Once again blame the certain ioctl (you know which one)... :)
>   

   Oh, horror... and I know that it wasn't completely ungrounded since 
both ATA/PI-6 adn -7 have words about reading the features register 
(depending on HOB). At least ATA/PI-8 got rid of this. Anyway, I think 
we can safely get rid of this flag and just return the same value in 
'features' and 'hob_features'. Besides, union ide_reg_valid_s also has 
such interesting fields as 'select_hob' and 'control_hob' but they seem 
to be ignored altogether (as long as 'select') if I don't mistake...

> Thanks,
> Bart
>   

MBR, Sergei


