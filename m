Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbYC0DeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbYC0DeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 23:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbYC0Ddw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 23:33:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:51058 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbYC0Ddv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 23:33:51 -0400
Subject: Re: + futex-runtime-enable-pi-and-robust-functionality.patch added
	to -mm tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, buytenh@wantstofly.org, mingo@elte.hu,
       riku.voipio@movial.fi, stable@kernel.org, schwidefsky@de.ibm.com
In-Reply-To: <alpine.LFD.1.00.0802161525530.7583@apollo.tec.linutronix.de>
References: <200802150149.m1F1n8Gx013909@imap1.linux-foundation.org>
	 <20080216124248.GA4900@osiris.boeblingen.de.ibm.com>
	 <alpine.LFD.1.00.0802161346350.7583@apollo.tec.linutronix.de>
	 <20080216134155.GB4900@osiris.boeblingen.de.ibm.com>
	 <alpine.LFD.1.00.0802161444510.7583@apollo.tec.linutronix.de>
	 <20080216140444.GC4900@osiris.boeblingen.de.ibm.com>
	 <alpine.LFD.1.00.0802161525530.7583@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 14:32:19 +1100
Message-Id: <1206588739.6926.79.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hmm, not sure whether there is such code, but then it would be not too bad
> to add
> 
>    if (!p)
>       return -EFAULT;
> 
> to the S390 implementations which only read data and have an exception
> fixup.

I have a different problem on some embedded powerpc's where the TLB miss
code isn't checking for the cached pgdir pointer being NULL (which
happens because we are early at boot and haven't activated an mm). So we
end up either taking recursive faults or going into lalaland walking
the page tables.

It happens on some unreleased code, I'll verify if it happens on
8xx/4xx/etc... in a minute, and will cook a patch if it does.

Cheers,
Ben.

