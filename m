Return-Path: <linux-kernel-owner+w=401wt.eu-S1763704AbXEXEEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763704AbXEXEEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 00:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbXEXEEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 00:04:14 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:36338 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759008AbXEXEEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 00:04:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tg+6JhmQUoldtWiSDnCNc/hKgdO6K5s6UoRpH7HzQCnP/erRb3UZ+pqyztYUjLunPS/i+4QTExUjS5sf9Toh6TVJ5S8taOXcw9dlGiWrcjVlTuDDQ0bAy0AW6u4IkJzLqcjb2HjCG1iqY2NQiz/7AFnEenTkgp9WzVdlj52k5Uo=
Message-ID: <4cefeab80705232104n54b23b9bi8b5db8e6a6dd1c0a@mail.gmail.com>
Date: Thu, 24 May 2007 09:34:12 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Richard Purdie" <richard@openedhand.com>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org
In-Reply-To: <1179938960.5864.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk>
	 <4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com>
	 <624FD7A7-5552-415F-96D8-4353453EA2A3@cam.ac.uk>
	 <4cefeab80705230703vdb3c414s250a61c4c2d70c51@mail.gmail.com>
	 <1CF43BBC-79EF-449B-A398-AE374E399573@cam.ac.uk>
	 <4cefeab80705230721i492b5f1ehfa2d775344b1c04e@mail.gmail.com>
	 <20070523091601.f8c6b833.akpm@linux-foundation.org>
	 <1179938960.5864.26.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/07, Richard Purdie <richard@openedhand.com> wrote:
> On Wed, 2007-05-23 at 09:16 -0700, Andrew Morton wrote:
> > On Wed, 23 May 2007 19:51:44 +0530 "Nitin Gupta" <nitingupta910@gmail.com> wrote:
> > > On 5/23/07, Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
>
> > If so, it was quite inappropriate that a filesystem be using the unsafe
> > version.
>
> Yes, I'll give you a patch to change the resier4 code in -mm then (if
> its not already been changed).

Richard, are you planning to use this patch for LZO or your own port?
Can we decide on a Final Unified(tm) version of LZO port and then
patch up reiser4 or whatever to use that Ultimate LZO instead?

Can you please look into this (take 3) version on LZO patch posted and
we can edit/add/remove things from this to unify our effort - there is
no point in this duplication.

Perhaps you have opinion of maintaining diffability with original LZO
code which differs from mine. Since the code is now just ~500 lines it
should be fair enough to have major overhauls for sake of clean
KernelStyle(tm) code. It shouldn't be that hard to verify this small
code for bugs that might have crept in during porting work. As regard
to keeping up with future LZO versions, hm.... that will be hard - but
I don't think algorithm itself will change and optimizations can
always be done separately in this fork.

>
> > I'd agree with the proposed renaming.  In fact I'd suggest that the unsafe
> > APIs just be removed - it's hard to imagine a situation in which they're OK
> > to be used in the kernel.
>
> The compressed cache code might be one exception since it does the
> compression itself and shouldn't get corrupted. If it does get
> corrupted, you have bigger problems.
>

Yes. Compressed Caching is one of cases where compressed data cannot
get magically corrupted. Hence, there is no need to go for the 'safe'
version. There might be other such cases too, so removing 'unsafe'
version is not good.

Ok, I will rename 'unsafe' version as such (as suggested by Michael).


Cheers,
Nitin
