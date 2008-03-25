Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbYCYU5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbYCYU5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760098AbYCYU53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:57:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47572 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbYCYU52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:57:28 -0400
Message-ID: <47E96709.9060904@zytor.com>
Date: Tue, 25 Mar 2008 13:56:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
CC: "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: gcc-4.3 considers unaligned accesses on X86 as undefined
References: <47E965BD.7010604@gmail.com>
In-Reply-To: <47E965BD.7010604@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Török Edwin wrote:
> Hello x86 architecture maintainers,
> 
> GCC-4.3 now considers that it is undefined behaviour to access memory
> through an int*  that is not aligned to sizeof(int).
> At -O3 it generates vectorized code that  _relies_  on the fact that
> pointers are always aligned (unless you use packed attributes, etc.),
> and the resulting code crashes if the pointer is unaligned.  (-O3 -msse
> on 32-bit, and simply -O3 on 64-bit since -msse is default)
> See this gcc bugreport: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=35653
> [I do not really agree with this sudden change, because unaligned
> accesses have always been possible on x86, but the C99 standard does say
> it is undefined behaviour ...]
> 
> I thought to inform you of this change in gcc's behaviour, because
> include/asm-x86/unaligned.h is no longer safe in the above context,
> especially that it is being used in a loop:
> http://lxr.linux.no/linux/net/bluetooth/bnep/core.c#L153
> 
> P.S.: I only compile my kernels with -O2, so I don't know if it actually
> crashes or not at -O3.
> 

Generating vectorized code in the kernel is death anyway, so I don't 
think the change in alignment is an issue.  We CANNOT ALLOW vectorized 
code in the kernel under any circumstances (well, except when surrounded 
by the appropriate protection constructs.)

	-hpa
