Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbYCMWss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbYCMWss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbYCMWs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:48:29 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14842 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYCMWs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:48:27 -0400
Date: Thu, 13 Mar 2008 15:46:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: whose job is it to include various header files?
Message-Id: <20080313154631.ae147130.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.1.00.0803131802020.20317@localhost.localdomain>
References: <alpine.LFD.1.00.0803131802020.20317@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 18:09:12 -0400 (EDT) Robert P. J. Day wrote:

> 
>   more a philosophy question than anything but, while poking around
> the percpu stuff today, i noticed in the header file linux/percpu.h
> the opening snippet:
> 
>  #include <linux/preempt.h>
>  #include <linux/slab.h> /* For kmalloc() */
>  #include <linux/smp.h>
>  #include <linux/string.h> /* For memset() */
>  #include <linux/cpumask.h>
>  ...
> 
> hmmm, i thought to myself (because that's how i refer to myself), i
> wonder why this header file is including headers for kmalloc() and
> memset() when this header file makes no reference to those routines.
> let's see what happens if i remove them and:
> 
>   $ make distclean
>   $ make defconfig    [x86]
>   $ make
> 
> ... chug chug chug ...
> 
>   CC      arch/x86/kernel/nmi_32.o
> arch/x86/kernel/nmi_32.c: In function ‘check_nmi_watchdog’:
> arch/x86/kernel/nmi_32.c:81: error: implicit declaration of function ‘kmalloc’
> arch/x86/kernel/nmi_32.c:81: error: ‘GFP_KERNEL’ undeclared (first use in this function)
> arch/x86/kernel/nmi_32.c:81: error: (Each undeclared identifier is reported only once
> arch/x86/kernel/nmi_32.c:81: error: for each function it appears in.)
> arch/x86/kernel/nmi_32.c:81: warning: assignment makes pointer from integer without a cast
> arch/x86/kernel/nmi_32.c:118: error: implicit declaration of function ‘kfree’
> make[1]: *** [arch/x86/kernel/nmi_32.o] Error 1
> make: *** [arch/x86/kernel] Error 2
> $
> 
>   ok, now i know.  but that means, of course, that nmi_32.c is
> invoking kmalloc() without ever having included the necessary header
> file for it -- it's just inheriting that from linux/percpu.h.
> 
>   doesn't that (sort of) violate the kernel coding style?  if a file
> somewhere needs the contents of some header file, isn't it that file's
> responsibility to explicitly include it, and not quietly realize it's
> getting it from elsewhere?

Yes.

---
~Randy
