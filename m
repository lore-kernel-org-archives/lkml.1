Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbXEJFqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbXEJFqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbXEJFqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:46:35 -0400
Received: from mx10.go2.pl ([193.17.41.74]:52901 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754312AbXEJFqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:46:34 -0400
Date: Thu, 10 May 2007 07:52:57 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm] timer: parenthesis fix in tbase_get_deferrable() etc.
Message-ID: <20070510055256.GB1611@ff.dom.local>
References: <20070509053144.GA995@ff.dom.local> <653FFBB4508B9042B5D43DC9E18836F55DF9FD@scsmsx415.amr.corp.intel.com> <a781481a0705091129t6a348fb7ya2a225123fca3f6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0705091129t6a348fb7ya2a225123fca3f6@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 11:59:39PM +0530, Satyam Sharma wrote:
> On 5/9/07, Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:
> >
> >>-----Original Message-----
> >>From: Jarek Poplawski [mailto:jarkao2@o2.pl]
> >>Sent: Tuesday, May 08, 2007 10:32 PM
> >>To: Andrew Morton
> >>Cc: Pallipadi, Venkatesh; linux-kernel@vger.kernel.org; Oleg Nesterov
> >>Subject: Re: [PATCH -mm] timer: parenthesis fix in
> >>tbase_get_deferrable() etc.
> >>
> >>On Tue, May 08, 2007 at 04:33:58PM -0700, Andrew Morton wrote:
> >>> On Tue, 8 May 2007 12:33:48 +0200
> >>> Jarek Poplawski <jarkao2@o2.pl> wrote:
...
> >>> >  static inline unsigned int tbase_get_deferrable(tvec_base_t *base)
> >>> >  {
> >>> > -  return ((unsigned int)(unsigned long)base &
> >>TBASE_DEFERRABLE_FLAG);
> >>> > +  return (unsigned int)((unsigned long)base &
> >>TBASE_DEFERRABLE_FLAG);
> >>> >  }
> >>...
> >>> The change makes sense, but does it actually "fix" anything?
> >>>
> >>
> >>Yes - this first place fixes logical error, so it's a sin
> >>- even if not punishable in practice. (It's also unnecessary
> >>test for long to int conversion.)
> >>
> >
> >I am sorry, I don't understand. What is the logical error in the first
> >one?

I am sorry, too - for my "logic". It seems it's all correct!
(Except, I don't know what's going here...)

> >
> >Actually, your change makes it different from what was originally
> >indended.
> >Original intention was to type convert base to a 32 bit value and
> >bitwise& with FLAG.
> 
> But that is not what the original code is doing. If you wanted to
> typecast "base" to "a 32 bit value" then you should've used u32
> instead.
> 
> Anyway, if you originally intended to actually typecast "base" to
> unsigned int, then you could do that directly without typecasting it
> first to unsigned long (unnecessarily) and then to unsigned int. Of
> course, if your system implements a pointer as something bigger than
> unsigned int (which is what you eventually convert "base" to), then
> you're screwed anyway and the intermediate typecast to unsigned long
> doesn't buy you anything at all.
> 
> The other 3 changes in this patch were clearly meaningless, though.
> 

	((unsigned int)(unsigned long)base ...
	((tvec_base_t *)((unsigned long)base ...
	((tvec_base_t *)((unsigned long)(timer->base) ...
	(tvec_base_t *)((unsigned long)(new_base) ...

Yes, if you don't count reading this one close each other, they are
clearly meaningles.

Regards,
Jarek P.
