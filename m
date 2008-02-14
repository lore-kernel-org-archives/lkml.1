Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbYBNUnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbYBNUnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYBNUmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:42:49 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:44184 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbYBNUms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:42:48 -0500
Date: Thu, 14 Feb 2008 21:42:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samples: build fix
Message-ID: <20080214204254.GC21894@uranus.ravnborg.org>
References: <20080214034541.EF1BD270192@magilla.localdomain> <20080214132752.GA27478@Krystal> <20080214194633.GA21894@uranus.ravnborg.org> <20080214200257.42815270195@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214200257.42815270195@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 12:02:57PM -0800, Roland McGrath wrote:
> I don't have any axe to grind here, I just could not figure out how to get
> the samples/ modules built (without resorting to make M=.../samples/foo and
> clobbering my source directory).

> If there is another plan, point me to its documentation.  

I just double checked and the usual:
make O=output samples/

It works as expected and build all the samples.
It is documented by make help like this:
$ make help
  ...
  dir/            - Build all files in dir and below


The above is generic functionality and I do not see any
need for a special target to build the samples.

> I can't see the point of the Kconfig option for samples at all.
> What does it do?
The samples were added so we avoided them to bit-rot.
We do not want to build samples unconditionally - that should be pretty
obvious.
So maybe I did not get what you actually was asking?

> Because they are only ever modules, the samples are never built in.
There is _nothing_ preventing us from adding stuff tomorrow that has
be build as built-in. Some sample code documenting early cpu init
stuff for instance. And we do not want this code to clash with
other kernel code if global symbols are duplicated.

This thinking that samples are solely modules are wrong. It is correct that
most of it is expected to be modules but not all of it.

I only found one little glitch.
$ make modules
does not build the samples.

	Sam
