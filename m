Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbZFXRzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbZFXRzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbZFXRzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:55:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755326AbZFXRzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:55:35 -0400
Date: Wed, 24 Jun 2009 10:55:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-Id: <20090624105517.904f93da.akpm@linux-foundation.org>
In-Reply-To: <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com>
References: <20090624080753.4f677847@infradead.org>
	<20090624094622.d0b0fd82.akpm@linux-foundation.org>
	<84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 19:55:24 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Wed, Jun 24, 2009 at 7:46 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> > Well yes. __Using GFP_NOFAIL on a higher-order allocation is bad. __This
> > patch is there to find, name, shame, blame and hopefully fix callers.
> >
> > A fix for cxgb3 is in the works. __slub's design is a big problem.
> >
> > But we'll probably have to revert it for 2.6.31 :(
> 
> How is SLUB's design a problem here? Can't we just clear GFP_NOFAIL
> from the higher order allocation and thus force GFP_NOFAIL allocations
> to use the minimum required order?

That could then lead to the __GFP_NOFAIL allocation attempt returning
NULL.  But the callers cannot handle that and probably don't even test
for it - this is why they used __GFP_NOFAIL.

I dunno.  Mabe we should just remove __GFP_NOFAIL and convert callers back
to open-coded infinite retry loops.  Hardly an improvement, but it at
least would stop people naively using __GFP_NOFAIL.

