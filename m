Return-Path: <linux-kernel-owner+w=401wt.eu-S933781AbXCNCRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781AbXCNCRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 22:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933801AbXCNCRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 22:17:06 -0400
Received: from ozlabs.org ([203.10.76.45]:38019 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933796AbXCNCRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 22:17:05 -0400
Subject: Re: _proxy_pda still makes linking modules fail
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070313155747.GA11162@one.firstfloor.org>
References: <1173315479.12472.9.camel@qrnik>
	 <p73lki39s3a.fsf@bingen.suse.de> <45F49E0A.3090607@goop.org>
	 <20070312094805.GA11644@one.firstfloor.org>
	 <1173736726.10618.1.camel@localhost.localdomain>
	 <1173767032.10618.43.camel@localhost.localdomain>
	 <20070313155747.GA11162@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 13:17:03 +1100
Message-Id: <1173838623.5443.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 16:57 +0100, Andi Kleen wrote:
> On Tue, Mar 13, 2007 at 05:23:52PM +1100, Rusty Russell wrote:
> > In particular, it's been put in GCC 4.1 for
> > CONFIG_CC_STACKPROTECTOR, which assumes %gs:40 will give the stack
> > canary.
> 
> Yes that was always ugly, but I don't know a better way.

Well, "%gs:__gcc_stack_protector" would have been better.  We could have
defined __gcc_stack_protector as an absolute symbol (0x40) at the
moment, and made it a real per-cpu var later.

> > For the record: the PDA should never have existed, that's what percpu
> > vars were supposed to be for.  Something went wrong here 8(
> 
> PDA predates per cpu.

Indeed, but I should have converted it over back in 2003 (?) when the
per-cpu stuff went in 8(

> > The ideal solution has always been to use __thread, but no architecture
> > has yet managed it (I tried for i386, and it quickly caused unbearable
> 
> I tried it too, but __thread is hopeless for kernel code
> 
> > pain).  On x86-64 that uses "%fs" on x86-64, not "%gs" as the kernel
> > does, but I might try that if I feel particularly masochistic soon...
> 
> Then swapgs wouldn't work anymore (there is no swapfs)

Good point.

Thanks,
Rusty.

