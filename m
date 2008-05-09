Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbYEIJyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbYEIJyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYEIJyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:54:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:30553 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYEIJyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=D6dv3j4zpc8zx9Ni6GVmJCCfnhF3LtwP8Li3zf9V8ifENlvutCel3IRqkeUGJVqWJV4b5pH/gJuDlOGZANpd4hGlauUiCt7NNSvg1568AaY9DNxfrAHpKFI3rcmD5SpCMY/4ifVzSVdWNGEeRhlSnvNi82dJLfwVsu4dWoJAH0E=
Date: Fri, 9 May 2008 17:52:44 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: toralf.foerster@gmx.de
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager:
	multiple definition of `phys_cpu_present_map'
Message-ID: <20080509095244.GJ2543@hacking>
References: <200805091114.00244.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805091114.00244.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 11:13:57AM +0200, =?ISO-8859-1?Q?Toralf_F=F6rster_ wrote:
>Hello,
>
>the build (.config attached) failed, make ends with :
>...
>  AR      arch/x86/lib/lib.a
>  LD      vmlinux.o
>arch/x86/mach-voyager/built-in.o:(.bss+0x2c): multiple definition of `phys_cpu_present_map'
>arch/x86/kernel/built-in.o:(.bss+0x200): first defined here
>ld: Warning: size of symbol `phys_cpu_present_map' changed from 32 in arch/x86/kernel/built-in.o to 4 in arch/x86/mach-voyager/built-in.o
>make: *** [vmlinux.o] Error 1
>

Sorry. Ignore previous one. This one should be correct, I think.

---

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 8acbf0c..2e8388b 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -74,7 +74,7 @@ EXPORT_SYMBOL(cpu_online_map);
 
 /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
  * by scheduler but indexed physically */
-cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
+static cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
 
 /* The internal functions */
 static void send_CPI(__u32 cpuset, __u8 cpi);
