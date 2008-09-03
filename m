Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbYICKxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbYICKxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbYICKxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:53:39 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:17528 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750997AbYICKxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:53:38 -0400
Message-ID: <48BE6C58.1030606@panasas.com>
Date: Wed, 03 Sep 2008 13:52:08 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5 ver2] debug: BUILD_BUG_ON: error on non-const	 expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com> <48BD626B.6070705@panasas.com> <48BD81B4.76E4.0078.0@novell.com> <48BE5163.2090101@panasas.com> <48BE80E7.76E4.0078.0@novell.com>
In-Reply-To: <48BE80E7.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2008 10:51:19.0704 (UTC) FILETIME=[FF66D980:01C90DB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Boaz Harrosh <bharrosh@panasas.com> 03.09.08 10:57 >>>
>> Jan Beulich wrote:
>>>>>> Boaz Harrosh <bharrosh@panasas.com> 02.09.08 17:57 >>>
>>>> -#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
>>>> +#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
>>>> +
>>>> +/* Force a compilation error if condition is true */
>>>> +#define BUILD_BUG_ON(e) \
>>>> +	do { struct {int:-!!(e); } x __maybe_unused;} while(0)
>>>  
>>> As indicated before, you should at the very least use __x as the variable
>>> name.
>>>
>> The name does not matter. The scope of x is confined to the do {} while()
>> and will not interfere with any local or global name.  
> 
> I'm sorry to repeat this: If x is #define-d to anything but a simple identifier,
> this will break no matter that it's in a private scope. The absence of any
> identifier was a benefit of the sizeof() approach here.
> 
> Jan
> 

#defines are a shoot-in-the-leg, they should be CAPITAL letters and very
long and unique. If any one wants to #define x, they are welcome, it will
break the kernel even before my macro. No x in a private scope is fine
#define x is not, sorry ...

OK, I would change it, but I'm too lazy to do a new post just for that.

Boaz
