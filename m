Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYJQNJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYJQNJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbYJQNJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:09:08 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44179 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbYJQNJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:09:06 -0400
Date: Fri, 17 Oct 2008 09:09:01 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ibm_newemac: Fix new MAL feature handling
Message-ID: <20081017090901.637c1ea5@zod.rchland.ibm.com>
In-Reply-To: <200810171456.53599.arnd@arndb.de>
References: <20081015213337.a99a9595.akpm@linux-foundation.org>
	<1224133010.8157.543.camel@pasglop>
	<20081016143840.GA29805@yoda.jdub.homelinux.org>
	<200810171456.53599.arnd@arndb.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 14:56:52 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Thursday 16 October 2008, Josh Boyer wrote:
> > +#ifdef CONFIG_PPC_DCR_NATIVE
> >         if (mal_has_feature(mal, MAL_FTR_CLEAR_ICINTSTAT))
> >                 mtdcri(SDR0, DCRN_SDR_ICINTSTAT,
> >                                 (mfdcri(SDR0, DCRN_SDR_ICINTSTAT) | ICINTSTAT_ICTX));
> > +#endif
> >  
> 
> So what if you have a mmio based DRC implementation and still want to use
> this feature?

You have to have hardware that does that.  When it exists, we can
probably worry about it.  Hopefully that will never happen.  (Axon is
an abomination that should not be repeated.)

> I guess you really should use dcr_read/dcr_write here instead of mtdcr/mfdcr.

We can look at that.  It's not going to be high on my TODO list at the
moment though.  (hint, there are other places that do the same thing
here and they should all be cleaned up if we're going to bother.)

josh
