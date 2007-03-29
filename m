Return-Path: <linux-kernel-owner+w=401wt.eu-S965934AbXC2DbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965934AbXC2DbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 23:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965935AbXC2DbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 23:31:09 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:41607 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965934AbXC2DbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 23:31:08 -0400
Message-ID: <460B3244.9060405@student.ltu.se>
Date: Thu, 29 Mar 2007 05:28:04 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Milind Arun Choudhary <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [KJ][PATCH] BIT macro cleanup
References: <20070328033309.GA9597@arun.site> <20070328190925.GC5306@martell.zuzino.mipt.ru>
In-Reply-To: <20070328190925.GC5306@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Wed, Mar 28, 2007 at 09:03:09AM +0530, Milind Arun Choudhary wrote:
>   
>> --- a/include/linux/bitops.h
>> +++ b/include/linux/bitops.h
>> @@ -8,6 +8,9 @@
>>   */
>>  #include <asm/bitops.h>
>>
>> +#define BIT(nr)	(1UL << ((nr) % BITS_PER_LONG))
>>     
>
> I think this would be a disaster because something like
>
> 	BIT(123)
>
> would not even generate a warning.
>   
There were a discussion on this, at KJ, when BIT was first used with a 
modular operation. I said the same thing as you do now, but a big user 
of BIT is the input-subsystem who defined their BIT as above. Also it 
was mentioned that the compiler can only find the statical errors, a 
variable input can break it in runtime.
+ if we _really_ want to check the tree for such warnings, it is easy to 
remove the modular operation temporarily (and keep away of input/)

I don't say I like this, just that it is a choose between possible errors.
Richard Knutsson

