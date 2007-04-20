Return-Path: <linux-kernel-owner+w=401wt.eu-S2992694AbXDTMrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992694AbXDTMrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 08:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992726AbXDTMrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 08:47:25 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:39404 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992694AbXDTMrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 08:47:25 -0400
Message-ID: <4628B5B6.90303@student.ltu.se>
Date: Fri, 20 Apr 2007 14:44:38 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Jiri Bohac <jbohac@suse.cz>, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] fix abs() macro to work with types wider than int
References: <20070419092339.GA13569@dwarf.suse.cz> <20070419084339.418dbe69.randy.dunlap@oracle.com>
In-Reply-To: <20070419084339.418dbe69.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 19 Apr 2007 11:23:39 +0200 Jiri Bohac wrote:
>
>   
>> Hi,
>>
>> is there any reason to use an explicit int instead of a typeof in
>> the abs() macro? The current implementation will return bogus
>> results when used with longs.
>>     
>
> I think it's like it is just to be consistent with abs() in C,
> which also contains labs() and llabs().
>   
We actually had labs() before (few months ago), but since it was not 
used, and if it would it seemed better to just fix abs(), it was 
removed. So I think this is the appropriate way to go.
>   
>> How about changing the int to a typeof like this?:
>>
>>
>>
>> Fix the abs() macro to work with wider types than int.
>>
>> Signed-off-by: Jiri Bohac <jbohac@suse.cz>
>>
>> --- linux-2.6.21-rc5.orig/include/linux/kernel.h
>> +++ linux-2.6.21-rc5/include/linux/kernel.h
>> @@ -89,7 +89,7 @@ extern int cond_resched(void);
>>  #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
>>  
>>  #define abs(x) ({				\
>> -		int __x = (x);			\
>> +		typeof(x) __x = (x);			\
>>  		(__x < 0) ? -__x : __x;		\
>>  	})
>>  
>>
>>
>>     
