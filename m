Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbYLDOeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbYLDOeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbYLDOeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:34:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:55713 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbYLDOeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:34:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jody McIntyre <scjody@sun.com>
Subject: Re: [PATCH] Fix compile error in arch/x86/kernel/syscall_64.c
Date: Thu, 4 Dec 2008 15:32:59 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       tglx@linutronix.de, mingo@redhat.com
References: <20081202215154.GL29919@clouds>
In-Reply-To: <20081202215154.GL29919@clouds>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812041533.00736.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+feWzXRGCoOBKJ8Qp36RSMfIXC+vRfUqKY+57
 8UM6w/9SFdpv6mQhNC6prq9l5jogjv5ljfGUf4N9fkyMOF7xC8
 QK5a8Iwim59flulPzQyoA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 December 2008, Jody McIntyre wrote:
> 1965aae3c98397aad957412413c07e97b1bd4e64 broke compilation on one of my
> systems:
> 
>   CC      arch/x86/kernel/syscall_64.o
> arch/x86/kernel/syscall_64.c:27: error: array index in initializer exceeds array bounds
> arch/x86/kernel/syscall_64.c:27: error: (near initialization for ‘sys_call_table’)
> arch/x86/kernel/syscall_64.c:27: warning: excess elements in array initializer
> arch/x86/kernel/syscall_64.c:27: warning: (near initialization for ‘sys_call_table’)
> make[1]: *** [arch/x86/kernel/syscall_64.o] Error 1
> make: *** [arch/x86/kernel/syscall_64.o] Error 2
> 
> Reverting only the parts of the commit that change ASM_X86__UNISTD_64_H
> to _ASM_X86_UNISTD_64_H fixes the problem.  Patch below.
> 
> I have no idea what's going on here.  Compiler bug?

Maybe you have stale header files in include/asm-x86/? That sometimes
happens if you git-checkout -f or git-reset --hard.

	Arnd <><
