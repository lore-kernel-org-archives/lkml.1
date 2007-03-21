Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbXCUQtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbXCUQtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933054AbXCUQtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:49:17 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:7349 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044AbXCUQtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:49:16 -0400
Message-ID: <46016208.3040303@saville.com>
Date: Wed, 21 Mar 2007 09:49:12 -0700
From: Wink Saville <wink@saville.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Johannes Weiner <hannes-kernel@saeurebad.de>
Subject: Re: [PATCH 2/7] Initial implementation of the trec driver and include
 files
References: <d4cf37a60703202347o67740694jc1c9030c647ff7c6@mail.gmail.com> <20070321082238.GA16768@leiferikson>
In-Reply-To: <20070321082238.GA16768@leiferikson>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Your patch has broken lines where there shouldn't be any.
>   
OK.

>> +	struct trec_buffer_struct *	pNext;
>> +	struct trec_struct *		pCur;
>> +	struct trec_struct *		pEnd;
>> Please don't use camel-case - in general.
>>     
Would p_next, p_cur and p_end be OK?
>   
>> +static int snprint_address(char *b, int bsize, unsigned long address)
>> +{
>> +#ifdef CONFIG_KALLSYMS
>> +	unsigned long offset = 0, symsize;
>>     
>> +#else
>> +	return snprintf(b, bsize, "0x%016lx", address);
>> +#endif
>> +}
>>     
>
> Would it make sense to #ifdef the whole function?
> Make it static int (*)(...) if CONFIG_KALLSYMS and otherwise just a
> static inline int (*)(...) { return 0; }
>   
Maybe, but I think just letting the compiler decide is better.
>   
>> [...]
>> +static int trec_device_init(void)
>> +{
>> +	int 		result;
>> +		DPK("trec_device_init: cdev_add failed\n");
>> +		goto done;
>>     
>
> If you jump to `done' here, unregister_chrdev_region is never called.
>
> You should also declare trec_device_init as __init and trex_device_exit
> as __exit.
>   
I'll fix this.
>   
>> --- /dev/null
>> +++ b/include/linux/trec.h
>> @@ -0,0 +1,34 @@
>> +/*
>> +#define TREC0()			trec_write(TREC_PC_ADDR, TREC_PID, 0, 0)
>>     

>> +
>> +#define ZREC0()			do { } while (0)
>>     
> Why not seperate them by an #ifndef? So you don't have to replace TREC?
> with ZREC? but rather change one #define knob.
>
> =Hannes
>
>   

The reason is to allow the user easily change individual TREC's from 
active to inactive by just
changing a single character. Eventually I envision adding runtime 
support for changing if a
particular set of TREC's are active or not, but this was simple.

Thanks for the feed back.


Wink

