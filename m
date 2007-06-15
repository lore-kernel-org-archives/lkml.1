Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbXFOLte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbXFOLte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbXFOLt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:49:26 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:49596 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbXFOLtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:49:25 -0400
Date: Fri, 15 Jun 2007 13:49:13 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: carsteno@de.ibm.com
Cc: Jared Hulbert <jaredeh@gmail.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Heiko Carstens <h.carstens@de.ibm.com>
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070615114913.GA30414@osiris.boeblingen.de.ibm.com>
References: <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706121711m738bd9abqa02350ccc7eabf9f@mail.gmail.com> <4671495A.3020605@de.ibm.com> <6934efce0706140953x2167944fr54eca6376e1f8d63@mail.gmail.com> <46725A4D.1040404@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46725A4D.1040404@de.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 11:22:21AM +0200, Carsten Otte wrote:
> Jared Hulbert wrote:
> >>If you're interrested in using the later for xip without
> >>struct page, I would volounteer to go ahead and implement this?
> >I'm very interested in this.
> Good. Let me see if I can come up with a patch on this.

That would be good.
 
> >I'm not opposed to using struct page, but I'm confused as to how to
> >start that.  As I understand it, which is not well, defined a
> >CONFIG_DISCONTIGMEM region to cover the Flash memory would add that to
> >my pool of RAM.  That would be 'bad', right?  I don't see how to
> >create the page structs and set this memory aside as different.
>
> I fear I am not the right person to answer that question. In the good
> old days before discontigmem/sparse mem/vmem map where invented we used
> to have a hack for that in arch/. Heiko then decided my hack is a
> mess and came up with a good solution to the problem.

I didn't say your old code was a hack. It just didn't work together with
the vmem map approach, so it had to be converted. Otherwise there wouldn't
be a 1:1 kernel mapping or struct pages for your memory region.
If you can write code that doesn't need any struct pages that would make
life a bit easier, since we wouldn't need any pseudo memory hotplug code
that just adds struct pages.
We would still need to add the kernel mapping though.
