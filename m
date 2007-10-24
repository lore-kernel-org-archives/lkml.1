Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbXJXMrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbXJXMrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbXJXMrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:47:13 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:51040 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbXJXMrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:47:12 -0400
Date: Wed, 24 Oct 2007 08:44:24 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Adrian Bunk <bunk@kernel.org>
cc: Jens Axboe <jens.axboe@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] Fix asm-avr32/dma-mapping.h breakage
In-Reply-To: <20071024124123.GD30533@stusta.de>
Message-ID: <Pine.LNX.4.64.0710240840390.1257@localhost.localdomain>
References: <20071024132220.14070582@dhcp-255-175.norway.atmel.com>
 <20071024112453.GP14671@kernel.dk> <20071024112938.GA1770@uranus.ravnborg.org>
 <Pine.LNX.4.64.0710240814570.31881@localhost.localdomain>
 <20071024122120.GV14671@kernel.dk> <20071024124123.GD30533@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007, Adrian Bunk wrote:

> On Wed, Oct 24, 2007 at 02:21:20PM +0200, Jens Axboe wrote:
> > On Wed, Oct 24 2007, Robert P. J. Day wrote:

> > > i was just about to ask -- is this one of those cases where the
> > > asm versions of scatterlist.h should have a warning/error that
> > > they should not be included directly, and to include
> > > linux/scatterlist.h instead?

> > No, using asm/scatterlist.h is perfectly fine. The problem is code
> > using the sg helpers should include linux/scatterlist.h since that
> > is where those are defined.

> > If you just need the scatterlist structure definition, then
> > asm/scatterlist.h is the correct include.

> But there's also the general question whether it's good practice for
> not architecture specific code to include asm/ headers.

> For APIs available on all architectures linux/ header are the right
> thing to use, and what is in the asm/ header and what in the linux/
> header becomes an implementation detail that can be changed.

more to the point, what the above shows is that the headers aren't
well defined.  one would think that a header file whose name is
"scatterlist.h" should provide content related solely to that name.

if there's different content, such as the "sg helpers" mentioned
above, then those should require a different header file inclusion.
it makes no sense to suggest that one should include
<asm/scatterlist.h> if you need *only* that content, but to include
<linux/scatterlist.h> if you need stuff *in addition to* the
scatterlist content.  that's just begging for confusion.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
