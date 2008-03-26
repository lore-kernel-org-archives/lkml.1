Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbYCZMxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbYCZMxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 08:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbYCZMxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 08:53:41 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:52966 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbYCZMxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 08:53:40 -0400
Date: Wed, 26 Mar 2008 08:53:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: David Woodhouse <dwmw2@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why so many unexported headers checking __KERNEL__?
In-Reply-To: <1206533324.9540.268.camel@pmac.infradead.org>
Message-ID: <alpine.LFD.1.00.0803260846390.6148@localhost.localdomain>
References: <alpine.LFD.1.00.0803230229530.1203@localhost.localdomain> <1206533324.9540.268.camel@pmac.infradead.org>
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

> On Sun, 2008-03-23 at 02:31 -0400, Robert P. J. Day wrote:
> >
> >   as an unintended side effect of checking for proper exporting to
> > user space and unifdef'ing, i noticed that there are literally
> > hundreds of kernel header files that check the value of __KERNEL__
> > in some way, but are never exported to user space.  what's the
> > point of that?  thanks.
>
> There's no point -- we just haven't got round to removing it yet.
>
> We should probably make headers_check or some other automated check
> catch these two cases:
>
> If a header is exported by header-y or not exported at all, it shouldn't
> contain any #ifdef __KERNEL__.
>
> And if it's exported and doesn't contain any #ifdef __KERNEL__, it
> should be header-y not unifdef-y (and that's the case we should be
> moving towards, by cleaning up headers to have separate files for
> the user-visible parts).

not surprisingly, the only reason i noticed the above was because i
hacked together a short script that went looking for all of the above
and i was surprised at the number of files it identified.  (i've
already submitted a few patches to clean up the obviously erroneous
cases, like being miscategorized or being in both categories at once
so, after the next merge window, those should all be gone.)

rday

p.s. the other case that could be identified is when a header file has
its *entire* contents encased in a __KERNEL__ test, (either ifdef or
ifndef).  AFAICT, unless that kind of test is partitioning *some* of a
header file content from the remainder, there's little value in a
__KERNEL__test if the end result is to either:

  a) leave the file exactly as is, or
  b) reduce it to empty

--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
