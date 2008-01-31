Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbYAaOaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbYAaOaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:30:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYAaO3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:29:54 -0500
Received: from virt2h.secure-wi.com ([209.216.203.82]:40678 "EHLO
	virt2h.secure-wi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbYAaO3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:29:53 -0500
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2008 09:29:52 EST
X-ClientAddr: 24.8.33.16
Message-ID: <47A1D9AE.4090206@wildturkeyranch.net>
Date: Thu, 31 Jan 2008 07:22:38 -0700
From: George Anzinger <george@wildturkeyranch.net>
Reply-To: george@wildturkeyranch.net
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       kgdb-bugreport@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Kgdb-bugreport] [PATCH 1/5] KGDB: improve early init
References: <479FBA3B.5050209@web.de> <47A10355.9090707@web.de>
In-Reply-To: <47A10355.9090707@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-webintellects-MailScanner-Information: Please contact the ISP for more information
X-webintellects-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: george@wildturkeyranch.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2008 01:36 AM,  Jan Kiszka was caught saying:
 > Jan Kiszka wrote:
 >> George Anzinger wrote:
 >>> On 01/30/2008 04:08 PM,  Jan Kiszka was caught saying:
 >>>> [Here comes a rebased version against latest x86/mm]
 >>>>
 >>>> In case "kgdbwait" is passed as kernel parameter, KGDB tries to set up
 >>>> and connect to the front-end already during early_param evaluation.
 >>>> This
 >>>> fails on x86 as the exception stack is not yet initialized, 
effectively
 >>>> delaying kgdbwait until late-init.
 >>>
 >>> I wonder how much work it would take to just set up the exception
 >>> stack and proceed.  After all the kgbdwait is there to help debug
 >>> very early kernel code...
 >>
 >> In principle a valid question, but I'm not the one to answer it. I
 >> would not feel very well if I had to reorder this critical setup code.
 >> Look, we would have to move trap_init in start_kernel before
 >> parse_early_param, and that would affect _every_ arch...

I can not speak to other archs, but for x86 I called trap_init from the 
code that caught the kgdbwait.  At that time (since I retired, I have 
not looked at the actual kernel code) it could be called again later by 
the kernel code.  I.e. I did not try to reorder the kernel bring up 
code, but just added an additional call to trap_init and then only in 
the case of finding a kgdbwait.

As such, this would need to be arch specific...

 >>
 >
 > BTW, do you know if EXCEPTION_STACK_READY fails for other archs in
 > parse_early_param as well? It should, because my under standing of
 > trap_init is that it's the functions to arm things like... exception
 > handlers? And that raises the question of the deeper purpose of this
 > check (and the invocation of kgdb_early_init from the argument parsing
 > function). Sigh, KGDB is still a quite improvable piece of code.

Likely.  Once you get it in the main line kernel, one would hope that 
other arch code would be forth coming as many more "eyes" will be in play.
 >
 > Jan
 >
 > PS: Can we move this to some public list?

Sure, sorry I picked the wrong reply button, never intended it to be 
private.
 >

-- 
George Anzinger   george@wildturkeyranch.net


