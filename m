Return-Path: <linux-kernel-owner+w=401wt.eu-S968242AbXEHPdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968242AbXEHPdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966427AbXEHPYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:24:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35303 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966437AbXEHPYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:24:18 -0400
Date: Tue, 8 May 2007 17:24:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.21-mm1 -- x86 verify_cpu.S compile failure
Message-ID: <20070508152415.GA16967@one.firstfloor.org>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <464046EC.40301@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464046EC.40301@shadowen.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 10:46:20AM +0100, Andy Whitcroft wrote:
> We are seeing the following compile error on older x86 installs:
> 
>   arch/i386/kernel/verify_cpu.S: Assembler messages:
>   arch/i386/kernel/verify_cpu.S:13: Error: `(%esp)' is
> 			 not a valid 16 bit base/index expression
> 
> Seems to come from:
> 
>   x86_64-mm-i386-verify-cpu
> 
> Compiler:
> 
>   gcc version 3.3.4 (Debian 1:3.3.4-3)

Your compiler must be a brother in spirit of Andrew's vaio.

Does this patch help? 

-Andi


Index: linux/arch/i386/kernel/verify_cpu.S
===================================================================
--- linux.orig/arch/i386/kernel/verify_cpu.S
+++ linux/arch/i386/kernel/verify_cpu.S
@@ -10,7 +10,9 @@ verify_cpu:
 
 #if CONFIG_X86_MINIMUM_CPU_MODEL >= 4
 	pushfl
-	orl	$(1<<18),(%esp)		# try setting AC
+	pop	%eax
+	orl	$(1<<18),%eax		# try setting AC
+	push	%eax
 	popfl
 	pushfl
 	popl    %eax


