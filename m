Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYBPOa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYBPOa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 09:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYBPOat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 09:30:49 -0500
Received: from www.tglx.de ([62.245.132.106]:38748 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbYBPOas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 09:30:48 -0500
Date: Sat, 16 Feb 2008 15:29:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       buytenh@wantstofly.org, mingo@elte.hu, riku.voipio@movial.fi,
       stable@kernel.org, schwidefsky@de.ibm.com
Subject: Re: + futex-runtime-enable-pi-and-robust-functionality.patch added
 to -mm tree
In-Reply-To: <20080216140444.GC4900@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.1.00.0802161525530.7583@apollo.tec.linutronix.de>
References: <200802150149.m1F1n8Gx013909@imap1.linux-foundation.org> <20080216124248.GA4900@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0802161346350.7583@apollo.tec.linutronix.de> <20080216134155.GB4900@osiris.boeblingen.de.ibm.com>
 <alpine.LFD.1.00.0802161444510.7583@apollo.tec.linutronix.de> <20080216140444.GC4900@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008, Heiko Carstens wrote:

> On Sat, Feb 16, 2008 at 02:48:17PM +0100, Thomas Gleixner wrote:
> > On Sat, 16 Feb 2008, Heiko Carstens wrote:
> > 
> > > > Well, NULL pointer dereferencing is supposed to fail, isn't it ?
> > >
> > > I wasn't sure that this is true for all architectures, but...
> > 
> > It's an requirement for futex support.
> 
> To be more precise: dereferencing alone won't cause an exception for
> NULL pointers on s390. Only writes will do so.
> That is very architecture specific since we cannot unmap page 0,
> it contains per-cpu data -- like exception pointers and all such stuff
> that the cpu needs.
> Just in case there is any code that relies on the fact that also reads
> via a NULL pointer are supposed to failed.

Hmm, not sure whether there is such code, but then it would be not too bad
to add

   if (!p)
      return -EFAULT;

to the S390 implementations which only read data and have an exception
fixup.

Thanks,

	tglx
