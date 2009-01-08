Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbZAHBoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbZAHBoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 20:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbZAHBoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 20:44:00 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36052 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZAHBn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 20:43:59 -0500
Message-ID: <49655A3C.9020908@ct.jp.nec.com>
Date: Wed, 07 Jan 2009 17:43:24 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC -tip 0/4] x86: reduce fixup of uaccess
References: <4962CAAE.6090300@ct.jp.nec.com> <496476D0.5040607@zytor.com>
In-Reply-To: <496476D0.5040607@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hiroshi Shimamoto wrote:
>> This is my second try to reduce fixup code size for exceptions of uaccess.
>>
>> This patch series reduces fixup code for exceptions of uaccess in signal.
>>
>> I gave up to make direct jump to end of function when an exception occurs.
>> However, I thought fixup code could be reduced. The concept is that to add
>> uaccess_err in thread_info and set it to -EFAULT on exception, finally check
>> this value on the last of function.
>>
>> Is this good to reduce code size?
>>
> 
> Hello Hiroshi,

Hello Peter,

> 
> The patches look technically really nice.  I have a couple of stylistic
> comments, though, which I'd like yours and others' comments on.

Thanks for comments.

> 
> This introduces a new blocking construct, and it's not immediately
> obvious in the source code.  I think introducing a technically redundant

Yeah, I think it's not friendly about readability now.

> set of braces and dropping the parens from the try construct and the
> redundant pointer might look better:
> 
> 	get_user_try {
> 		/* do stuff */
> 	} get_user_catch(err);

OK, I'll update like that.

> 
> This makes it, in my opinion, much clearer that it is a new bracing
> construct, and it also eliminates the need to form a pointer to "err"

I'm not sure which is better plain "err" or pointer to "err".

> (even though the compiler doesn't actually do so, it looks like it does
> to the programmer.)
> 
> Also, I don't think we need double underscores for the wrapping
> construct, since the get_user/__get_user (check/nocheck) etc.
> distinction doesn't directly apply there.

OK. Will drop underscores.

I'll repost update patches.

Thanks,
Hiroshi

