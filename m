Return-Path: <linux-kernel-owner+w=401wt.eu-S1763648AbXFBXls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763648AbXFBXls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 19:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760064AbXFBXll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 19:41:41 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:11616 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbXFBXlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 19:41:40 -0400
Date: Sat, 2 Jun 2007 16:40:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.22-rc3-g184b812f build #294 failed in: undefined
 reference to `enable_apic_mode'
Message-Id: <20070602164052.6a36377f.randy.dunlap@oracle.com>
In-Reply-To: <200706012319.23761.toralf.foerster@gmx.de>
References: <200706012319.23761.toralf.foerster@gmx.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 23:19:17 +0200 Toralf Förster wrote:

> Hello,
> 
> the build with the attached .config failed, make ends with:
> ...
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/i386/kernel/built-in.o: In function `get_smp_config':
> : undefined reference to `mps_oem_check'
> arch/i386/kernel/built-in.o: In function `connect_bsp_APIC':
> : undefined reference to `enable_apic_mode'
> make: *** [.tmp_vmlinux1] Error 1
> 
> This .config was made in this way :
> make mrproper && make rndconfig && <tweak it to ThinkPad T41> && make oldconfig && make

This sort-of-randconfig is still for Unisys ES7000 sub-architecture,
so tweaking it to Thinkpad T41 doesn't get you much of anything that
is useful.  I think you can drop that step.

If you tweak it like this:
115c115
< # CONFIG_X86_PC is not set
---
> CONFIG_X86_PC=y
123c123
< CONFIG_X86_ES7000=y
---
> # CONFIG_X86_ES7000 is not set

and run 'make oldconfig', it will build.

I don't find this particular randconfig (#294) interesting, but
sometimes they can be, so don't stop trying them, please.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
