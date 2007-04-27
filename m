Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbXD0OmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbXD0OmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbXD0OmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:42:12 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:54063 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901AbXD0OmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:42:10 -0400
Message-ID: <46320ACD.6090704@hp.com>
Date: Fri, 27 Apr 2007 10:38:05 -0400
From: Peter Keilty <peter.keilty@hp.com>
User-Agent: Mozilla Thunderbird 1.0RC1 (X11/20041209)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-ia64@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Eric Whitney <eric.whitney@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ia64: convert to use clocksource code
References: <20070426202632.23343.54944.sendpatchset@rambler.zko.hp.com> <1177621673.12796.121.camel@imap.mvista.com>
In-Reply-To: <1177621673.12796.121.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:

>On Thu, 2007-04-26 at 16:26 -0400, Peter Keilty wrote:
>
>  
>
>>+        .mask           = (1LL << 40) - 1,
>>+        .mult           = 0, /*to be caluclated*/
>>+        .shift          = 16,
>>+        .is_continuous  = 1,
>> };
>>    
>>
>
>You should use CLOCKSOURCE_MASK() here ..
>
>  
>
It is correct in patch 3, I believe.

>  
>
>> 
>>diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
>>index daa4940..a20b4d6 100644
>>--- a/include/linux/clocksource.h
>>+++ b/include/linux/clocksource.h
>>@@ -61,6 +61,9 @@ struct clocksource {
>> 	u32 shift;
>> 	unsigned long flags;
>> 	cycle_t (*vread)(void);
>>+#ifdef CONFIG_IA64
>>+	void *fsys_mmio_ptr;	/* used by fsyscall asm code */
>>+#endif
>>    
>>
>
>Could you explain in detail why this is needed?
>  
>
This ptr is needed to hold the mmio address to read the cycle value.
The fast ia64 path utilizies a special gate page which can allow user
code to execute small amount of kernel code, normal calling a function
not done and so the address is need. The fast syscall path executes on
user stack, between user/kernel state. And if the the fast path has to 
fallback
to the slow syscall code the vread will be needed and used.
Hope this helps.

>Daniel
>
>  
>
