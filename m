Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbYCYQvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbYCYQvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYCYQuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:50:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51199 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbYCYQuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:50:54 -0400
Date: Tue, 25 Mar 2008 17:54:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, andreas.herrmann3@amd.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [6/7] Split large page mapping for AMD TSEG
Message-ID: <20080325165404.GS2170@one.firstfloor.org>
References: <20080312353.598285931@firstfloor.org> <20080312025332.B5DFC1B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0803251723300.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803251723300.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 05:44:21PM +0100, Thomas Gleixner wrote:
> On Wed, 12 Mar 2008, Andi Kleen wrote:
> > +
> > +	if (!direct_gbpages &&
> > +		c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
> > +		unsigned long tseg;
> 
> Can we do this at some place which is only called once ?

Nothing obvious. We could add it, but then would need to add a (imho ugly)
vendor check there first.

I think it is better to have the cpu specific code all in one place.

> 
> > +		/*
> > +		 * Split up direct mapping around the TSEG SMM area.
> > +		 * Don't do it for gbpages because there seems very little
> > +		 * benefit in doing so.
> > +		 */
> > +		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg) &&
> 
>  warning: passing argument 2 of 'rdmsrl_safe' from incompatible pointer type  

Yes the type has to be updated after the earlier inline change.
Easiest you just do the trivial change yourself.

-Andi

