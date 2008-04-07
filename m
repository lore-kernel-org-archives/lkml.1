Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbYDGSOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbYDGSOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYDGSOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:14:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37828 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751369AbYDGSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:14:19 -0400
Message-ID: <47FA6478.1070301@sgi.com>
Date: Mon, 07 Apr 2008 11:14:16 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader
 decompressor
References: <20080405013014.478571000@polaris-admin.engr.sgi.com> <20080405013014.693571000@polaris-admin.engr.sgi.com> <20080405134626.GA15894@mailshack.com>
In-Reply-To: <20080405134626.GA15894@mailshack.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> On Fri, Apr 04, 2008 at 06:30:15PM -0700, Mike Travis wrote:
>>   * Increase stack size for the kernel bootloader decompressor.  This is
>>     needed to boot a kernel with NR_CPUS = 4096.  I tested with 8k stack
>>     size but that wasn't sufficient.
>>
>> Based on:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>>     +   x86/latest          .../x86/linux-2.6-x86.git
>>     +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> ---
>>  arch/x86/boot/compressed/head_64.S |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- linux-2.6.25-rc5.orig/arch/x86/boot/compressed/head_64.S
>> +++ linux-2.6.25-rc5/arch/x86/boot/compressed/head_64.S
>> @@ -314,5 +314,5 @@ gdt_end:
>>  /* Stack for uncompression */
>>  	.balign 4
>>  user_stack:
>> -	.fill 4096,4,0
>> +	.fill 16384,4,0
> --------------^^^ * ^
> 
> Changed from 16K to 64K. I wonder what is using so much space on
> this stack?
> 
>>  user_stack_end:
>>
>> -- 

Hi,

That is a good question.  It's pretty difficult to debug at that early
stage (any ideas are certainly welcome!).  It's mostly hit and miss (and
handy access to the reset button ;-)  I could do some further research
but since it's "throwaway" memory (at least I think it is), then I didn't
think it important to pursue.

And thanks for the correction, I thought I was bumping a byte count, not
a word count.

Thanks,
Mike
