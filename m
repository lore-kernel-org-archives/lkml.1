Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbYCZNQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbYCZNQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 09:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYCZNQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 09:16:36 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:54132 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbYCZNQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 09:16:35 -0400
Date: Wed, 26 Mar 2008 09:16:32 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: David Woodhouse <dwmw2@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why so many unexported headers checking __KERNEL__?
In-Reply-To: <1206537022.9540.274.camel@pmac.infradead.org>
Message-ID: <alpine.LFD.1.00.0803260913350.6316@localhost.localdomain>
References: <alpine.LFD.1.00.0803230229530.1203@localhost.localdomain>  <1206533324.9540.268.camel@pmac.infradead.org>  <alpine.LFD.1.00.0803260846390.6148@localhost.localdomain> <1206537022.9540.274.camel@pmac.infradead.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, David Woodhouse wrote:

> On Wed, 2008-03-26 at 08:53 -0400, Robert P. J. Day wrote:
> > not surprisingly, the only reason i noticed the above was because
> > i hacked together a short script that went looking for all of the
> > above and i was surprised at the number of files it identified.
>
> It's not _that_ surprising. Remember, before headers_install people
> just used to copy _all_ the headers across, and so the only way to
> hide stuff was to wrap entire files in #ifdef __KERNEL__.

ah, i had no idea.  that explains it.

> > p.s. the other case that could be identified is when a header file
> > has its *entire* contents encased in a __KERNEL__ test, (either
> > ifdef or ifndef).  AFAICT, unless that kind of test is
> > partitioning *some* of a header file content from the remainder,
> > there's little value in a __KERNEL__test if the end result is to
> > either:
> >
> >   a) leave the file exactly as is, or
> >   b) reduce it to empty
>
> Right.
>
> If it's entirely #ifndef __KERNEL__ then it's a userspace header. It
> probably doesn't live in the kernel source tree at all.
>
> If it's entirely #ifdef __KERNEL__ then it shouldn't be exported at
> all (although when we do that we sometimes have to deal with
> userspace programs which include it even though it's empty).

well, since i already have the output from my script, i might toss
together some per-directory patches to start removing some of that.
this sounds more like a one-shot thing than adding permanent checking
to the build process.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
