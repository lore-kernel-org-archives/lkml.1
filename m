Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYFLCi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYFLCi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 22:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYFLCiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 22:38:17 -0400
Received: from ozlabs.org ([203.10.76.45]:52434 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbYFLCiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 22:38:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] modules: Take a shortcut for checking if an address is in a module
Date: Thu, 12 Jun 2008 10:20:58 +1000
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20080610130519.21bc66f3@infradead.org> <200806112112.08623.rusty@rustcorp.com.au> <20080611081847.0b22079c@infradead.org>
In-Reply-To: <20080611081847.0b22079c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121020.58881.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 01:18:47 Arjan van de Ven wrote:
> On Wed, 11 Jun 2008 21:12:08 +1000
>
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Wednesday 11 June 2008 06:05:19 Arjan van de Ven wrote:
> > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > Subject: [PATCH] modules: Take a shortcut for checking if an
> > > address is in a module
> > >
> > > Various pieces of the kernel (lockdep, latencytop, etc) tend to
> > > store backtraces, sometimes at a relatively high frequency. In
> > > itself this isn't a big performance deal (after all you're using
> > > diagnostics features), but there have been some complaints from
> > > people who have over 100 modules loaded that this is a tad too slow.
> >
> > Nothing wrong with the idea, but how about a nice
> > arch_maybe_module_addr() macro rather than ifdefs in module.c?
>
> Everytime someone says that, I go crawl under my desk and weep quietly
> for 10 minutes.
>
> Yes ifdefs aren't nice. However, arch_foo_bar_baz() is equally bad, it
> just moves the uglyness around a little. It's like multiplying the dirt
> by three and then sweeping it under 3 different carpets. Sure in your
> area the room looks clean, but the total amount of crap didn't decrease.
>
> The only half-way sane way to do arch_has_foo is using weak functions,
> but unfortunately that runs into gcc issues to the point of not being
> usable without a great amount of care... the alternatives are both
> unpleasant and overkill. We really should try to keep the arch stuff as
> small as possible; a gazillion arch_foo_bar()'s is the opposite
> direction there ;(

OK, then how about something like this in linux/module.h:

#ifndef MODULE_ADDR_MIN
#define MODULE_ADDR_MIN OUL
#endif
#ifndef MODULE_ADDR_MAX
#define MODULE_ADDR_MAX -1UL
#endif

Or, we could actually make those as variables and update them in module.c 
itself.  No arch changes required, and pretty easy to understand.

Cheers,
Rusty.
