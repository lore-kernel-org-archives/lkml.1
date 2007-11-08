Return-Path: <linux-kernel-owner+w=401wt.eu-S1761944AbXKHWjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761944AbXKHWjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbXKHWiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:38:54 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:28972 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082AbXKHWix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:38:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IEKGiIPHf+wgZmUXNVtRfbhP1eZN6FrfO2qwSnDFh4Hng0XLbiMTFNyfQ//ATXAGEuLgJFdS9eQK5OSWnQCKcm8mVag/LJAWcKG6GEpqEKIKbCXfDsN4tlIlO8wMxeEiLec6xQhMEfKFpLfV7jkBvGEEo+AC0C3RctzHBGA4OTE=
Message-ID: <5d6222a80711081438n228bbb93w3212ec7fdda361c@mail.gmail.com>
Date: Thu, 8 Nov 2007 20:38:51 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH RFC 3/7] x86: clean up asm-x86/page*.h
Cc: LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Zach Amsden" <zach@vmware.com>,
       "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>
In-Reply-To: <473378B3.1090700@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071108015008.660012621@goop.org>
	 <20071108015310.218076184@goop.org>
	 <5d6222a80711080842i201cb431le966d5069d59db24@mail.gmail.com>
	 <473378B3.1090700@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 8, 2007 6:59 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Glauber de Oliveira Costa wrote:
> > On Nov 7, 2007 11:50 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >> +#define PAGETABLE_LEVELS       3
> >> +
> >> +typedef u64    pteval_t;
> >> +typedef u64    pmdval_t;
> >> +typedef u64    pudval_t;
> >> +typedef u64    pgdval_t;
> >> +
> >>
> >
> >
> >> -static inline unsigned long long native_pgd_val(pgd_t pgd)
> >> +static inline pgdval_t native_pgd_val(pgd_t pgd)
> >>  {
> >>
> > Maybe these kind of things, the typedef and native_xxx definitions can
> > go into the common header, after we define the PAGETABLE_LEVELS
> > constant?
> > I think the more goes into common headers, the better.
> >
>
> You mean put them in a common header, but conditionally by #if
> PAGETABLE_LEVELS?  I don't think that would be much of an improvement;
> it would just add more #ifs, which adds lines and conceptual
> complexity.  If you go that way, you may as well put everything in one
> header wrapped in #ifs, but personally I don't think that would help.

Not exactly.
for the native_ functions,  there's room for code sharing.
native_pgd_val, and native_pte_val seem to be the same, for at least
pae and x86_64.
As for the typedefs, the same thing can be done. Much like you did in
paravirt.h, just split out between the < 3 and >= 3 levels.

But if it turns out to be just code movement, and I'm wrong in my
supposition that we can turn three variants of the same code into two,
then I agree
with you, let's keep it this way.


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
