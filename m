Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbYEIJcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbYEIJcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbYEIJcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:32:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:36259 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYEIJcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=q15cV1D4nD+o5E06N+BeIq3gaZSkzHuRF1N+MnfQlHK9bvfMZgVDUX+27IcpVQ/X0cu5ghqSiD4/UTKyNMy8/9OdlRDqwZzNDUs0dWHpX50DsHQPR4UujvPguVgw6RdEzxzIza6NIKCtyZljCTBAydl69cijv4YHJVlh6GPuZbM=
Date: Fri, 9 May 2008 17:30:17 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: toralf.foerster@gmx.de
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager:
	multiple definition of `phys_cpu_present_map'
Message-ID: <20080509093017.GI2543@hacking>
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

Could you please try my quick patch below?

---
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cc6f5eb..98617df 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -21,9 +21,6 @@ EXPORT_SYMBOL(boot_cpu_physical_apicid);
 DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
-/* Bitmask of physically existing CPUs */
-physid_mask_t phys_cpu_present_map;
-
 #if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
 /*
  * Copy data used in early init routines from the initial arrays to the
