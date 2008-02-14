Return-Path: <linux-kernel-owner+w=401wt.eu-S933483AbYBNALa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbYBNALa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761330AbYBNALO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:11:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:31496 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765998AbYBNALM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:11:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DtRwG7talWIu11XFGEQut/kKa8my06fqJRIVxXrdjDdTAyCy3nhUKolHORQKocl5nkIiZAe/XEI/uvdqNvFPdvt66knKUtjM21Z4D4SBFHg7DoOjvnIxhNqKKR4oFOiZj59r3qIz4ViGMMo4A5SH7RoHfjskbHNpsVNAxXhzn4c=
Message-ID: <47B38718.4030509@gmail.com>
Date: Thu, 14 Feb 2008 09:11:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH REPOST] printk: fix possible printk buffer overrun	introduced
 with recursion check
References: <47B2AE7C.608@gmail.com> <20080213124548.GB6344@elte.hu>
In-Reply-To: <20080213124548.GB6344@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> but i'm not sure i agree with the moving of these variables inside 
> vprintk:
> 
>> -/* cpu currently holding logbuf_lock */
>> -static volatile unsigned int printk_cpu = UINT_MAX;
>> -
>> -const char printk_recursion_bug_msg [] =
>> -			KERN_CRIT "BUG: recent printk recursion!\n";
>> -static int printk_recursion_bug;
>> -
>>  asmlinkage int vprintk(const char *fmt, va_list args)
>>  {
>> +	/* cpu currently holding logbuf_lock */
>> +	static volatile unsigned int printk_cpu = UINT_MAX;
>> +	static const char printk_recursion_bug_msg [] =
>> +		KERN_CRIT "BUG: recent printk recursion!\n";
>> +	static int printk_recursion_bug;
>>  	static int log_level_unknown = 1;
>>  	static char printk_buf[1024];
> 
> it's easy to miss a static variable inside a function local variables 

I find that difficult to agree.  As long as static ones are put above
all local ones, they are visually distinctive enough.  static variables
used by a single function are usually declared in the function all
through the source tree.

> block. It would b ebetter to move log_level_unknown and printk_buf 
> _outside_ the function, to the other ones. [and to mark 
> printk_recursion_bug_msg static]

Well, I thought it was an obvious clean up.  Time to split this patch
up, I guess.

Thanks.

-- 
tejun
