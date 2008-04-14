Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbYDNQLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbYDNQLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbYDNQLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:11:44 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48560 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbYDNQLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:11:43 -0400
Date: Mon, 14 Apr 2008 19:10:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mtd/cmdlinepart.c: don't compare pointers with 0
Message-ID: <20080414161037.GZ6695@cs181133002.pp.htv.fi>
References: <20080414142004.GR6695@cs181133002.pp.htv.fi> <48036D43.6070307@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48036D43.6070307@ru.mvista.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 06:42:11PM +0400, Sergei Shtylyov wrote:
> Hello.
>
> Adrian Bunk wrote:
>
>> Sparse spotted that 0 was compared to pointers.
>
>> While I was at it, I also moved the assignments out of the if's.
>
>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
>> 32de76e83f37322dd85eaecf126e7b17327f606f diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
>> index b44292a..3e09043 100644
>> --- a/drivers/mtd/cmdlinepart.c
>> +++ b/drivers/mtd/cmdlinepart.c
>> @@ -119,7 +119,8 @@ static struct mtd_partition * newpart(char *s,
>>  		char *p;
>>   	    	name = ++s;
>> -		if ((p = strchr(name, delim)) == 0)
>> +		p = strchr(name, delim);
>> +		if (!p)
>>  		{
>
>    Wouldn't it be nice to join the standalone brace to if () while it?

Most of the file is written like this, so there's no point in changing 
it only here...

>>  			printk(KERN_ERR ERRP "no closing %c found in partition name\n", delim);
>>  			return NULL;
>
> WBR, Sergei

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

