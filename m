Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYIGLU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYIGLU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 07:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYIGLUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 07:20:48 -0400
Received: from h155.mvista.com ([63.81.120.155]:15349 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753170AbYIGLUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 07:20:48 -0400
Message-ID: <48C3B909.3030405@ru.mvista.com>
Date: Sun, 07 Sep 2008 15:20:41 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Masoud Sharbiani <masouds@google.com>
Cc: bzolnier@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Fix pointer arithmetic in hpt3xx driver code (3rd try)
References: <20080906171850.GF26371@google.com> <48C39D2F.4010701@ru.mvista.com>
In-Reply-To: <48C39D2F.4010701@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:
>> diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
>> index eb107ee..4eae284 100644
>> --- a/drivers/ide/pci/hpt366.c
>> +++ b/drivers/ide/pci/hpt366.c
>> @@ -613,6 +613,14 @@ static int check_in_drive_list(ide_drive_t 
>> *drive, const char **list)
>>      return 0;
>>  }
>>  
>> +static struct hpt_info *hpt3xx_get_info(struct device *dev)
>> +{
>> +    struct ide_host *host    = pci_get_drvdata(to_pci_dev(pci_dev));
>>   
>
>   Oops, this just won't compile. :-/

   BTW, there's no need to invoke to_pci_dev() at all since 
pci_get_drvdata(dev) boils down to dev_get_drvdata(&dev->dev) call. So, 
in order not to waste time on useless pointer tricks, we should just 
invoke the latter here.

>   And please re-consider passing 'struct pci_dev *' to this function 
> since it's pre-calculated by the callers and is used by them otherwise 
> in 5 (not even 4) cases out of 7.
>

   Well, since to_pci_dev() is unnecessary here, I'm taking my request 
back. :-)

MBR, Sergei


