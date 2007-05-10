Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbXEJJcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbXEJJcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbXEJJcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:32:46 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:2510 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbXEJJcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:32:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r3s4hdZ5zg1bLNasFhxPnaXHpohX8w9UUIGa0ZntBVjlGs2wxaqPRjyL96BbEkJPc1p9dg3RVxsLFpHNQZb9P31yQCHGm9UmYZm5Kh7Of/xN06Lb5ggqVd0WHNavwHx96r7ObGZCB/xH/2Bk1KNqHJqubu+7jZN8PbP7Xhjs+GM=
Message-ID: <a781481a0705100232t72b3b20bmae9e9bb31a1a6d4e@mail.gmail.com>
Date: Thu, 10 May 2007 15:02:43 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH -mm] timer: parenthesis fix in tbase_get_deferrable() etc.
Cc: "Jarek Poplawski" <jarkao2@o2.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Oleg Nesterov" <oleg@tv-sign.ru>
In-Reply-To: <a781481a0705100126x6a649c16ic26409b4ffe80ed3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0705091129t6a348fb7ya2a225123fca3f6@mail.gmail.com>
	 <653FFBB4508B9042B5D43DC9E18836F55DFC44@scsmsx415.amr.corp.intel.com>
	 <a781481a0705100126x6a649c16ic26409b4ffe80ed3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> > [...]
> > On a 64 bit system, converting pointer to int causes unnecessary
> > compiler
> > warning, and intermediate long conversion was to avoid that. I will have
>
> Whoa! Hello, hold on, just wait a second there. Do you _really_ want
> an unsigned int return out of tbase_get_deferrable() or will an
> unsigned long do? If the rest of your code is fine with unsigned long,
> then I'd suggest something like:
>
> static inline unsigned long tbase_get_deferrable(tvec_base_t *base)
> {
>         return ((unsigned long)base & TBASE_DEFERRABLE_FLAG);
> }
>
> I don't really know your code (so I could be horribly incorrect here),
> but personally I would prefer *heeding* to that warning than _hiding_
> it -- it's not unnecessary, it's telling you that you're *losing* data
> by converting a pointer (which is always unsigned long) to unsigned
> int for 64-bit platforms where sizeof(void *) == sizeof(unsigned long)
> == 8 bytes, but sizeof(unsigned int) == 4.

Oh well, pardon my obtuseness (I _really_ ought to be at least looking
around in the code before jumping in like this :-) ...
TBASE_DEFERRABLE_FLAG only {ab}uses the lowest bit of tvec_base_t *,
so clearly no pointer truncation issues here (you could still prefer
the unsigned long version for simplicity & style, though).

*embarrassed, goes for a cup of coffee*
