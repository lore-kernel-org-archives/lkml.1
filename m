Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbXFRG6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbXFRG6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756635AbXFRG55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:57:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:12895 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524AbXFRG54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jObugDC6BICXbI6pIVWz1ZI/WawLzB6rDUnPXZYYMQnWz1NacSq9SHHjFWl3CfwTa1VdQ+fblm7b+YNAXeFwVP5XYnV+Qpsjjvq7FHlCqSRmC7o5CtRNBXqJcIm1F9bZUhYQvcXPYirdSzwd6H09d5G3EByFTY1VXNTMzxMTMlU=
Message-ID: <a781481a0706172357s7c473686pa41df174af01cda4@mail.gmail.com>
Date: Mon, 18 Jun 2007 12:27:55 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Yasunori Goto" <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] mm: More __meminit annotations.
Cc: "Paul Mundt" <lethal@linux-sh.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070618151544.B10A.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070618143943.B108.Y-GOTO@jp.fujitsu.com>
	 <20070618055842.GA17858@linux-sh.org>
	 <20070618151544.B10A.Y-GOTO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/18/07, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> > On Mon, Jun 18, 2007 at 02:49:24PM +0900, Yasunori Goto wrote:
> > > > -static inline unsigned long zone_absent_pages_in_node(int nid,
> > > > +static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
> > > >                                           unsigned long zone_type,
> > > >                                           unsigned long *zholes_size)
> > > >  {
> > >
> > > I thought __meminit is not effective for these static functions,
> > > because they are inlined function. So, it depends on caller's
> > > defenition. Is it wrong?
> > >
> > Ah, that's possible, I hadn't considered that. It seems to be a bit more
> > obvious what the intention is if it's annotated, especially as this is
> > the convention that's used by the rest of mm/page_alloc.c. A bit more
> > consistent, if nothing more.
>
> I'm not sure which is intended. I found some functions define both
> __init and inline in kernel tree. And probably, some functions don't
> do it. So, it seems there is no convention.
>
> I'm Okay if you prefer both defined. :-)

Marking inline functions as __init (or __meminit etc) is quite insane,
IMHO. Note that all callers of the said inline function will also have to
be __init anyway (else modpost will barf) so the said function will
have all callsites in .init.text anyway, and hence would be inlined
in the same section as the caller (i.e. .init.text). [Note that kernel
uses always_inline.]

The annotation may still be a readability aid (which is subjective so
one can't really comment upon), but asking gcc to put into a separate
specified section, a function whose body would not be emitted by gcc
separately at all, doesn't really make much sense syntactically _or_
semantically -- gcc might not warn, of course, perhaps it's one of those
little things it takes care of by itself silently without complaining (like
taking pointers to inline functions).

Satyam
