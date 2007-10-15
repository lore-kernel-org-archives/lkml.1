Return-Path: <linux-kernel-owner+w=401wt.eu-S934485AbXJOUOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485AbXJOUOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933030AbXJOUNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:13:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932793AbXJOUNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:13:52 -0400
Date: Mon, 15 Oct 2007 15:41:20 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, systemtap@sources.redhat.com,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20071015194120.GA22562@redhat.com>
References: <20070918211324.161373216@polymtl.ca> <20070919113737.GA18177@Krystal> <y0mtzpqvk1l.fsf@ton.toronto.redhat.com> <200709192132.00873.vda.linux@googlemail.com> <20070921125819.GA13129@Krystal> <20070921133006.GF8964@redhat.com> <20070921133820.GD13129@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921133820.GD13129@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

I wrote:

> [...]
> > The marker metadata must be stored in at least one place in the kernel
> > image - this just happens to be a convenient one that David Smith's
> > recent systemtap code used.  Without it, we'd probably have to do a
> > more complicated search, following the pointers within the __markers
> > structs.  [...]

Our team is farther along adapting to this change against 2.6.23-mm1,
and we have run into a complication.  It's more of a distribution
issue.

We would prefer to retain systemtap's capability to build
instrumentation for a kernel other than the currently running one.
Such instrumentation can be then copied and run on a distinct machine.
This has meant relying on development data: make install_headers +
Makefiles (as packaged by Fedora/RHEL), and to a lesser extent
separated debugging information.

Markers are attractive partly because they don't require debugging
information, so the data needs to be found in an executable image.
But we prefer not to force the executable image itself to be
installed, for example because /boot is relatively small.  So we would
prefer something in between: something small that we can put into the
development package.

If there exists sympathy to this problem, Roland McGrath supposes we
could implement a standardized solution, a file like Module.symvers,
containing the marker names & format strings extracted at build time.
Any opinions?


PS. I wonder why the marker name/format strings are put into a
__markers_strings object section at all, considering that the only
place where that is used again appears to be this code in
kernel/module.c:

        markersstringsindex = find_sec(hdr, sechdrs, secstrings,
                                        "__markers_strings");

and the "markersstringsindex" variable is never used.


- FChE
