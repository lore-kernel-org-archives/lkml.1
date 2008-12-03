Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbYLCSAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbYLCSAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbYLCSAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:00:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41607 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYLCSAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:00:34 -0500
Message-ID: <4936C927.3030504@zytor.com>
Date: Wed, 03 Dec 2008 10:00:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jody McIntyre <scjody@sun.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] Fix compile error in arch/x86/kernel/syscall_64.c
References: <20081202215154.GL29919@clouds>
In-Reply-To: <20081202215154.GL29919@clouds>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jody McIntyre wrote:
> 1965aae3c98397aad957412413c07e97b1bd4e64 broke compilation on one of my
> systems:
> 
>   CC      arch/x86/kernel/syscall_64.o
> arch/x86/kernel/syscall_64.c:27: error: array index in initializer exceeds array bounds
> arch/x86/kernel/syscall_64.c:27: error: (near initialization for ‘sys_call_table’)
> arch/x86/kernel/syscall_64.c:27: warning: excess elements in array initializer
> arch/x86/kernel/syscall_64.c:27: warning: (near initialization for ‘sys_call_table’)
> make[1]: *** [arch/x86/kernel/syscall_64.o] Error 1
> make: *** [arch/x86/kernel/syscall_64.o] Error 2
> 
> Reverting only the parts of the commit that change ASM_X86__UNISTD_64_H
> to _ASM_X86_UNISTD_64_H fixes the problem.  Patch below.
> 
> I have no idea what's going on here.  Compiler bug?
> 

Okay, this makes no sense whatsoever.  Could you send me the following:

a. the .config you're using;
b. what kernel headers do you have in /usr/include
   (if you installed the old ones with the broken header guards
   with "make headers_install", then your development environment
   is broken);
c. "make arch/x86/kernel/syscall_64.i".

	-hpa
