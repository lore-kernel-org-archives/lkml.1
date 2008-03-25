Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbYCYUvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbYCYUvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYCYUvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:51:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:54059 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYCYUvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:51:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=P2Io9tXT/AliLxK4vAy+ODUfIW0rviwME0ivk8K2h7UrwXfJ8xchRW7/nLoMuXJtyxK81UpMwkcvK+FTkLnkQQZJXPXGtZgAvgGCNilYBR9K5JGh8Siiuv1FyCxp45KXVIEZmzc3n7SEvru+DcS5vf4gPh2vmdL1VfvoS4stuek=
Message-ID: <47E965BD.7010604@gmail.com>
Date: Tue, 25 Mar 2008 22:51:09 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: gcc-4.3 considers unaligned accesses on X86 as undefined
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello x86 architecture maintainers,

GCC-4.3 now considers that it is undefined behaviour to access memory
through an int*  that is not aligned to sizeof(int).
At -O3 it generates vectorized code that  _relies_  on the fact that
pointers are always aligned (unless you use packed attributes, etc.),
and the resulting code crashes if the pointer is unaligned.  (-O3 -msse
on 32-bit, and simply -O3 on 64-bit since -msse is default)
See this gcc bugreport: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=35653
[I do not really agree with this sudden change, because unaligned
accesses have always been possible on x86, but the C99 standard does say
it is undefined behaviour ...]

I thought to inform you of this change in gcc's behaviour, because
include/asm-x86/unaligned.h is no longer safe in the above context,
especially that it is being used in a loop:
http://lxr.linux.no/linux/net/bluetooth/bnep/core.c#L153

P.S.: I only compile my kernels with -O2, so I don't know if it actually
crashes or not at -O3.

Best regards,
--Edwin

