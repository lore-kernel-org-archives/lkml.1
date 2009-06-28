Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZF1S05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZF1S05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZF1S0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:26:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:53786 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZF1S0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:26:47 -0400
Date: Sun, 28 Jun 2009 11:27:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090628112748.2470f2d5@infradead.org>
In-Reply-To: <alpine.LFD.2.01.0906281101030.3605@localhost.localdomain>
References: <20090624094622.d0b0fd82.akpm@linux-foundation.org>
	<84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com>
	<20090624105517.904f93da.akpm@linux-foundation.org>
	<4A426825.80905@cs.helsinki.fi>
	<20090624113037.7d72ed59.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241134510.3240@localhost.localdomain>
	<20090624120617.1e6799b5.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241211550.3154@localhost.localdomain>
	<20090624123624.26c93459.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241240360.3154@localhost.localdomain>
	<20090628101654.GB8673@ucw.cz>
	<alpine.LFD.2.01.0906281101030.3605@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009 11:01:42 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The _other_ part of memory management that you and Andrew seem to be 
> ignoring is that it's very robust, and keeps extra memory around, and
> just generally does the right thing. We don't generally pre-allocate
> anything, because we don't need to.

... and if there is a real concern, the real solution is to have a way
to request that the VM temporarily increases the amount of extra memory.
Preferably before you go down a path of hardship so that the VM can
do some work to satisfy the request.

There are a few places where having (small) local reserves make sense of
course, mostly in the write out paths like the block layer. And we do
that already.

> 
> Almost the _only_ way to run out of memory is to have tons and tons
> of dirty pages around. Yes, it can happen. But if it happens, you're
> almost guaranteed to be screwed anyway. The whole VM is designed

my impression is that when the strict dirty accounting code went in,
this problem largely went away.

The other problem is pinned memory, but this was mostly a
lowmem/highmem thing, and time (and 64 bit) seems to have mostly solved
the more common cases of those.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
