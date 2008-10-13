Return-Path: <linux-kernel-owner+w=401wt.eu-S1760444AbYJMJjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444AbYJMJjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbYJMJfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:35:10 -0400
Received: from zm1.veloxia.com ([213.149.227.2]:35461 "HELO zm1.veloxia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759947AbYJMJfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:35:07 -0400
Message-ID: <48F314B7.3020708@hvsistemas.es>
Date: Mon, 13 Oct 2008 11:28:23 +0200
From: Javier Herrero <jherrero@hvsistemas.es>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
CC: Bryan Wu <cooloney@kernel.org>, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] netdev: DM9000: Added typecasting to supress some
 warnings on Blackfin
References: <1223889009-31336-1-git-send-email-cooloney@kernel.org> <20081013091725.GG31627@trinity.fluff.org>
In-Reply-To: <20081013091725.GG31627@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bryan,

So it seems that we must correct that in other place?

Regards,

Javier

Ben Dooks escribió:
> On Mon, Oct 13, 2008 at 05:10:09PM +0800, Bryan Wu wrote:
>> From: Javier Herrero <jherrero@hvsistemas.es>
>
> No, your arch definitions of writesb and co are wrong if they
> are not taking 'void __iomem *' arguments.
>  
>> Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  drivers/net/dm9000.c |   12 ++++++------
>>  1 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/dm9000.c b/drivers/net/dm9000.c
>> index f42c23f..c4737ca 100644
>> --- a/drivers/net/dm9000.c
>> +++ b/drivers/net/dm9000.c
>> @@ -188,35 +188,35 @@ iow(board_info_t * db, int reg, int value)
>>  
>>  static void dm9000_outblk_8bit(void __iomem *reg, void *data, int count)
>>  {
>> -	writesb(reg, data, count);
>> +	writesb((int)reg, data, count);
>>  }
>>  
>>  static void dm9000_outblk_16bit(void __iomem *reg, void *data, int count)
>>  {
>> -	writesw(reg, data, (count+1) >> 1);
>> +	writesw((int)reg, data, (count+1) >> 1);
>>  }
>>  
>>  static void dm9000_outblk_32bit(void __iomem *reg, void *data, int count)
>>  {
>> -	writesl(reg, data, (count+3) >> 2);
>> +	writesl((int)reg, data, (count+3) >> 2);
>>  }
>>  
>>  /* input block from chip to memory */
>>  
>>  static void dm9000_inblk_8bit(void __iomem *reg, void *data, int count)
>>  {
>> -	readsb(reg, data, count);
>> +	readsb((int)reg, data, count);
>>  }
>>  
>>  
>>  static void dm9000_inblk_16bit(void __iomem *reg, void *data, int count)
>>  {
>> -	readsw(reg, data, (count+1) >> 1);
>> +	readsw((int)reg, data, (count+1) >> 1);
>>  }
>>  
>>  static void dm9000_inblk_32bit(void __iomem *reg, void *data, int count)
>>  {
>> -	readsl(reg, data, (count+3) >> 2);
>> +	readsl((int)reg, data, (count+3) >> 2);
>>  }
>>  
>>  /* dump block from chip to null */
>> -- 
>> 1.5.6
>

-- 
------------------------------------------------------------------------
Javier Herrero                            EMAIL: jherrero@hvsistemas.com
HV Sistemas S.L.                          PHONE:         +34 949 336 806
Los Charcones, 17A                        FAX:           +34 949 336 792
19170 El Casar - Guadalajara - Spain      WEB: http://www.hvsistemas.com

