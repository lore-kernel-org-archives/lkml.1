Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbZFDViX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbZFDViX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZFDViQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:38:16 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:60221 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZFDViP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:38:15 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Dave Jones <davej@redhat.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Thu, 4 Jun 2009 16:38:13 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906041601.33400.lkml@morethan.org> <20090604212454.GA20822@redhat.com>
In-Reply-To: <20090604212454.GA20822@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041638.15480.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 4 2009, Dave Jones wrote:
> On Thu, Jun 04, 2009 at 04:01:30PM -0500, Michael S. Zick wrote:
> 
>  > But while your here, what is your opinion on this one,
>  > in: int __init pcibios_init(void)
>  > 
>  > - - - - -
>  >         pci_cache_line_size = 32 >> 2;
>  >         if (c->x86 >= 6
>  >         && (c->x86_vendor == X86_VENDOR_AMD) || (c->x86_vendor == X86_VENDOR_CENTAUR))
>  >                 pci_cache_line_size = 64 >> 2;  /* K7 & K8 and VIA C7-M */
>  >         else if (c->x86 > 6 && c->x86_vendor == X86_VENDOR_INTEL)
>  >                 pci_cache_line_size = 128 >> 2; /* P4 */
>  > 
>  > Mike
> 
> C7's L1 cachelines are 64 bytes, so it's right in that case,
> but the earlier Centaur CPUs are 32 bytes, so it should be checking steppings.
> 
> Or better yet, why not just set it to boot_cpu_data->x86_clflush_size ?
> 

I have already preceded that chunk of code with a printk and confirmed
that x86_clflush_size is properly set to 64 bytes (somewhere else).

So your suggestion is the obvious one for the C7-M,
I don't know about any other makes/models. 

This machine's C7-M is being reported as a "stepping 0" ??
What is earlier than a stepping 0 ??

Mike

> 	Dave
> 
> 
> 


