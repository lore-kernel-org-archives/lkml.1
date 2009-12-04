Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbZLDAwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbZLDAwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbZLDAwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:52:01 -0500
Received: from claw.goop.org ([74.207.240.146]:59189 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbZLDAwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:52:00 -0500
Message-ID: <4B185D32.1090207@goop.org>
Date: Thu, 03 Dec 2009 16:52:02 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Fedora/3.0-3.12.rc1.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Jaya Kumar <jayakumar.lkml@gmail.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, damm@opensource.se,
       linux-kernel@vger.kernel.org, armbru@redhat.com
Subject: Re: [PATCH 3/3] fb-defio: Inhibit VM_IO flag to be set on vmalloc-ed
 	framebuffers.
References: <1259854318-16907-1-git-send-email-konrad.wilk@oracle.com>	 <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com>	 <1259854318-16907-3-git-send-email-konrad.wilk@oracle.com>	 <1259854318-16907-4-git-send-email-konrad.wilk@oracle.com> <45a44e480912031635t331f7433v3003dd36cfd9940@mail.gmail.com>
In-Reply-To: <45a44e480912031635t331f7433v3003dd36cfd9940@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/09 16:35, Jaya Kumar wrote:
> On Thu, Dec 3, 2009 at 11:31 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com>  wrote:
>    
>> The framebuffers (screenbase) these drivers present are actually
>> vmalloc-ed pages. There is no need for them to have the VM_IO flag set.
>> ---
>>   drivers/video/broadsheetfb.c |    2 +-
>>   drivers/video/hecubafb.c     |    2 +-
>>   drivers/video/metronomefb.c  |    2 +-
>>   3 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/video/broadsheetfb.c b/drivers/video/broadsheetfb.c
>> index 509cb92..df9ccb9 100644
>> --- a/drivers/video/broadsheetfb.c
>> +++ b/drivers/video/broadsheetfb.c
>> @@ -470,7 +470,7 @@ static int __devinit broadsheetfb_probe(struct platform_device *dev)
>>         par->read_reg = broadsheet_read_reg;
>>         init_waitqueue_head(&par->waitq);
>>
>> -       info->flags = FBINFO_FLAG_DEFAULT;
>> +       info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
>>
>>         info->fbdefio =&broadsheetfb_defio;
>>         fb_deferred_io_init(info);
>> diff --git a/drivers/video/hecubafb.c b/drivers/video/hecubafb.c
>> index 0b4bffb..f9d77ad 100644
>> --- a/drivers/video/hecubafb.c
>> +++ b/drivers/video/hecubafb.c
>> @@ -253,7 +253,7 @@ static int __devinit hecubafb_probe(struct platform_device *dev)
>>         par->send_command = apollo_send_command;
>>         par->send_data = apollo_send_data;
>>
>> -       info->flags = FBINFO_FLAG_DEFAULT;
>> +       info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
>>
>>         info->fbdefio =&hecubafb_defio;
>>         fb_deferred_io_init(info);
>> diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
>> index df1f757..661bfd2 100644
>> --- a/drivers/video/metronomefb.c
>> +++ b/drivers/video/metronomefb.c
>> @@ -700,7 +700,7 @@ static int __devinit metronomefb_probe(struct platform_device *dev)
>>         if (retval<  0)
>>                 goto err_free_irq;
>>
>> -       info->flags = FBINFO_FLAG_DEFAULT;
>> +       info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
>>
>>         info->fbdefio =&metronomefb_defio;
>>         fb_deferred_io_init(info);
>> --
>> 1.6.2.5
>>
>>
>>      
>
> Looks good to me. Thanks.
>
> Acked-by: Jaya Kumar<jayakumar.lkml@gmail.com>
>    

Thanks.  Are you OK with me sending to Linus, or do you have a tree 
you'd prefer it to go by?

     J

