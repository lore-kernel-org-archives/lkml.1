Return-Path: <linux-kernel-owner+w=401wt.eu-S934936AbXHGPdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934936AbXHGPdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 11:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbXHGPdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 11:33:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35183 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbXHGPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 11:33:37 -0400
Date: Tue, 7 Aug 2007 17:33:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       =?iso-8859-1?Q?C=E9dric?= Augonnet <cedric.augonnet@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PAT support for i386 and x86_64
Message-ID: <20070807153335.GA1958@one.firstfloor.org>
References: <6278d2220708070534t7096e579uef2ddbb2c997daa6@mail.gmail.com> <20070807141042.GB952@one.firstfloor.org> <6278d2220708070826h2613dd7dr6e3b8001fba3441a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220708070826h2613dd7dr6e3b8001fba3441a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 04:26:06PM +0100, Daniel J Blueman wrote:
> (Intel IA32 ASDM 3A 10-47) "a WC page must never be aliased to a
> cacheable page because WC writes may not check the processor caches."

Yes that is what we're trying to avoid, but it is far more complicated
than you think.

> This is not talking about corrupting the cache generally, but data
> hitting a PCI target twice by (ie) a broken driver.

This can end up with data corruption, machine checks or 
a broken device. All happened.

> > > barrier will hamper progress we do see, as it has done already for
> > > years.
> >
> > Because it's not simple and nobody has done it properly yet.
> 
> Providing only UC and WC types and documenting aliasing problems is
> what is required here.

At least the direct mapping needs to be changed too and any mapping
comming from other sources (/sys/bus/pci, /dev/mem etc.) 
Otherwise you get the dangerous illegal aliases.

The chances of a driver getting this right even when documented
are very small.

BTW i had some prototype patches to address some of this,
but they need much more work to handle all this properly.
Just reprogramming the PAT registers is really the smallest issue.
The IA64 port has done some of the work as an example, unfortunately they
use a strange memory mapping scheme that cannot be easily moved
over. iirc Bjorn identified over 10 potential sources of cache aliases
that all needed to be addressed in the end.

-Andi

