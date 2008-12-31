Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYLaWQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYLaWQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYLaWQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:16:20 -0500
Received: from ozlabs.org ([203.10.76.45]:56243 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbYLaWQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:16:20 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel modules (take 4)
Date: Thu, 1 Jan 2009 08:46:12 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Helge Deller <deller@gmx.de>,
       "linux-parisc" <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
References: <4959346E.7060600@gmx.de> <495B5806.3080505@gmx.de> <alpine.LFD.2.00.0812310926450.5086@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812310926450.5086@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901010846.13881.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 January 2009 03:59:36 Linus Torvalds wrote:
> 
> On Wed, 31 Dec 2008, Helge Deller wrote:
> >
> > [PATCH 1/2] module.c: fix module loading failure of large kernel modules
> > 
> > When creating the final layout of a kernel module in memory, allow the
> > module loader to reserve some additional memory in front of a given section.
> > This is currently only needed for the parisc port which needs to put the
> > stub entries there to fulfill the 17/22bit PCREL relocations with large
> > kernel modules like xfs.
> > 
> > Differences of this patch to previous versions:
> > - added weak funtion arch_module_section_size()
> 
> This doesn't work.
> 
> We've had this bug several times now, and one of them just very recently.
> 
> Some gcc versions will inline weak functions if they are in scope

Ah, someone hit this elsewhere and thought this was an arch-specific bug.
Any chance we can just kill those compiler versions and move on with our
lives?  4.1.3 definitely doesn't have the problem.

> We don't write out that whole "__attribute__" crud.

I think what you mean is "I prefer __weak".  Which is fine, and not
trivially disprovable by grep.

It's a gratuitous kernelism, but it's an inoffensive one.
Rusty.
