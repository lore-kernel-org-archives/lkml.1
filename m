Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbZFLInj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbZFLInj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932891AbZFLInb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:43:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46823 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848AbZFLIn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:43:29 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, cl@linux-foundation.org,
       akpm@linux-foundation.org, npiggin@suse.de
In-Reply-To: <1244796045.7172.82.camel@pasglop>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
	 <1244770230.7172.4.camel@pasglop>  <1244779009.7172.52.camel@pasglop>
	 <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop>
	 <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
	 <1244792079.7172.74.camel@pasglop>
	 <1244792745.30512.13.camel@penberg-laptop>
	 <1244796045.7172.82.camel@pasglop>
Date: Fri, 12 Jun 2009 11:43:31 +0300
Message-Id: <1244796211.30512.32.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Fri, 2009-06-12 at 18:40 +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2009-06-12 at 10:45 +0300, Pekka Enberg wrote:
> > Hi Ben,
> 
> > The call-sites I fixed up are all boot code AFAICT. And I like I said,
> > we can't really _miss_ any of those places, they must be checking for
> > slab_is_available() _anyway_; otherwise they have no business using
> > kmalloc(). And note: all call-sites that _unconditionally_ use
> > kmalloc(GFP_KERNEL) are safe because they worked before.
> 
> No. The check for slab_is_available() can be levels higher, for example
> the vmalloc case. I'm sure I can find a whole bunch more :-) Besides
> I find the approach fragile, and it will suck for things that can be
> rightfully called also later on.

Yes, you're obviously right. I overlooked the fact that arch code have
their own special slab_is_available() heuristics (yikes!).

But are you happy with the two patches I posted so I can push them to
Linus?

			Pekka

