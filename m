Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbZJLQUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbZJLQUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbZJLQUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:20:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56007 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932763AbZJLQUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:20:49 -0400
Date: Mon, 12 Oct 2009 17:13:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <david.woodhouse@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.32-rc4: Reported regressions from 2.6.31
Message-ID: <20091012171328.159a480a@lxorguk.ukuu.org.uk>
In-Reply-To: <1255362962.32729.63.camel@macbook.infradead.org>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
	<alpine.LFD.2.01.0910111554400.3438@localhost.localdomain>
	<1255342738.24732.265.camel@macbook.infradead.org>
	<alpine.LFD.2.01.0910120725350.3438@localhost.localdomain>
	<1255362962.32729.63.camel@macbook.infradead.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That involves allocating a _shitload_ of page tables for a 1:1 mapping
> of all of physical memory. We used to do that to pander to broken
> graphics drivers, and the AMD guys asked me to stop because it was
> actually quite painful for them to do the same.

SMM isn't going to be touching high pages. In fact I wouldn't be the
least suprised if simply mapping the low 1MB including EBDA/ISA space and
the ACPI reserved areas worked simply because if it touches any other RAM
in SMM mode its going to be peeing over our memory spaces.

And if I remember rightly the magic SMM remapped memory area is quite
small (64K) and low down too plus not DMAable (because otherwise DMA in
the real OS to the pages SMM aliases over will go kersplat if an SMM
occurs)

Alan
