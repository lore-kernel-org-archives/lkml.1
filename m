Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbZEZJkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbZEZJkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZEZJkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:40:36 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:50787 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZEZJkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:40:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=doA/l+mDiq52oVmDkALuyzRZw8kSpuJNlb36d+gDB16Kq6F+erVzGv8+KkDwUB0mxF
         l/WJLZjB8pCbuAxrvoeCK2ZlRcbT5mV2G09zwvbBdRYUlmnvK9ZpnP2PQWI25iXt1dr1
         O4xWL9j6+82xVqH8JoWcBi+XAnJ9KW0cEF1M4=
MIME-Version: 1.0
In-Reply-To: <20090526083538.GA29563@elf.ucw.cz>
References: <20090526135733.3c38f758.minchan.kim@barrios-desktop>
	 <20090526083538.GA29563@elf.ucw.cz>
Date: Tue, 26 May 2009 18:40:35 +0900
Message-ID: <44c63dc40905260240n2c4e348ai74b7d42954098bf1@mail.gmail.com>
Subject: Re: [PATCH][mmtom] clean up once printk routine
From: Minchan Kim <barrioskmc@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>, akpm@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pavel.

On Tue, May 26, 2009 at 5:35 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> Yes. There are also some places to be able to use printk_once().
>> Are there any place I missed ?
>>
>> == CUT HERE ==
>>
>> There are some places to be able to use printk_once instead of hard coding.
>>
>> It will help code readability and maintenance.
>> This patch doesn't change function's behavior.
>>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> CC: Dominik Brodowski <linux@dominikbrodowski.net>
>> CC: David S. Miller <davem@davemloft.net>
>> CC: Ingo Molnar <mingo@elte.hu>
>> ---
>>  arch/x86/kernel/cpu/common.c  |    8 ++------
>>  drivers/net/3c515.c           |    7 ++-----
>>  drivers/pcmcia/pcmcia_ioctl.c |    9 +++------
>>  3 files changed, 7 insertions(+), 17 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>> index 82bec86..dc0f694 100644
>> --- a/arch/x86/kernel/cpu/common.c
>> +++ b/arch/x86/kernel/cpu/common.c
>> @@ -496,13 +496,9 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
>>               }
>>       }
>>
>> -     if (!printed) {
>> -             printed++;
>> -             printk(KERN_ERR
>> +     printk_once(KERN_ERR
>>                   "CPU: vendor_id '%s' unknown, using generic init.\n", v);
>> -
>> -             printk(KERN_ERR "CPU: Your system may be unstable.\n");
>> -     }
>> +     printk_once(KERN_ERR "CPU: Your system may be unstable.\n");
>>
>
> You should delete the variable, right?

Yes. you're right.

> Plus, the code now uses two variables instead of one.
>
>                                                                        Pavel

Thanks for pointing me out.
I will repost the patch with your advise.


> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
Thanks,
Minchan Kim
