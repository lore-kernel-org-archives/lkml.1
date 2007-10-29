Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbXJ2LeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbXJ2LeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 07:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbXJ2LeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 07:34:15 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:59641 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbXJ2LeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 07:34:14 -0400
Message-ID: <4725C516.2000004@linux.vnet.ibm.com>
Date: Mon, 29 Oct 2007 17:03:42 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH-RESEND] Re: S390 change in sg_set_page() cause build failure
References: <20071026111945.GB21274@linux.vnet.ibm.com> <20071026115429.GH5155@kernel.dk> <20071029112228.GA29163@linux.vnet.ibm.com> <20071029112617.GB5001@kernel.dk>
In-Reply-To: <20071029112617.GB5001@kernel.dk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Oct 29 2007, Kamalesh Babulal wrote:
>> On Fri, Oct 26, 2007 at 01:54:30PM +0200, Jens Axboe wrote:
>>> On Fri, Oct 26 2007, Kamalesh Babulal wrote:
>>>> Hi Jens,
>>>>
>>>>  	sg_set_buf(list, address, 0);
>> <snip>
>>>>  }
>>> That's not quite right, it should be:
>>>
>>> diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
>>> index 0754542..e268f79 100644
>>> --- a/drivers/s390/scsi/zfcp_def.h
>>> +++ b/drivers/s390/scsi/zfcp_def.h
>>> @@ -70,11 +70,12 @@ zfcp_sg_to_address(struct scatterlist *list)
>>>   * zfcp_address_to_sg - set up struct scatterlist from kernel address
>>>   * @address: kernel address
>>>   * @list: struct scatterlist
>>> + * @size: buffer size
>>>   */
>>>  static inline void
>>> -zfcp_address_to_sg(void *address, struct scatterlist *list)
>>> +zfcp_address_to_sg(void *address, struct scatterlist *list, unsigned int size)
>>>  {
>>> -	sg_set_buf(list, address, 0);
>>> +	sg_set_buf(list, address, size);
>>>  }
>>>
>>>  #define REQUEST_LIST_SIZE 128
>>>
>>> -- 
>>> Jens Axboe
>> Hi Jens,
>>
>> Resending the patch with the changes pointed by you in the patch.
>>
>> [jens.axboe@oracle.com: size parameter fix]
>> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>> --
>> diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
>> index 0754542..f747e86 100644
>> --- a/drivers/s390/scsi/zfcp_def.h
>> +++ b/drivers/s390/scsi/zfcp_def.h
>> @@ -70,11 +70,12 @@ zfcp_sg_to_address(struct scatterlist *list)
>>   * zfcp_address_to_sg - set up struct scatterlist from kernel address
>>   * @address: kernel address
>>   * @list: struct scatterlist
>> + * @size: buffer size 
>>   */
>>  static inline void
>> -zfcp_address_to_sg(void *address, struct scatterlist *list)
>> +zfcp_address_to_sg(void *address, struct scatterlist *list, unsigned int size)
>>  {
>> -	sg_set_buf(list, address, 0);
>> +	sg_set_buf(list, address, size);
>>  }
>>  
>>  #define REQUEST_LIST_SIZE 128
> 
> Thanks Kamalesh, but I already merged a fixed up version on friday:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=9335432959111c982c74177521305e6a3fb600a3
> 
Hi Jens,

Thanks !! I resend because, this was seen till todays 2.6.24-rc1-git5.

-- 
Thanks & Regards,
Kamalesh Babulal,

