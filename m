Return-Path: <linux-kernel-owner+w=401wt.eu-S1946670AbXD3TTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946670AbXD3TTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946708AbXD3TTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:19:33 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43514 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946670AbXD3TTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:19:32 -0400
Date: Mon, 30 Apr 2007 20:20:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [4/6] go BUG on vmallocspace in __pa() (was: Re: [-mm patch]
 i386: enable 4k stacks by default)
Message-ID: <20070430202059.4db688d3@the-village.bc.nu>
In-Reply-To: <20070430185242.GB11512@one.firstfloor.org>
References: <20070428191927.GN3468@stusta.de>
	<1177795118.7828.6.camel@localhost>
	<20070430035838.GC77450368@melbourne.sgi.com>
	<20070430091754.24df88df@the-village.bc.nu>
	<p73wszuyx7h.fsf@bingen.suse.de>
	<20070430104806.GA14944@infradead.org>
	<p73slaiys9v.fsf@bingen.suse.de>
	<20070430173819.GC19966@holomorphy.com>
	<20070430174510.GG19966@holomorphy.com>
	<20070430185242.GB11512@one.firstfloor.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 20:52:42 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> On Mon, Apr 30, 2007 at 10:45:10AM -0700, William Lee Irwin III wrote:
> > On Mon, Apr 30, 2007 at 10:38:19AM -0700, William Lee Irwin III wrote:
> > > Here's what I did for i386 for someone concerned about blowing the stack.
> > 
> > Add checks to __pa() so it goes BUG() on vmallocspace addresses.
> 
> Sorry I think that's too costly to do. __pa is pretty common

But not too costly to do if it is done solely with vmalloc the stack for
debug purposes. The bigger problem with the vmalloc approach is there are
still offenders who DMA off the kernel stack on i386 although I'd hope
they are all ancient... we'll find out with this anyway
