Return-Path: <linux-kernel-owner+w=401wt.eu-S968487AbXFHIDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968487AbXFHIDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967996AbXFHH2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:28:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42736 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967991AbXFHH23 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:28:29 -0400
Date: Fri, 8 Jun 2007 08:28:25 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, carsteno@de.ibm.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070608072824.GA13442@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jared Hulbert <jaredeh@gmail.com>, carsteno@de.ibm.com,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	richard.griffiths@windriver.com,
	Richard Griffiths <res07ml0@verizon.net>,
	Linux-kernel@vger.kernel.org
References: <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com> <20070606162305.GA20600@infradead.org> <46683B6A.6030306@de.ibm.com> <20070607193844.GB17144@infradead.org> <6934efce0706071334w54eea3d9mfed1670f527ff831@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6934efce0706071334w54eea3d9mfed1670f527ff831@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 01:34:12PM -0700, Jared Hulbert wrote:
> >And we'll need that even when using cramfs.  There's not way we'd
> >merge a hack where the user has to specify a physical address on
> >the mount command line.
> 
> Why not?  For the use case in question the user usually manually
> burned the image to a physical address before hand.  Many of these
> system don't have MTD turned on for this Flash, they don't need it
> because they don't write to this Flash once the system is up.

Then add a small device layer for it.  Remember that linux is not all
about hacked up embedded devices that get shipped once and never
touched again.  If we put something in mainline we want proper layering,
and putting ioremap (which doesn't even exist on some architectures) into
a filesystem and having user remember memory addresses and pass them
to mount doesn't fit there.
