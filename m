Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYFJNdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYFJNdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 09:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbYFJNc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 09:32:57 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62241 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752989AbYFJNc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 09:32:56 -0400
Date: Tue, 10 Jun 2008 14:30:47 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Glauber Costa <gcosta@redhat.com>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
In-Reply-To: <484E7B03.8000604@redhat.com>
Message-ID: <Pine.LNX.4.55.0806101418510.1702@cliff.in.clinika.pl>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com> 
 <1213021018-14159-10-git-send-email-gcosta@redhat.com> 
 <1213021018-14159-11-git-send-email-gcosta@redhat.com> 
 <1213021018-14159-12-git-send-email-gcosta@redhat.com> 
 <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl>  <484D8813.4040807@redhat.com>
  <Pine.LNX.4.55.0806092058550.26593@cliff.in.clinika.pl> 
 <86802c440806091353m240ab7adocbaf5dacd15504f7@mail.gmail.com> 
 <Pine.LNX.4.55.0806092159350.26593@cliff.in.clinika.pl> 
 <Pine.LNX.4.55.0806100341520.31588@cliff.in.clinika.pl>
 <86802c440806092208s338cf6b6q892f5149bbd142ca@mail.gmail.com>
 <484E7B03.8000604@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Glauber Costa wrote:

> >>  Then again -- what if X86_LOCAL_APIC is set, but X86_IO_APIC is not?
> > 
> > config X86_LOCAL_APIC
> >         def_bool y
> >         depends on X86_64 || (X86_32 && (X86_UP_APIC || ((X86_VISWS ||
> > SMP) && !X86_VOYAGER) || X86_GENERICARCH))
> > 
> > config X86_IO_APIC
> >         def_bool y
> >         depends on X86_64 || (X86_32 && (X86_UP_IOAPIC || (SMP &&
> > !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH))
> > 
> > for 64bit, those are all set.
> > 
> > for 32bit, may need to null stub if X86_IO_APIC is not set
> > 
> > YH
> Fair Enough.

 That does not answer the question what to do with a 32-bit kernel run on
a system that requires the fixup in the 64-bit mode.  Papering over such
firmware bugs in the kernel encourages hardware vendors to maintain the
breakage.

 Note that the I/O APIC comes out of reset with all the redirection
entries masked out, so if any error conditions are triggered before Linux
configures the chip, they are a result of a deliberate misprogramming done
to the chip by the firmware.

 Does anyone have a reference to the original problem report which lead to
this workaround having been put in place?

  Maciej
