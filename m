Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbZD2Adw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbZD2Adw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 20:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZD2Adn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 20:33:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbZD2Adm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 20:33:42 -0400
Message-ID: <49F79FEF.80508@kernel.org>
Date: Tue, 28 Apr 2009 17:31:43 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [x86] Strange 64-bit put_user ?
References: <49F73D96.2090801@garzik.org>
In-Reply-To: <49F73D96.2090801@garzik.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> In arch/x86/include/asm/uaccess.h, if !CONFIG_X86_32, we see
> 
>> #define __put_user_x8(x, ptr, __ret_pu) \
>>         ({ u64 __ret_pu; __put_user_x(8, x, ptr, __ret_pu);
>> (int)__ret_pu; })
> 
> which was preceded by
> 
>> #define __put_user_x(size, x, ptr, __ret_pu)                    \
>>         asm volatile("call __put_user_" #size : "=a" (__ret_pu) \
>>                      :"0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
> 
> 
> My question, from an admitted inline asm newbie:
> 
> Why is 32-bit register 'ebx' being used for a 64-bit put_user?
> 
> And a dumb-question follow-up, probably easy, for any x86 expert:  why
> are registers 'bl' and 'bx' not used for 8-bit and 16-bit put_user,
> respectively?
> 

The answer is simply that gcc doesn't make a distinction between bl, bx,
ebx, and rbx -- it considers it a single regioster which can contain an
8-, 16-, 32- or 64-bit number.  In particular, gcc can't use ah, bh, ch,
and dh as independent registers at all.

	-hpa

