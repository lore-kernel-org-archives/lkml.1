Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbYLDTM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbYLDTM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759527AbYLDTMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:12:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59246 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759504AbYLDTMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:12:33 -0500
Message-ID: <49382B85.1020803@zytor.com>
Date: Thu, 04 Dec 2008 11:12:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jody McIntyre <scjody@sun.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] Fix compile error in arch/x86/kernel/syscall_64.c
References: <20081202215154.GL29919@clouds> <200812041533.00736.arnd@arndb.de>
In-Reply-To: <200812041533.00736.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Tuesday 02 December 2008, Jody McIntyre wrote:
>> 1965aae3c98397aad957412413c07e97b1bd4e64 broke compilation on one of my
>> systems:
>>
>>   CC      arch/x86/kernel/syscall_64.o
>> arch/x86/kernel/syscall_64.c:27: error: array index in initializer exceeds array bounds
>> arch/x86/kernel/syscall_64.c:27: error: (near initialization for ‘sys_call_table’)
>> arch/x86/kernel/syscall_64.c:27: warning: excess elements in array initializer
>> arch/x86/kernel/syscall_64.c:27: warning: (near initialization for ‘sys_call_table’)
>> make[1]: *** [arch/x86/kernel/syscall_64.o] Error 1
>> make: *** [arch/x86/kernel/syscall_64.o] Error 2
>>
>> Reverting only the parts of the commit that change ASM_X86__UNISTD_64_H
>> to _ASM_X86_UNISTD_64_H fixes the problem.  Patch below.
>>
>> I have no idea what's going on here.  Compiler bug?
> 
> Maybe you have stale header files in include/asm-x86/? That sometimes
> happens if you git-checkout -f or git-reset --hard.
> 

"git cleanup" should be used to catch that classes of problems.  I did
notice that the include file trace used include/asm not
arch/x86/include/asm, which to me implies something like this.

I just tried, and when I make a .i file on a clean tree I get:

# 10 "<full path>/arch/x86/include/asm/posix_types_64.h"

not

# 10 "include/asm/posix_types_64.h"

as the posted .i file has.

	-hpa
