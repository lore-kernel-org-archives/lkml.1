Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbYC0DuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbYC0DuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 23:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbYC0DuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 23:50:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:47618 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797AbYC0DuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 23:50:00 -0400
Subject: Re: + futex-runtime-enable-pi-and-robust-functionality.patch added
	to -mm tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, buytenh@wantstofly.org, mingo@elte.hu,
       riku.voipio@movial.fi, stable@kernel.org, schwidefsky@de.ibm.com
In-Reply-To: <1206588739.6926.79.camel@pasglop>
References: <200802150149.m1F1n8Gx013909@imap1.linux-foundation.org>
	 <20080216124248.GA4900@osiris.boeblingen.de.ibm.com>
	 <alpine.LFD.1.00.0802161346350.7583@apollo.tec.linutronix.de>
	 <20080216134155.GB4900@osiris.boeblingen.de.ibm.com>
	 <alpine.LFD.1.00.0802161444510.7583@apollo.tec.linutronix.de>
	 <20080216140444.GC4900@osiris.boeblingen.de.ibm.com>
	 <alpine.LFD.1.00.0802161525530.7583@apollo.tec.linutronix.de>
	 <1206588739.6926.79.camel@pasglop>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 14:48:39 +1100
Message-Id: <1206589719.6926.81.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-27 at 14:32 +1100, Benjamin Herrenschmidt wrote:
> > Hmm, not sure whether there is such code, but then it would be not too bad
> > to add
> > 
> >    if (!p)
> >       return -EFAULT;
> > 
> > to the S390 implementations which only read data and have an exception
> > fixup.
> 
> I have a different problem on some embedded powerpc's where the TLB miss
> code isn't checking for the cached pgdir pointer being NULL (which
> happens because we are early at boot and haven't activated an mm). So we
> end up either taking recursive faults or going into lalaland walking
> the page tables.
> 
> It happens on some unreleased code, I'll verify if it happens on
> 8xx/4xx/etc... in a minute, and will cook a patch if it does.

Ok, so everything released seems to be fine. It will use swapper_pg_dir
which on 32 bits will do the right thing. Pfiew ! So only some stuff I'm
still working on breaks, I'll fix it.

Cheers,
Ben.


