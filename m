Return-Path: <linux-kernel-owner+w=401wt.eu-S966278AbXDDCSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966278AbXDDCSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966287AbXDDCSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:18:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63855 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966278AbXDDCSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:18:34 -0400
Date: Tue, 3 Apr 2007 19:20:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm4
Message-Id: <20070403192004.986b44ec.randy.dunlap@oracle.com>
In-Reply-To: <24083.1175650554@turing-police.cc.vt.edu>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	<24083.1175650554@turing-police.cc.vt.edu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007 21:35:54 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Mon, 02 Apr 2007 22:47:45 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> 
> So I was looking at a patch for ACPI_SLEEP that went around a moment ago,
> and ended up doing a 'make menuconfig'.
> 
> I do a '/ACPI_SLEEP' inside that, and I get this output:
> 
> x Symbol: ACPI_SLEEP [=n]                                                 x  
>   x Prompt: Sleep States                                                    x  
>   x   Defined at drivers/acpi/Kconfig:49                                    x  
>   x   Depends on: !X86_NUMAQ && !X86_VISWS && !IA64_HP_SIM && (IA64 || X86) x  
>   x   Location:                                                             x  
>   x     -> Power management options                                         x  
>   x       -> Power Management support (PM [=y])                             x  
>   x         -> ACPI (Advanced Configuration and Power Interface) Support    x  
>   x           -> ACPI Support (ACPI [=y])   
> 
> Only problem is that drivers/acpi/Kconfig:49 says:
> 
> config ACPI_SLEEP
>         bool "Sleep States"
>         depends on X86 && (!SMP || SUSPEND_SMP)
>         depends on PM
>         default y
> 
> Can somebody explain why I'm seeing the different Depends on in the two places?

Due to the top of drivers/acpi/Kconfig:

menu "ACPI (Advanced Configuration and Power Interface) Support"
	depends on !X86_NUMAQ
	depends on !X86_VISWS
	depends on !IA64_HP_SIM
	depends on IA64 || X86
	depends on PM


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
