Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXCNBNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXCNBNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 21:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbXCNBNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 21:13:00 -0400
Received: from ozlabs.org ([203.10.76.45]:33918 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXCNBM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 21:12:59 -0400
Subject: Re: _proxy_pda still makes linking modules fail
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <45F6C3E9.5020207@goop.org>
References: <1173315479.12472.9.camel@qrnik>
	 <p73lki39s3a.fsf@bingen.suse.de>	<45F49E0A.3090607@goop.org>
	 <20070312094805.GA11644@one.firstfloor.org>
	 <1173736726.10618.1.camel@localhost.localdomain>
	 <1173767032.10618.43.camel@localhost.localdomain>
	 <17910.26926.138067.731855@cargo.ozlabs.ibm.com>
	 <45F6C3E9.5020207@goop.org>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 12:12:49 +1100
Message-Id: <1173834769.5443.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 08:31 -0700, Jeremy Fitzhardinge wrote:
> Paul Mackerras wrote:
> > There is a fundamental problem with using __thread, which is that gcc
> > assumes that the addresses of __thread variables are constant within
> > one thread, and that therefore it can cache the result of address
> > calculations.  However, with preempt, threads in the kernel can't rely
> > on staying on one cpu, and therefore the addresses of per-cpu
> > variables can change.  There appears to be no way to tell gcc to drop
> > all cached __thread variable address calculations at a given point
> > (e.g. when enabling or disabling preemption).  That is basically why I
> > gave up on using __thread for per-cpu variables on powerpc.

[ Thanks for the enlightenment, Paul ]

> Doesn't that fall under the general class of "you have to be pinned to a
> particular cpu in order to meaningfully use per-cpu variables"?

No, it makes assumptions about the *address* of a per-cpu variable not
changing, even across barriers.

> In principle gcc could CSE the value of smp_processor_id() across a cpu
> change in the same way.

No, this is why preempt_enable and the like are memory barriers.
Rusty.


