Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbZJOPvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbZJOPvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758073AbZJOPvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:51:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40352 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860AbZJOPvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:51:23 -0400
Date: Thu, 15 Oct 2009 17:50:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Remove or convert empty ioctls ?
Message-ID: <20091015155023.GB11408@elte.hu>
References: <alpine.LFD.2.00.0910151113340.9428@localhost.localdomain> <4AD711BC.2030409@garzik.org> <20091015160109.6d9353e8@lxorguk.ukuu.org.uk> <4AD73E40.1010501@garzik.org> <20091015163103.5e42fabe@lxorguk.ukuu.org.uk> <4AD74151.7020306@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD74151.7020306@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> On 10/15/2009 11:31 AM, Alan Cox wrote:
>> EINVAL means you used an ioctl that is correct for the driver but that
>> for some reason the driver didn't like it.
>
> Precisely.
>
> The driver author proactively chose to implement the ioctl and return 
> a value other than ENOTTY.
>
> It is invalid to assume that all such cases are a direct result of 
> author mistakes or ignorance.

If 10% of the cases the error return was for a reason it's still worth 
doing this. If it matters we'll hear about it.

Something that looks like crap should not get extra protection to stay 
in the kernel just because it 'might' be non-crap. If it's not clearly 
documented in the source to be -EINVAL for a good reason (and frankly i 
cannot think of any) then i'd suggest to do what Alan has been doing for 
years: just change it and see if it causes any problems.

It's not like it's hard to revert such a change. (and we'll also add a 
comment explaining the reason for the -EINVAL in that case.)

	Ingo
