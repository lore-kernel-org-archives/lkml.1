Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZCAAib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZCAAib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 19:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbZCAAiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 19:38:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:46442 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbZCAAiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 19:38:22 -0500
Date: Sat, 28 Feb 2009 16:38:11 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, mingo@elte.hu, nickpiggin@yahoo.com.au,
       sqazi@google.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090228163811.48b1de72@infradead.org>
In-Reply-To: <49A9D6CA.30906@zytor.com>
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain>
	<20090228092450.3ded2db5@infradead.org>
	<alpine.LFD.2.00.0902280935010.3111@localhost.localdomain>
	<20090228.160651.228301019.davem@davemloft.net>
	<20090301004003.GF26292@one.firstfloor.org>
	<49A9D6CA.30906@zytor.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Feb 2009 16:28:58 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Andi Kleen wrote:
> >> I think this is an accurate analysis as well, it's really
> >> unfortunate the non-temporal stuff on x86 doesn't preserve
> >> existing cache lines when present.
> >>
> >> I thought that was the whole point.  Don't pollute the caches, but
> >> if cache lines are already loaded there, use them and don't purge!
> > 
> > x86 actually supports that, it's just not done through movnt.
> > 
> > You can do that on x86 by using PREFETCHNTA (or T0/T1/T2 for
> > specific cache levels). Typically this is implemented by forcing
> > the cache line to only a single way of the cache (so only using max
> > 1/8 or so of your last level cache) 
> > 
> > I'm not sure how it interacts with REP MOVS* though, this internally
> > tends to do additional magic for larger copies.
> 
> The PREFETCHNTA stuff is really for reads rather than writes, however.
> Yes, you can prefetch the cache line you're about to overwrite, but I
> suspect (I haven't verified) that you lose out on whole-line
> optimizations that way.

the entire point of using movntq and friends was to save half the
memory bandwidth to not pull it into the cache before writing...
.... so bad idea to do prefetch<anything>

> 
> 	-hpa
> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
