Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbYICI5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbYICI5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 04:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYICI5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 04:57:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:23162 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYICI5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 04:57:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=gfaGPx1XzlvrKo3nVKe4CT7IvX0sDg7ENBEU0k9rBHpsoMel7y/0LmX4hEUU8puYaQ
         eTbNh5fZPXRyuY5NSBso3DTpuajDujYg250+BM+T+rLYY8iKBbn6hXenWKnRghq9iSIe
         W2iz+SPus1arzUzY2YgSsk6Gey5cglfiunwWw=
Message-ID: <48BE5163.2090101@panasas.com>
Date: Wed, 03 Sep 2008 11:57:07 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5 ver2] debug: BUILD_BUG_ON: error on non-const	 expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com> <48BD626B.6070705@panasas.com> <48BD81B4.76E4.0078.0@novell.com>
In-Reply-To: <48BD81B4.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Boaz Harrosh <bharrosh@panasas.com> 02.09.08 17:57 >>>
>> -#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
>> +#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
>> +
>> +/* Force a compilation error if condition is true */
>> +#define BUILD_BUG_ON(e) \
>> +	do { struct {int:-!!(e); } x __maybe_unused;} while(0)
>  
> As indicated before, you should at the very least use __x as the variable
> name.
> 

The name does not matter. The scope of x is confined to the do {} while()
and will not interfere with any local or global name.  

> But didn't you have reservations against using a bitfield here? Or was it
> really just the void cast on the sizeof() that you disliked?
> 

I like it it's fine. Also an added bonus is that on the good case it compiles
to a size-less structure in a code-less block so even the most stupid 
non-optimizing compiler will get it right. OK that could be done with 0-length
array too. But for consistency's sake I like it that both macros are the same.

> Jan
> 

I would like it if you sent your Signed-off-by: (or something) on this patch.
Thanks for your help
Boaz
