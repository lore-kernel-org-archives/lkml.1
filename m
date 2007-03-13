Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbXCMFbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbXCMFbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 01:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXCMFbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 01:31:45 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33509 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbXCMFbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 01:31:44 -0400
Date: Mon, 12 Mar 2007 22:31:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zachary Amsden <zach@vmware.com>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] Fix vmi time header bug
Message-Id: <20070312223136.dc6969f3.akpm@linux-foundation.org>
In-Reply-To: <45F5DB00.1070506@vmware.com>
References: <45F5DB00.1070506@vmware.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 12 Mar 2007 14:58:08 -0800 Zachary Amsden <zach@vmware.com> wrote:
> Some gcc put this function in .init.text because the header didn't 
> match.  For 2.6.21-rc.
> 
> Zach
> 
> 
> [vmi-devinit-header-fix.patch  text/plain (606B)]
> 
> 
> Index: linux-2.6.21/include/asm-i386/vmi_time.h
> ===================================================================
> --- linux-2.6.21.orig/include/asm-i386/vmi_time.h	2007-03-06 18:56:03.000000000 -0800
> +++ linux-2.6.21/include/asm-i386/vmi_time.h	2007-03-12 13:55:16.000000000 -0800
> @@ -54,7 +54,7 @@ extern unsigned long vmi_cpu_khz(void);
>  
>  #ifdef CONFIG_X86_LOCAL_APIC
>  extern void __init vmi_timer_setup_boot_alarm(void);
> -extern void __init vmi_timer_setup_secondary_alarm(void);
> +extern void __devinit vmi_timer_setup_secondary_alarm(void);
>  extern void apic_vmi_timer_interrupt(void);
>  #endif

Really truly?   I think we have a _lot_ of declarations which omit the section
qualifier altogether.  How come they don't all break too?

(ARM (at least) in fact does require the section tagging on the declaration as
well as the definition, but we've thus far only fixed that in a couple of places
which were causing breakage).
