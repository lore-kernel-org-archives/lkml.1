Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbZBDEWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbZBDEWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 23:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZBDEW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 23:22:29 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:36687 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751358AbZBDEW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 23:22:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6KTtVqI4KYui52ywKKt8jUtuRdXrwr0YWBDutDyliH+UK9kg6wSVqrF4vksxTr72yAW0rsSj/O0bJGGZO8FlSj3memNLhmP6ij8+ra/IlRN2z/IWPApwu3a4oC9WOdaAxsJR+xYyu5nJjkVq4NCmfJazeC65xxVr3FC3atkIwVo=  ;
X-YMail-OSG: mfwGBKMVM1lwUEzFdDiKrjNqJV.AD98UVB7_nCaPHY3jjBDk8pDmU32llrfbe6HQ1DqBRWUwmXOx.z7CM_UVDa8Gkw9A7WeTrU0j8dBbUKe4YdaACKH5q4UJ2_ORlrJsSm0aM542gMcpIJuCffUyGD5rZVTv3mt7mtQbGUXmOrtiNS84HkW_0fh6VyH2euKolD0EsSk_xs7KjjdueU.FxoAeSWDEqlWC
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch] SLQB slab allocator
Date: Wed, 4 Feb 2009 15:22:00 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20090114155923.GC1616@wotan.suse.de> <84144f020902031042i31eaec14v53a0e7a203acd28b@mail.gmail.com> <84144f020902031047o2e117652w28886efb495688c4@mail.gmail.com>
In-Reply-To: <84144f020902031047o2e117652w28886efb495688c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041522.01307.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 05:47:48 Pekka Enberg wrote:
> On Tue, Feb 3, 2009 at 8:42 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >> It will grow unconstrained if you elect to defer queue processing. That
> >> was what we discussed.
> >
> > Well, the slab_hiwater() check in __slab_free() of mm/slqb.c will cap
> > the size of the queue. But we do the same thing in SLAB with
> > alien->limit in cache_free_alien() and ac->limit in __cache_free(). So
> > I'm not sure what you mean when you say that the queues will "grow
> > unconstrained" (in either of the allocators). Hmm?
>
> That said, I can imagine a worst-case scenario where a queue with N
> objects is pinning N mostly empty slabs. As soon as we hit the
> periodical flush, we might need to do tons of work. That's pretty hard
> to control with watermarks as well as the scenario is solely dependent
> on allocation/free patterns.

That's very true, and we touched on this earlier. It is I guess
you can say a downside of queueing. But an analogous situation
in SLUB would be that lots of pages on the partial list with
very few free objects, or freeing objects to pages with few
objects in them. Basically SLUB will have to do the extra work
in the fastpath.

