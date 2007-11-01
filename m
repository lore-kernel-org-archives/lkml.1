Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbXKAFXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbXKAFXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 01:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXKAFXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 01:23:38 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58281 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbXKAFXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 01:23:37 -0400
Date: Thu, 1 Nov 2007 06:25:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH/RFC] x86: unify Kconfig files
Message-ID: <20071101052513.GB31445@uranus.ravnborg.org>
References: <20071031215501.GA28556@uranus.ravnborg.org> <47295123.9010603@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47295123.9010603@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 09:08:03PM -0700, Jeremy Fitzhardinge wrote:
> Sam Ravnborg wrote:
> > It has been requested that we should let x86 behave like
> > other architectures so we at config time decide for 32 or 64 bit.
> > The challenge here is to mere the Kconfig files and I have done
> > an attempt to do so.
> >
> > +source "mm/Kconfig"
> >  
> > -config X86_VISWS_APIC
> > +config HIGHPTE
> > +	bool "Allocate 3rd-level pagetables from highmem"
> > +	depends on X86_32 && HIGHMEM4G || HIGHMEM64G
> >   
> 
> Some parens: X86_32 && (HIGHMEM4G || HIGHMEM64G)?

Yes - thanks.

This particular X86_32 dependency is for documentation only since
HIGHMEM4G and HIGHMEM64G is a X86_32 thing only.
But depite this is should be correct.
I will audit the other dependencies for the same bug.

	Sam
