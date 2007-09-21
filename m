Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbXIUNbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbXIUNbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758142AbXIUNa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:30:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758171AbXIUNa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:30:58 -0400
Date: Fri, 21 Sep 2007 09:30:07 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, dsmith@redhat.com,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070921133006.GF8964@redhat.com>
References: <20070918211324.161373216@polymtl.ca> <20070919113737.GA18177@Krystal> <y0mtzpqvk1l.fsf@ton.toronto.redhat.com> <200709192132.00873.vda.linux@googlemail.com> <20070921125819.GA13129@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921125819.GA13129@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Sep 21, 2007 at 08:58:19AM -0400, Mathieu Desnoyers wrote:
> [...]
> > > Current systemtap marker support code relies on the __markers_strings
> > > section.
> > Let users know that in comment above section definition in ld script.
> [...]
>         /* Markers: strings (used by SystemTAP) */                      \
> [...]

I did not mean to imply that this was a necessary state of affairs.

The marker metadata must be stored in at least one place in the kernel
image - this just happens to be a convenient one that David Smith's
recent systemtap code used.  Without it, we'd probably have to do a
more complicated search, following the pointers within the __markers
structs.  That could work, but it hasn't been built/tested.

So, this proposed change (removal of this section) would break
systemtap, and we have to jump through more hoops to make it work
again.  Is the change worth it?

- FChE
