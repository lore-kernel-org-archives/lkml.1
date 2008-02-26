Return-Path: <linux-kernel-owner+w=401wt.eu-S1765029AbYBZVy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765029AbYBZVy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762354AbYBZVyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:54:49 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16576 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762767AbYBZVys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:54:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=um8iR2++pErYI1AcZNrUvdOrSths3kPpu9M4qlEa8j8hTHydL7sCuyVf8fzSTdNDa
	F8Xtwf22GGkJ64C+v3Y1g==
Date: Tue, 26 Feb 2008 13:54:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <1204061567.5309.42.camel@localhost>
Message-ID: <alpine.DEB.1.00.0802261345060.10790@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>  <20080226115627.681dafb9.pj@sgi.com> 
 <alpine.DEB.1.00.0802261253510.10790@chino.kir.corp.google.com> <1204061567.5309.42.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Lee Schermerhorn wrote:

> > This is a natural implementation detail to accomodate your insistance that 
> > the mode and flags be passed as separate actuals throughout many of the 
> > mm/mempolicy.c functions.
> 
> [:-(]
> 

I know, I know :)

It became such an elaborate discussion here that I really didn't want the 
entire patchset, which adds a lot of power for cpuset-constrained 
applications using mempolicies, to stall on it.

I'm not opposed to adding comments in certain places or changing the name 
of an automatic variable, but that's been the degree of review that these 
patches have had.

> > It becomes rather obvious what they represent when you read the entire 
> > sys_mbind() implementation, which is serving a syscall that provides its 
> > own formal for passing flags.  The name 'mode_flags' is exactly what it 
> > is: flags for the mempolicy mode.
> 
> Not to be confused with the MPOL_MF_* flags which are MemPOLicy Mbind
> Flags passed via the flags parameter.  Nor the other MPOL_F_* flags
> which are get_mempolicy() flags, also passed via the flags arg.
> 

Notice in patch 2 of the series where I add the flags member to struct 
mempolicy:

	+	unsigned short flags;	/* See set_mempolicy() MPOL_F_* above */

I had to explicitly say they were for "set_mempolicy() MPOL_F_*" flags in 
an attempt to separate them from the various get_mempolicy() MPOL_F_* 
flags that already exist.  Instead of simply choosing a different format, 
I felt that MPOL_F_STATIC_NODES, for example, is exactly what userspace 
should use and corresponds well with the existing get_mempolicy() flags.

		David
