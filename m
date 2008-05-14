Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbYENOyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbYENOyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbYENOyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:54:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52752 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760274AbYENOyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:54:14 -0400
Date: Wed, 14 May 2008 16:53:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] Immediate Values - jump patching update
Message-ID: <20080514145356.GA6569@ucw.cz>
References: <481607AF.80803@zytor.com> <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com> <20080428221122.GC16153@elte.hu> <48164EE6.8010506@zytor.com> <20080428224438.GA6974@elte.hu> <48165866.5060403@zytor.com> <20080429004739.GA23281@redhat.com> <481674FA.4030306@zytor.com> <20080429120827.GB31271@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429120827.GB31271@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> At least one complication though is that in the case of markers, 
> >> tracing parameter evaluation is itself conditional (and placed out of 
> >> the hot path due to -freorder-blocks).  With your suggested kind of 
> >> assembly ("g" constraints for all the expressions), those expressions 
> >> would be evaluated unconditionally, just to make them live somewhere. 
> >> That unconditional evaluation can easily entail memory reads and 
> >> dependent arithmetic, which could swamp the savings of eliminating 
> >> the marker-style conditional branch.
> >
> > Well, it depends a bit on what kind of expressions you put in there. 
> > You don't really want to put *expressions* in there as much as you 
> > want to put *data* references in there, although, of course, if your 
> > have something like "foo->bar[baz]->quux" then it's easy to trip upon.
> 
> and that's exactly what was tripped upon in sched.o and analyzed.
> 
> Furthermore, the suggestion of doing this exclusively within the DWARF2 
> space - besides the not particularly minor complication of it not being 
> implemented yet - is:
> 
>  - quite substantially complex on its own
> 
>  - would make Linux instrumentation dependent on all sorts of DWARF2
>    details which we had our 'fun' with before. (I proffer that that's
>    more fragile than any code patching can ever be.)

>  - if done self-sufficiently (i.e. if a kernel image can be used to
>    trace things, which i believe any usable kernel tracer must offer),
>    it would, with the current debug info format, enlargen the kernel RAM
>    image with quite a substantial amount of unswappable kernel memory. 

I am not sure self-sufficiency is  good goal here.

If tracing becomes part of kernel-user ABI, we are in big trouble...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
