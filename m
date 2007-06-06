Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbXFFQXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbXFFQXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXFFQXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:23:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40517 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXFFQXN (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:23:13 -0400
Date: Wed, 6 Jun 2007 17:23:05 +0100
From: Christoph Hellwig <hch@infradead.org>
To: carsteno@de.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070606162305.GA20600@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	carsteno@de.ibm.com, Jared Hulbert <jaredeh@gmail.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	richard.griffiths@windriver.com,
	Richard Griffiths <res07ml0@verizon.net>,
	Linux-kernel@vger.kernel.org
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4666DD88.5030708@de.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 06:15:04PM +0200, Carsten Otte wrote:
> The clear advantage of using cramfs on embedded platforms over using the
> ext2 stuff is, that one can choose per-file whether it should be
> compressed or xip.
> The real key is, to put both our ext2 stuff and the cramfs xip on a 
> common infrastructure. They should use the same file operations and 
> adress space operations for xip files rather then replicating each 
> others bugs.
> If cramfs shall be kept simple, it might be time to fork that file 
> system. I don't see that need arise from the proposed solution. It can 
> become clean and sane with a little work on it. Look at the xip 
> extensions for ext2 for example, they don't bloat the filesystem too much.

ext2 is a multi-purpose block based filesystem and you add support for
another bit of storage.  cramfs is very specialized to storing read-only
compressed data on block devices.  The embedded people already use them
on flash which is a little dumb, but now we add even more cludge for
a non-block based access.

The right way to architect xip for flash-based devices is to implement
a generic get_xip_page for mtd-based devices and integrate that into
an existing flash filesystem or write a simple new flash filesystem
tailored to that use case.
