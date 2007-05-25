Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbXEYGKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbXEYGKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 02:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXEYGKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 02:10:24 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:35775 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbXEYGKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 02:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gHzmPwJOjPqDZNupg86t/zvNibnvYx0CnZN6Xm3PL2mTSJnfdZGhnro1QPuARkjNsjh0xR4bxN7iH+YDVTMbii2IXySjc6ZVYdgbDwmpwbLnkF3yKl854mv4A9TxXiWc2HXOxU4yrqg3PLrPaT5AU3TUTBG/QZ9AqUClR3wDb80=
Message-ID: <4cefeab80705242310l28b46041m410d0bafd53e2557@mail.gmail.com>
Date: Fri, 25 May 2007 11:40:22 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Richard Purdie" <richard@openedhand.com>
Subject: Re: [RFC] [-mm] Remove 'unsafe' LZO decompressor
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
In-Reply-To: <1180045572.12821.35.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1412F214-FA89-4088-B3A2-DEE03C324FB6@cam.ac.uk>
	 <20070524115055.6be93924.akpm@linux-foundation.org>
	 <1180045572.12821.35.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

Thanks for these perf. figures!

On 5/25/07, Richard Purdie <richard@openedhand.com> wrote:
> On Thu, 2007-05-24 at 11:50 -0700, Andrew Morton wrote:
> > On Thu, 24 May 2007 18:15:17 +0100
> > Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
> >
> > > Attached is a patch which may be desirable for -mm. It applies
> > > directly to 2.6.22-rc2-mm1.
> > >
> > > The patch removes the 'unsafe' LZO decompression function, lowering
> > > the size of the minilzo.c file by nearly 500 out of an original 1727
> > > lines. It also removes references to the 'unsafe' decompression
> > > function in the public LZO header and the EXPORT_SYMBOL_GPL declaration.
> [...]
> > > Comments / disagreement all welcome :)
> >
> > This is obviously a highly desirable thing to do for a number of reasons.
> > But have we quantified the performance difference?
>
> Ok, I've done some tests:
>
> 1. Comparing the safe and unsafe functions
>
> For my minilzo kernel patch, the safe version showed a 7.2% performance
> hit. For Nitin's patch, it showed a 3.2% performance hit (but see
> below).
>

> Could be a lot worse and I don't object to the removal of the unsafe
> version.
>

Ok. Let's drop unsafe version. This will also do away will that Makefile debris.

> 2. Comparing Nitin's code with my minilzo based kernel patch.
>
> My kernel patch is about 2.25 times faster at decompression (16725Kb/ms
> vs 7399Kb/ms) and fractionally faster at compression (1434kb/ms vs
> 1490kb/ms). As things stand the performance of Nitin's patch is
> therefore unacceptable as that is a significant decompression
> performance loss.
>

I suspect this is mainly due to replacement of COPY4() and open coded
byte-by-byte copying with memcpy() calls. I will rollback these
particular changes, remove unsafe version and will see again. I have
retained all other code as-is.

I will also try adding benchmarking code to my (GPL) 'compress-test'
module (same which I sent to Bret). Though it's pretty basic module
but should be sufficient to give required perf. figures.

> These tests are on 32 bit Intel and in userspace but I've found them to
> be a pretty good indicator of what happens in the real world and on
> other architectures.

> For simplicity I made these tests with some existing code I had around
> but its licence is such I can't share it, much to my frustration.
>


Cheers,
Nitin
