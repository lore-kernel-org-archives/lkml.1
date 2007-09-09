Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbXIIUsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbXIIUsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758955AbXIIUsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:48:00 -0400
Received: from ozlabs.org ([203.10.76.45]:35599 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758878AbXIIUr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:47:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18148.13191.876031.378696@cargo.ozlabs.ibm.com>
Date: Mon, 10 Sep 2007 03:55:19 +1000
From: Paul Mackerras <paulus@samba.org>
To: Vitaly Mayatskikh <vmayatsk@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PPC64 AT_IGNOREPPC question
In-Reply-To: <m3odgehs9e.fsf@dhcp-lab-156.englab.brq.redhat.com>
References: <m3odgehs9e.fsf@dhcp-lab-156.englab.brq.redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh writes:

> include/asm-powerpc/elf.h:289
> 
> Why we need the second AT_IGNOREPPC entry here?
> 
> There is a mm_struct->saved_auxv overflow on PPC64 with AT_VECTOR_SIZE
> == 44 (may be on PPC32 too, not checked) when adding all entries to
> it. I've removed the second AT_IGNOREPCC from ARCH_DLINFO to prevent 
> overflowing, checked it on IBM OpenPower 720 and a system (Fedora 7) is 
> going on as well. Have I missed some tricky thing?

In the past, ppc32 kernels used to round up the address of the end of
the environment pointers to a multiple of 16 before writing the aux
vector, which meant that that was where userspace looked for it.  When
the rounding was removed in the kernel, we arranged to put in the two
AT_IGNOREPPC entries so that old binaries would still be able to find
the aux vector.

I'll have to check when that change was done and decide whether we can
now take out the AT_IGNOREPPC entries.  If not it sounds like we need
to expand AT_VECTOR_SIZE.

Paul.

