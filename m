Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbZD1RcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbZD1RcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbZD1RcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:32:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37110 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbZD1RcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:32:08 -0400
Message-ID: <49F73D96.2090801@garzik.org>
Date: Tue, 28 Apr 2009 13:32:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: x86@kernel.org
Subject: [x86] Strange 64-bit put_user ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/x86/include/asm/uaccess.h, if !CONFIG_X86_32, we see

> #define __put_user_x8(x, ptr, __ret_pu) \
>         ({ u64 __ret_pu; __put_user_x(8, x, ptr, __ret_pu); (int)__ret_pu; })

which was preceded by

> #define __put_user_x(size, x, ptr, __ret_pu)                    \
>         asm volatile("call __put_user_" #size : "=a" (__ret_pu) \
>                      :"0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")


My question, from an admitted inline asm newbie:

Why is 32-bit register 'ebx' being used for a 64-bit put_user?

And a dumb-question follow-up, probably easy, for any x86 expert:  why 
are registers 'bl' and 'bx' not used for 8-bit and 16-bit put_user, 
respectively?

Thanks,

	Jeff



