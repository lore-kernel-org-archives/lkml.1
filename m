Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbZEDRw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbZEDRw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZEDRwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:52:17 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35847 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbZEDRwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:52:16 -0400
Date: Mon, 4 May 2009 19:54:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Tim Abbott <tabbott@mit.edu>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       Anders Kaseorg <andersk@mit.edu>
Subject: Re: [PATCH v2 0/6] macros for section name cleanup
Message-ID: <20090504175427.GB9489@uranus.ravnborg.org>
References: <1241121253-32341-1-git-send-email-tabbott@mit.edu> <20090501213118.GA28126@uranus.ravnborg.org> <alpine.DEB.1.10.0905011916530.10966@vinegar-pot.mit.edu> <20090502220132.GA4130@uranus.ravnborg.org> <20090504142732.GA8237@uranus.ravnborg.org> <alpine.DEB.1.10.0905041209570.10610@vinegar-pot.mit.edu> <8bd0f97a0905041042g71af324eo1d38e35799836c86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0905041042g71af324eo1d38e35799836c86@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 01:42:08PM -0400, Mike Frysinger wrote:
> On Mon, May 4, 2009 at 12:32, Tim Abbott wrote:
> > On Mon, 4 May 2009, Sam Ravnborg wrote:
> >> +#define RW_DATA_SECTION(page_align, readmostly_align, cache_align,
> >>   inittask_align) \
> >> +     . = ALIGN(PAGE_SIZE);                                           \
> >> +     .data : AT(ADDR(.data) - LOAD_OFFSET) {                         \
> >> +             DATA_DATA                                               \
> >> +             CONSTRUCTORS                                            \
> >> +             NOSAVE_DATA                                             \
> >> +             PAGE_ALIGNED_DATA(page_align)                           \
> >> +             READMOSTLY_DATA(readmostly_align)                       \
> >> +             CACHELINE_ALIGNED_DATA(cache_align)                     \
> >> +             INIT_TASK(inittask_align)                               \
> >> +     }
> >
> > How did you pick the order of the sections here?  I would think that to
> > pack the .data section efficiently, you'd want to sort by alignment
> > requirements so that e.g. all the at-least-page aligned sections are
> > adjacent (INIT_TASK and the page-aligned sections are separated by some
> > much smaller aligments here).
> 
> if this were actually the case, there should of course be some /*
> comments */ above the define explaining that the order wasnt
> arbitrarily pulled like a rabbit from an orifice.  if you're
> scratching your head, then there's going to be plenty more people who
> never ask but treat it like untouchable voodoo.

Point taken (from both of you).
I will try to document the order in next version.

In reality I just picked the order used for 32 bit x86 IIRC.

	Sam
