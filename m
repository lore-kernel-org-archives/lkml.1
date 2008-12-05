Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYLEL6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYLEL6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 06:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYLEL6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 06:58:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35435 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYLEL6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 06:58:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200812051855.07203.rusty@rustcorp.com.au>
References: <200812051855.07203.rusty@rustcorp.com.au> <20081203163207.13965.56517.stgit@warthog.procyon.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] param: Adapt MN10300 to the new parameter handling regime
Date: Fri, 05 Dec 2008 11:58:16 +0000
Message-ID: <2204.1228478296@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rusty Russell <rusty@rustcorp.com.au> wrote:

>    Maybe we should add a new param type to the general code so this can be
> done with core_param.  See below. Not sure if it's a win tho (many archs want
> mem=num@pos, x86 wants mem=nopentium, etc).

I tried applying your patch, and then I added:

	#include <linux/moduleparam.h>

and put this into my code in place of what I had:

	static unsigned long mem_override;
	core_param(mem, mem_override, mem, 0444);

I get the following error, however:

  CC      arch/mn10300/kernel/setup.o
arch/mn10300/kernel/setup.c:86: error: 'param_mem_keeps_reference' undeclared here (not in a function)

I think you're missing:

	#define param_mem_keeps_reference 0

from the stuff you added.

With that, the core_param stuff does work for mem=...  But I object to
mem_override not being __initdata.  I also don't think the parameter should
appear in sysfs - that's just a waste of resources.  It should, perhaps,
appear in /proc/cmdline, but for some reason it does not.  I can live without
that, though, since its effect appears in /proc/meminfo.

Also, something else to consider: If CONFIG_MODULES=n and CONFIG_SYSFS=n,
should the contents of kernel/params.c be discarded along with the __init
sections?

David
