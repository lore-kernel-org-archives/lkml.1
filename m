Return-Path: <linux-kernel-owner+w=401wt.eu-S1761332AbZE0MWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332AbZE0MWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZE0MWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:22:16 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:46741 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbZE0MWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:22:15 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [VIA Support] was: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Wed, 27 May 2009 07:22:10 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <20090524064905.GH20452@prithivi.gnumonks.org> <200905270718.11093.lkml@morethan.org>
In-Reply-To: <200905270718.11093.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905270722.13670.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed May 27 2009, Michael S. Zick wrote:
> On Sun May 24 2009, Harald Welte wrote:
> > 
> > Once I understand it in full detail, I can talk to the right people inside
> > CentaurLabs (VIA's CPU division).  
> > 
> > If somebody (optionally) can phrase a precise technical question that I can
> > directly forward to somebody with low-level x86 knowledge but no Linux background,
> > it would definitely help speeding up the process.
> > 
> 
> What is the PCI Cache Line size in the CX700?  In the CN896?
> 
> Ref:
> arch/x86/pci/common.c
> 
> As in:
>         /*
>          * Assume PCI cacheline size of 32 bytes for all x86s except K7/K8
>          * and P4. It's also good for 386/486s (which actually have 16)
>          * as quite a few PCI devices do not support smaller values.
>          */
> 
>         pci_cache_line_size = 32 >> 2;
>         if (c->x86 >= 6 && c->x86_vendor == X86_VENDOR_AMD)
>                 pci_cache_line_size = 64 >> 2;  /* K7 & K8 */
>         else if (c->x86 > 6 && c->x86_vendor == X86_VENDOR_INTEL)
>                 pci_cache_line_size = 128 >> 2; /* P4 */
> 
> A problem with cache coherency, alignment, or consistency would explain
> the problems I am seeing - and the differences in the test cases.
> 

Related speculations: 
http://forum.netbookuser.com/viewtopic.php?pid=6987#p6987

Mike

