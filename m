Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbZBLIhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbZBLIhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 03:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZBLIhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 03:37:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:45885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbZBLIhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 03:37:09 -0500
Subject: Re: [PATCH] Don't override CONFIG_64BIT for ARCH={i386,x86_64}
 builds
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090212072644.GA10253@elte.hu>
References: <1234372298.3586.23.camel@macbook.infradead.org>
	 <20090211172258.GE13239@elte.hu>  <20090212072644.GA10253@elte.hu>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 08:36:59 +0000
Message-Id: <1234427819.3586.142.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 08:26 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > It is a steaming great pain in the arse when the value of CONFIG_64BIT
> > > explicitly written in my .config file is overridden by the value of
> > > $ARCH inferred from the environment.
> > > 
> > > If I have a 32-bit .config and I happen to build it without remembering
> > > to put 'ARCH=i386' on the make command line, it shouldn't force
> > > CONFIG_64BIT=y and reconfigure.
> > > 
> > > This patch should fix that, while still allowing defconfig to work as it
> > > currently does for both 32-bit and 64-bit environments, and still giving
> > > the default value of CONFIG_64BIT according to $ARCH. It's just that it
> > > won't _force_ a change to CONFIG_64BIT when it's set to something other
> > > than what $ARCH would imply.
> > > 
> > > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> > 
> > Applied to tip:x86/ugent, thanks David!
> 
> i removed it again, because it regresses randconfig behavior:

Ew, that's a nasty thing to be prioritising over day-to-day usability,
and the fact that I can't just do 'make bzImage' without it screwing up
and asking me to reconfigure.

Isn't there a CONFIG_RANDCONFIG option? We could make it
   bool "64-bit kernel" if !CONFIG_RANDCONFIG

Alternatively, we could just the top-level Makefile set ARCH=x86 when
it's inferred from the environment, and let people override it to i386
or x86_64 if they want to.

-- 
dwmw2

