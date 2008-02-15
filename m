Return-Path: <linux-kernel-owner+w=401wt.eu-S1763969AbYBOBos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763969AbYBOBos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 20:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYBOBoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 20:44:37 -0500
Received: from smtp-out.google.com ([216.239.33.17]:7259 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542AbYBOBof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 20:44:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=eH/AJ4KhOd01mMzUU9DfuUFVyASHkmMw7BXHTGVQAqyDH79wN3rw/ioz9mhb6K26R
	pxXwl6OD+itX+n47ZvI3Q==
Date: Thu, 14 Feb 2008 17:44:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <alpine.DEB.1.00.0802141135110.17096@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0802141739050.16945@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <20080214040918.d735e920.pj@sgi.com>
 <alpine.DEB.1.00.0802141135110.17096@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, David Rientjes wrote:

> We'll need to decide whether mpol_equal() is determining the equality of 
> the currently effected mempolicy (whereas policy->user_nodemask is 
> irrelevant) or the whole intended mempolicy overall.
> 

I've done the latter in the latest patchset.

Since mpol_equal() is only used for determining whether nearby vmas can be 
merged, it is only logical to merge them if they share the mempolicy 
intent of the user if MPOL_F_STATIC_NODES or any flag that makes sense of 
policy->user_nodemask is used.

> > Could we have mpol_to_str() mark policies which are
> > MPOL_F_RELATIVE_NODES or MPOL_F_STATIC_NODES?  Perhaps
> > by adding a suffix of "|relative" or "|static" or some
> > such.
> > 
> 
> I'd like to keep it in the same format as the tmpfs mount option which is 
> '=relative' and '=static'.
> 

In preparation for mode flags in addition to MPOL_F_STATIC_NODES to be 
added (like MPOL_F_RELATIVE_NODES or whatever Paul decides to call it 
based on the latest feedback, I've prepared mpol_to_str() to have this 
format

	interleave=static|relative=1-3

as viewable from /proc/pid/numa_maps.  This is also how tmpfs mount 
options will be specified.

 [ Of course the above example can't happen since MPOL_F_STATIC_NODES and
   MPOL_F_RELATIVE_NODES are disjoint, but it's sufficient for the
   example. ]
