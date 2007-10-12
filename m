Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbXJLOzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbXJLOzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 10:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXJLOzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 10:55:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44065 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbXJLOzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:55:23 -0400
Date: Fri, 12 Oct 2007 07:53:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Suleiman Souhlal <ssouhlal@freebsd.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Suleiman Souhlal <suleiman@google.com>, linux-mm <linux-mm@kvack.org>,
       hugh <hugh@veritas.com>
Subject: Re: [PATCH] mm: avoid dirtying shared mappings on mlock
Message-ID: <20071012075317.591212ef@laptopd505.fenrus.org>
In-Reply-To: <1192186222.27435.22.camel@twins>
References: <11854939641916-git-send-email-ssouhlal@FreeBSD.org>
	<200710120257.05960.nickpiggin@yahoo.com.au>
	<1192185439.27435.19.camel@twins>
	<200710120414.11026.nickpiggin@yahoo.com.au>
	<1192186222.27435.22.camel@twins>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 12:50:22 +0200
> > > The pages will still be read-only due to dirty tracking, so the
> > > first write will still do page_mkwrite().
> > 
> > Which can SIGBUS, no?
> 
> Sure, but that is no different than any other mmap'ed write. I'm not
> seeing how an mlocked region is special here.
> 
> I agree it would be nice if mmap'ed writes would have better error
> reporting than SIGBUS, but such is life.

well... there's another consideration
people use mlock() in cases where they don't want to go to the
filesystem for paging and stuff as well (think the various iscsi
daemons and other things that get in trouble).. those kind of uses
really use mlock to avoid
1) IO to the filesystem
2) Needing memory allocations for pagefault like things
at least for the more "hidden" cases...

prefaulting everything ready pretty much gives them that... letting
things fault on demand... nicely breaks that.
