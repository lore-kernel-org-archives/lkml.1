Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYEIJ6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYEIJ6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYEIJ6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:58:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:37943 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751288AbYEIJ6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:58:24 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18Ax/8OajgAbxwgEr3la69BedFY2I/EqT1SVFfLh2
	GJU8WOmQ+pfSoz
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager: multiple definition of `phys_cpu_present_map'
Date: Fri, 9 May 2008 11:58:21 +0200
User-Agent: KMail/1.9.7
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org
References: <200805091114.00244.toralf.foerster@gmx.de> <20080509093017.GI2543@hacking>
In-Reply-To: <20080509093017.GI2543@hacking>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805091158.21562.toralf.foerster@gmx.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Friday 09 May 2008 11:30:17 WANG Cong wrote :
> On Fri, May 09, 2008 at 11:13:57AM +0200, =?ISO-8859-1?Q?Toralf_F=F6rster_ wrote:
> >Hello,
> >
> >the build (.config attached) failed, make ends with :
> >...
> >  AR      arch/x86/lib/lib.a
> >  LD      vmlinux.o
> >arch/x86/mach-voyager/built-in.o:(.bss+0x2c): multiple definition of `phys_cpu_present_map'
> >arch/x86/kernel/built-in.o:(.bss+0x200): first defined here
> >ld: Warning: size of symbol `phys_cpu_present_map' changed from 32 in arch/x86/kernel/built-in.o to 4 in arch/x86/mach-voyager/built-in.o
> >make: *** [vmlinux.o] Error 1
> 
> Could you please try my quick patch below?
> 
yep, that issue is fixed :-)

BTW now the config failed as at expected due to :
...
  MODPOST 156 modules
ERROR: "i2c_master_send" [drivers/media/video/tuner.ko] undefined!
ERROR: "i2c_detach_client" [drivers/media/video/tuner.ko] undefined!
ERROR: "i2c_del_driver" [drivers/media/video/tuner.ko] undefined!

> ---
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index cc6f5eb..98617df 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -21,9 +21,6 @@ EXPORT_SYMBOL(boot_cpu_physical_apicid);
>  DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
>  EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
>  
> -/* Bitmask of physically existing CPUs */
> -physid_mask_t phys_cpu_present_map;
> -
>  #if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
>  /*
>   * Copy data used in early init routines from the initial arrays to the
> 



-- 
MfG/Sincerely

Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
