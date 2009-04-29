Return-Path: <linux-kernel-owner+w=401wt.eu-S1760721AbZD2UB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721AbZD2UB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761200AbZD2UAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:00:53 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55464 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761205AbZD2UAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:00:52 -0400
Message-ID: <49F8B1F3.90900@garzik.org>
Date: Wed, 29 Apr 2009 16:00:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [x86] Strange 64-bit put_user ?
References: <49F73D96.2090801@garzik.org> <49F79FEF.80508@kernel.org>
In-Reply-To: <49F79FEF.80508@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeff Garzik wrote:
>> In arch/x86/include/asm/uaccess.h, if !CONFIG_X86_32, we see
>>
>>> #define __put_user_x8(x, ptr, __ret_pu) \
>>>         ({ u64 __ret_pu; __put_user_x(8, x, ptr, __ret_pu);
>>> (int)__ret_pu; })
>> which was preceded by
>>
>>> #define __put_user_x(size, x, ptr, __ret_pu)                    \
>>>         asm volatile("call __put_user_" #size : "=a" (__ret_pu) \
>>>                      :"0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
>>
>> My question, from an admitted inline asm newbie:
>>
>> Why is 32-bit register 'ebx' being used for a 64-bit put_user?
>>
>> And a dumb-question follow-up, probably easy, for any x86 expert:  why
>> are registers 'bl' and 'bx' not used for 8-bit and 16-bit put_user,
>> respectively?
>>
> 
> The answer is simply that gcc doesn't make a distinction between bl, bx,
> ebx, and rbx -- it considers it a single regioster which can contain an
> 8-, 16-, 32- or 64-bit number.  In particular, gcc can't use ah, bh, ch,
> and dh as independent registers at all.

So, it isn't really referring to 'ebx' register specifically, it is 
referring to the hardware register that contains 'ebx'.  Gotcha.

Thanks!

	Jeff




