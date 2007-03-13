Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbXCMP5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbXCMP5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbXCMP5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:57:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34228 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbXCMP5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:57:50 -0400
Date: Tue, 13 Mar 2007 16:57:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: _proxy_pda still makes linking modules fail
Message-ID: <20070313155747.GA11162@one.firstfloor.org>
References: <1173315479.12472.9.camel@qrnik> <p73lki39s3a.fsf@bingen.suse.de> <45F49E0A.3090607@goop.org> <20070312094805.GA11644@one.firstfloor.org> <1173736726.10618.1.camel@localhost.localdomain> <1173767032.10618.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173767032.10618.43.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 05:23:52PM +1100, Rusty Russell wrote:
> On Tue, 2007-03-13 at 08:59 +1100, Rusty Russell wrote:
> > On Mon, 2007-03-12 at 10:48 +0100, Andi Kleen wrote:
> > > > Rusty's pda->per_cpu patch will deal with this once and for all; have
> > > 
> > > Not on x86-64.
> > 
> > Indeed.  Perhaps it's time I join the modern world and compile a 64-bit
> > kernel...
> > 
> > Will prepare patches,
> 
> No, I don't think I will.  The PDA concept has gone too far in x86-64 to
> be undone.  In particular, it's been put in GCC 4.1 for
> CONFIG_CC_STACKPROTECTOR, which assumes %gs:40 will give the stack
> canary.

Yes that was always ugly, but I don't know a better way.

> For the record: the PDA should never have existed, that's what percpu
> vars were supposed to be for.  Something went wrong here 8(

PDA predates per cpu.

> The ideal solution has always been to use __thread, but no architecture
> has yet managed it (I tried for i386, and it quickly caused unbearable

I tried it too, but __thread is hopeless for kernel code

> pain).  On x86-64 that uses "%fs" on x86-64, not "%gs" as the kernel
> does, but I might try that if I feel particularly masochistic soon...

Then swapgs wouldn't work anymore (there is no swapfs)

-Andi
> 
