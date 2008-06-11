Return-Path: <linux-kernel-owner+w=401wt.eu-S1761098AbYFKPTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098AbYFKPTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYFKPSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:18:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:33649 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbYFKPSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:18:53 -0400
Date: Wed, 11 Jun 2008 08:18:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] modules: Take a shortcut for checking if an address is
 in a module
Message-ID: <20080611081847.0b22079c@infradead.org>
In-Reply-To: <200806112112.08623.rusty@rustcorp.com.au>
References: <20080610130519.21bc66f3@infradead.org>
	<200806112112.08623.rusty@rustcorp.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 21:12:08 +1000
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wednesday 11 June 2008 06:05:19 Arjan van de Ven wrote:
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Subject: [PATCH] modules: Take a shortcut for checking if an
> > address is in a module
> >
> > Various pieces of the kernel (lockdep, latencytop, etc) tend to
> > store backtraces, sometimes at a relatively high frequency. In
> > itself this isn't a big performance deal (after all you're using
> > diagnostics features), but there have been some complaints from
> > people who have over 100 modules loaded that this is a tad too slow.
> 
> Nothing wrong with the idea, but how about a nice
> arch_maybe_module_addr() macro rather than ifdefs in module.c?

Everytime someone says that, I go crawl under my desk and weep quietly
for 10 minutes.

Yes ifdefs aren't nice. However, arch_foo_bar_baz() is equally bad, it
just moves the uglyness around a little. It's like multiplying the dirt
by three and then sweeping it under 3 different carpets. Sure in your
area the room looks clean, but the total amount of crap didn't decrease.

The only half-way sane way to do arch_has_foo is using weak functions,
but unfortunately that runs into gcc issues to the point of not being
usable without a great amount of care... the alternatives are both
unpleasant and overkill. We really should try to keep the arch stuff as
small as possible; a gazillion arch_foo_bar()'s is the opposite
direction there ;(


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
