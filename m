Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYKDQ27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYKDQ27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYKDQ2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:28:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49387 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753839AbYKDQ2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:28:50 -0500
Date: Tue, 4 Nov 2008 16:28:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Friesen <cfriesen@nortel.com>, Rik van Riel <riel@redhat.com>,
       "Eugene V. Lyubimkin" <jackyf.devel@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       hugh <hugh@veritas.com>
Subject: Re: mmap: is default non-populating behavior stable?
Message-ID: <20081104162820.644b1487@lxorguk.ukuu.org.uk>
In-Reply-To: <1225814820.7803.1672.camel@twins>
References: <490F73CD.4010705@gmail.com>
	<1225752083.7803.1644.camel@twins>
	<490F8005.9020708@redhat.com>
	<491070B5.2060209@nortel.com>
	<1225814820.7803.1672.camel@twins>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2008 17:07:00 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2008-11-04 at 09:56 -0600, Chris Friesen wrote:
> > Rik van Riel wrote:
> > > Peter Zijlstra wrote:
> > 
> > >> The exact interaction of mmap() and truncate() I'm not exactly clear on.
> > > 
> > > Truncate will reduce the size of the mmaps on the file to
> > > match the new file size, so processes accessing beyond the
> > > end of file will get a segmentation fault (SIGSEGV).
> > 
> > I suspect Peter was talking about using truncate() to set the initial 
> > file size, effectively increasing rather than reducing it.
> 
> I was thinking of truncate() on an already mmap()'ed region, either
> increasing or decreasing the size so that part of the mmap becomes
> (in)valid.
> 
> I'm not sure how POSIX speaks of this.
> 
> I think Linux does the expected thing.

I believe our behaviour is correct for mmap/mumap/truncate and it
certainly used to be and was tested.

At the point you do anything involving mremap (which is non posix) our
behaviour becomes rather bizarre.

Alan
