Return-Path: <linux-kernel-owner+w=401wt.eu-S932559AbYBNVj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbYBNVj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYBNVjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:39:20 -0500
Received: from smtp-out.google.com ([216.239.33.17]:56745 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbYBNVjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:39:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=QOXpr5huYaSk2AYHF5SsL41cGkn6Uh2UqMcz6YjGubsIHuaoviIW7I3CruxXHp7Go
	OUfHMnS5R+r7XhoKQDnOw==
Date: Thu, 14 Feb 2008 13:38:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <20080214040918.d735e920.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802141336590.6067@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <20080214040918.d735e920.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Paul Jackson wrote:

> In mempolicy.h, the lines:
> 
>     /*
>      * The lower MPOL_FLAG_SHIFT bits of the policy mode represent the MPOL_*
>      * constants defined in enum mempolicy_mode.  The upper bits represent
>      * optional set_mempolicy() MPOL_F_* mode flags.
>      */
>     #define MPOL_FLAG_SHIFT (8)
>     #define MPOL_MODE_MASK  ((1 << MPOL_FLAG_SHIFT) - 1)
> 
>     /* Flags for set_mempolicy */
>     #define MPOL_F_STATIC_NODES     (1 << MPOL_FLAG_SHIFT)
>     #define MPOL_MODE_FLAGS (MPOL_F_STATIC_NODES)   /* legal set_mempolicy() MPOL_* mode flags */
> 
> could be simplified, to:
> 
>     /*
>      * Optional flags that modify nodemask numbering.
>      */
>     #define MPOL_F_RELATIVE_NODES (1<<14)	/* remapped relative to cpuset */
>     #define MPOL_F_STATIC_NODES (1<<15)		/* unremapped physical masks */
>     #define MPOL_MODE_FLAGS (MPOL_F_RELATIVE_NODES|MPOL_F_STATIC_NODES)
>     						/* combined MPOL_F_* mask flags */
> 
> (really, that MPOL_FLAG_SHIFT is just unnecessary distracting detail.)
> 

It would be easy to define mpol_mode() and mpol_flags() in terms of 
MPOL_MODE_FLAGS as well, yes.  But without MPOL_FLAG_SHIFT it becomes 
impossible to determine whether a user passed an invalid flag.

I think we're all in agreement that passing an invalid flag bit should be 
rejected with -EINVAL.  So to do that we need MPOL_MODE_MASK to expicitly 
define the parts of the int *policy passed from set_mempolicy() that 
represent the mode.

		David
