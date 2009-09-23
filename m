Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZIWShD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZIWShD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 14:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZIWShA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 14:37:00 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50802 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbZIWSg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 14:36:59 -0400
Date: Wed, 23 Sep 2009 14:36:06 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 01/13] Optimize the ordering of sections in
 RW_DATA_SECTION.
In-Reply-To: <alpine.LFD.2.01.0909231126300.3303@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0909231430190.26798@dr-wily.mit.edu>
References: <1253629347-23119-1-git-send-email-tabbott@ksplice.com> <1253629347-23119-2-git-send-email-tabbott@ksplice.com> <alpine.LFD.2.01.0909231126300.3303@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009, Linus Torvalds wrote:

> 
> Umm. As a commit message this sucks. What's so optimized about this?

Yeah, it does.  Sorry about that.  

This patch sorts the sections by alignment requirements, which should pack 
them essentially optimally.  The old RW_DATA_SECTION had INIT_TASK_DATA 
(which was more-than-PAGE_SIZE-aligned), followed by a bunch of small 
alignment stuff, followed by more PAGE_SIZE-aligned stuff, so you wasted 
memory in the middle of .data re-aligning back up to PAGE_SIZE.

	-Tim Abbott

> On Tue, 22 Sep 2009, Tim Abbott wrote:
> >
> > Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> > Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
> > ---
> >  include/asm-generic/vmlinux.lds.h |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index 29ca8f5..b6e818f 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -721,12 +721,12 @@
> >  	. = ALIGN(PAGE_SIZE);						\
> >  	.data : AT(ADDR(.data) - LOAD_OFFSET) {				\
> >  		INIT_TASK_DATA(inittask)				\
> > +		NOSAVE_DATA						\
> > +		PAGE_ALIGNED_DATA(pagealigned)				\
> >  		CACHELINE_ALIGNED_DATA(cacheline)			\
> >  		READ_MOSTLY_DATA(cacheline)				\
> >  		DATA_DATA						\
> >  		CONSTRUCTORS						\
> > -		NOSAVE_DATA						\
> > -		PAGE_ALIGNED_DATA(pagealigned)				\
> >  	}
> >  
> >  #define INIT_TEXT_SECTION(inittext_align)				\
> > -- 
> > 1.6.3.3
> > 
> 
