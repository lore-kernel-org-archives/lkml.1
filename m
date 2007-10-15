Return-Path: <linux-kernel-owner+w=401wt.eu-S1762475AbXJOLHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762475AbXJOLHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758559AbXJOLHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:07:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56023 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbXJOLHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:07:38 -0400
Date: Mon, 15 Oct 2007 13:07:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs@oss.sgi.com,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?iso-8859-1?B?QsO4Z2Vza292?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071015110735.GA11748@one.firstfloor.org>
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <p731wbw4t3h.fsf@bingen.suse.de> <200710160056.47458.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710160056.47458.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 12:56:46AM +1000, Nick Piggin wrote:
> Is this true even if you don't write through those old mappings?

I think it happened for reads too.  It is a little counter intuitive
because in theory the CPU doesn't need to write back non dirty lines,
but in the one case which took so long to debug exactly this happened
somehow.

At it is undefined for reads and writes in the architecture so 
better be safe than sorry.

And x86 CPUs are out of order and do speculative executation
and that can lead to arbitary memory accesses even if the code
never touches an particular address.

Newer Intel CPUs have something called self-snoop which was supposed
to handle this; but in some situations it doesn't seem to catch it
either.

> Is DRM or AGP then not also broken with lazy highmem flushing, or
> how do they solve that?

AGP doesn't allocate highmem pages.  Not sure about the DRM code.

-Andi
