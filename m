Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYFDFUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYFDFUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 01:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbYFDFUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 01:20:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:45445 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYFDFUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 01:20:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gqd+HdiG7Cd5JLQSElYrHjCp0m08sbbtZhckkr7tpUfEqWl3fnItm+Hw2klvFHsFrZWPPPVnKll3uBl74aQxSQx0tl+8PoFHmwttdJXifUdwdg7masDB05rOklnMMb2V4L/MoQgTvF6HodabbbLMI8UKG6Cw8M0P2v383CHt7CI=
Message-ID: <5d6222a80806032220ta8d3847l3ce0c0a8df135446@mail.gmail.com>
Date: Wed, 4 Jun 2008 02:20:18 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] Make x86 latest boot with non-discontig boxes
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <86802c440806032151l5faedf22xe0107d4c99c55c21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212552507-15134-1-git-send-email-gcosta@redhat.com>
	 <86802c440806032151l5faedf22xe0107d4c99c55c21@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 1:51 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Tue, Jun 3, 2008 at 9:08 PM, Glauber Costa <gcosta@redhat.com> wrote:
>> Commit 0596152388e234efebce464355186ad9e16c8cb6
>> broke my box, since it removes completely the call to
>> memory_present() at e820 setup.
>>
>> It seems to be really not needed with discontig memory,
>> but with flat and sparse, I get an early crash. The proposed patch
>> moves the call memory_present() to setup_memory, the one
>> present in setup_32.c.
>>
>> Signed-off-by: Glauber Costa <gcosta@redhat.com>
>> CC: Yinghai Lu <yhlu.kernel@gmail.com>
>> ---
>>  arch/x86/kernel/setup_32.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
>> index 2901042..841eb2f 100644
>> --- a/arch/x86/kernel/setup_32.c
>> +++ b/arch/x86/kernel/setup_32.c
>> @@ -388,6 +388,8 @@ static unsigned long __init setup_memory(void)
>>  #ifdef CONFIG_FLATMEM
>>        max_mapnr = num_physpages;
>>  #endif
>> +       memory_present(0, 0, max_pfn);
>> +
>>        printk(KERN_NOTICE "%ldMB LOWMEM available.\n",
>>                        pages_to_mb(max_low_pfn));
>>
>> --
> thanks
>
> http://lkml.org/lkml/2008/6/3/229
> [PATCH] x86: change propagate_e820_map back to find_max_pfn -32bit - fix
>
> already address that.
>
> YH

Great.

I guess it was not on the tree yet, then.

-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
