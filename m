Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYICKSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYICKSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYICKSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:18:34 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:2099 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYICKSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:18:33 -0400
Message-Id: <48BE80E7.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Wed, 03 Sep 2008 11:19:51 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Cc: "David S. Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Ivo van Doorn" <IvDoorn@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Theodore Tso" <tytso@mit.edu>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5 ver2] debug: BUILD_BUG_ON: error on non-const
	 expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com>
 <48BD626B.6070705@panasas.com> <48BD81B4.76E4.0078.0@novell.com>
 <48BE5163.2090101@panasas.com>
In-Reply-To: <48BE5163.2090101@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Boaz Harrosh <bharrosh@panasas.com> 03.09.08 10:57 >>>
>Jan Beulich wrote:
>>>>> Boaz Harrosh <bharrosh@panasas.com> 02.09.08 17:57 >>>
>>> -#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
>>> +#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
>>> +
>>> +/* Force a compilation error if condition is true */
>>> +#define BUILD_BUG_ON(e) \
>>> +	do { struct {int:-!!(e); } x __maybe_unused;} while(0)
>>  
>> As indicated before, you should at the very least use __x as the variable
>> name.
>> 
>
>The name does not matter. The scope of x is confined to the do {} while()
>and will not interfere with any local or global name.  

I'm sorry to repeat this: If x is #define-d to anything but a simple identifier,
this will break no matter that it's in a private scope. The absence of any
identifier was a benefit of the sizeof() approach here.

Jan

