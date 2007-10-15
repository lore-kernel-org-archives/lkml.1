Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbXJOXRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbXJOXRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbXJOXRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:17:23 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:53875 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbXJOXRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:17:22 -0400
Date: Mon, 15 Oct 2007 19:12:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, systemtap@sources.redhat.com,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20071015231209.GA18994@Krystal>
References: <20070918211324.161373216@polymtl.ca> <20070919113737.GA18177@Krystal> <y0mtzpqvk1l.fsf@ton.toronto.redhat.com> <200709192132.00873.vda.linux@googlemail.com> <20070921125819.GA13129@Krystal> <20070921133006.GF8964@redhat.com> <20070921133820.GD13129@Krystal> <20071015194120.GA22562@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071015194120.GA22562@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:08:19 up 77 days, 23:27,  3 users,  load average: 1.47, 1.03, 0.97
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi -
> 
> I wrote:
> 
> > [...]
> > > The marker metadata must be stored in at least one place in the kernel
> > > image - this just happens to be a convenient one that David Smith's
> > > recent systemtap code used.  Without it, we'd probably have to do a
> > > more complicated search, following the pointers within the __markers
> > > structs.  [...]
> 
> Our team is farther along adapting to this change against 2.6.23-mm1,
> and we have run into a complication.  It's more of a distribution
> issue.
> 
> We would prefer to retain systemtap's capability to build
> instrumentation for a kernel other than the currently running one.
> Such instrumentation can be then copied and run on a distinct machine.
> This has meant relying on development data: make install_headers +
> Makefiles (as packaged by Fedora/RHEL), and to a lesser extent
> separated debugging information.
> 
> Markers are attractive partly because they don't require debugging
> information, so the data needs to be found in an executable image.
> But we prefer not to force the executable image itself to be
> installed, for example because /boot is relatively small.  So we would
> prefer something in between: something small that we can put into the
> development package.
> 
> If there exists sympathy to this problem, Roland McGrath supposes we
> could implement a standardized solution, a file like Module.symvers,
> containing the marker names & format strings extracted at build time.
> Any opinions?
> 

Hi Frank,

I think the main issue with the solution you propose is that it doesn't
deal with markers in modules, am I right ?

I will soon come with a marker iterator and a module that provides a
userspace -and in kernel- interface to enable/disable markers. Actually,
I already have the code ready in my LTTng snapshots. I can provide a
link if you want to have a look.

> 
> PS. I wonder why the marker name/format strings are put into a
> __markers_strings object section at all, considering that the only
> place where that is used again appears to be this code in
> kernel/module.c:
> 
>         markersstringsindex = find_sec(hdr, sechdrs, secstrings,
>                                         "__markers_strings");
> 
> and the "markersstringsindex" variable is never used.
> 

Considering that  I want to minimize the impact on the system, I put the
marker strings in their own memory location rather than clobbering the
memory containing the kernel strings (which will likely be used more
often than markers). It makes sure that I don't pollute cachelines
otherwise containing useful kernel strings.

Mathieu

> 
> - FChE

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
