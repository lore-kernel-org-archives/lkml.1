Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYAWTIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYAWTIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYAWTIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:08:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:2703 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbYAWTIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:08:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rd80Z0ZM3pMabukbM85j2cFyQsF41TmLL/O2wIhp1YCAjxc/BRxY6fFWkarps0CZP9yrseNvf33t9i9VC4tqBJDUhfGU0Jstl8DVMBZvF9v0momTBOFxvdu49ZTt0XgAZ8d8OvXVHLnpNcKpcxm0L1G3Auq9RBi370GI2q6suT0=
Date: Wed, 23 Jan 2008 22:07:42 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Paulo Marques <pmarques@grupopie.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/6] POWERPC: use KSYM_NAME_LEN
Message-ID: <20080123190742.GH12877@cvg>
References: <20080123173832.GA12877@cvg> <479786D4.9080601@grupopie.com> <20080123184343.GG12877@cvg> <47978E7D.9060606@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47978E7D.9060606@grupopie.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Paulo Marques - Wed, Jan 23, 2008 at 06:59:09PM +0000]
> Cyrill Gorcunov wrote:
>> [Paulo Marques - Wed, Jan 23, 2008 at 06:26:28PM +0000]
>>> Cyrill Gorcunov wrote:
>>>> [...]
>>>>  	case 's':
>>>> -		getstring(tmp, 64);
>>>> +		getstring(tmp, sizeof(tmp));
>>>>  		if (setjmp(bus_error_jmp) == 0) {
>>>>  			catch_memory_errors = 1;
>>>>  			sync();
>> just after that poin in the original code a call to kallsyms_lookup_name
>> is done - so i think it could be an overflow (of course it depends
>> on what *exactly* the name is being searched, and Paulo - I didn't
>> managed to get *the whole picture* of what is going on in this
>> code - so the thoughs were like: kallsyms_lookup_name could find
>> a quite long name restricted by KSYM_NAME_LEN (dunno how it could
>> happens - due to buggy code or due to memory corruption outside,
>> it does not matter - the only matter - it *could* find that long
>> name).
>
> Ah, now I understand your confusion: kallsyms_lookup_name doesn't fill the 
> name. It searches the name and returns the address. It is the _caller_ that 
> fills the name, not kallsyms_lookup_name.
>
> It is used for stuff like: "give me the address of function foo":
> addr = kallsyms_lookup_name("foo");
>

oh my, how could I oversight that... damn!!! my bad!!!

>> Anyway - it's just an attempt ;) we always could drop it far-far away ;)
>
> I think that using KSYM_NAME_LEN would be a nice cleanup for xmon, but it 
> is for the powerpc guys to decide if they want to do it. I just wanted to 
> point the change in behavior so that it wouldn't go unnoticed.

thanks, it's really important

>
> For all we know, the stack may at that point be close to full and an extra 
> 64 bytes may tip it over the edge.
>

oops, thanks for pointing out

>>> This also introduces a change in behavior. It is still a nice cleanup, 
>>> though. So, if the powerpc people feel they can spare an extra 64 bytes 
>>> of stack here, I guess it's ok.
>> Thanks a lot for review Paulo!
>
> No problem. I always keep an eye out for kallsyms related stuff.

;)

>
> -- 
> Paulo Marques - www.grupopie.com
>
> "There cannot be a crisis today; my schedule is already full."
>
		- Cyrill -
