Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYBQUwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYBQUwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYBQUwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:52:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37543 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYBQUwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:52:22 -0500
Date: Sun, 17 Feb 2008 12:51:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Paul Jackson <pj@sgi.com>
Cc: Adrian Bunk <bunk@kernel.org>, tilman@imap.cc, elendil@planet.nl,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Unable to continue testing of 2.6.25
Message-ID: <20080217125139.287c880f@laptopd505.fenrus.org>
In-Reply-To: <20080217143851.c21a9cc4.pj@sgi.com>
References: <200802171025.30590.elendil@planet.nl>
	<20080217131611.GA1403@cs181133002.pp.htv.fi>
	<47B88A08.2070902@imap.cc>
	<20080217194447.GD1403@cs181133002.pp.htv.fi>
	<20080217143851.c21a9cc4.pj@sgi.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 14:38:51 -0600
Paul Jackson <pj@sgi.com> wrote:

> Adrian wrote:
> > So let's fix the problem (kernel lacks functionality)
> 
> That's the problem as understood by Adrian.
> 
> I hear another problem as well ... 
> 
> Frans wrote:
> > Please allow external users some decent period for transitioning.
> > The initial plan to "remove the old function in 2.6.27" was
> > entirely sensible. It's a pity it was not followed through.
> 
> That seems plain enough to me.  It's not just the lack of
> functionality, but that such lack apparently happened with too little
> warning.
> 
> If this is a fair representation of what happened, then seems to me
> that we could have left that EXPORT_UNUSED_SYMBOL(change_page_attr)
> in place a bit longer.
> 

it's not a fair repersentation. Again.. this export was unkeepable due to the
API being nasty and having to be fixed anyway ;(.

One of the problems was that the c-p-a api has to be followed by a cache flush function call.
Sadly that does a TOTAL flush of the caches of all cpus in the system. As part of the -rc1
changes, it is now done only on the exact pages that need to be flushed (so you no longer
flush 12Mb of caches when you only needed to flush 4Kb), but to achieve that, it was no longer
an option to keep this as 2 separate function calls.
Add to this that some very fundemanteal bugs couldn't be fixed without the function underlying
cpa changing prototype and behavior, so the function had to go.

> Or at least, if we really did have to make Frans life difficult like
> this, we could offer more appreciation for how things might look from
> his perspective.

I understand where he's coming from; at the same time it's a very small change to virtualbox to fix this
and has been done already... in minutes. Frans should take that up with the virtual box support forum, I'm sure
they have the patch available there. (it's mostly removing workarounds for cpa bugs and then just calling set_memory_x / set_memory_nx).

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
