Return-Path: <linux-kernel-owner+w=401wt.eu-S1765149AbYBNTqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765149AbYBNTqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbYBNTpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:45:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:52661 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbYBNTpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:45:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=mF87OI0v4XNpGMdUI+hfeLI6qLcZR2h6EoUD3/FO7zpb7pvIKS+lDVpUsdBePmDIh
	VIZs7Fk8vd7MVo7nm6kKQ==
Date: Thu, 14 Feb 2008 11:45:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <20080214042643.dff40c72.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802141142160.17096@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <1202862136.4974.41.camel@localhost>
 <20080212215242.0342fa25.pj@sgi.com> <alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com> <20080212221354.a33799f2.pj@sgi.com> <alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com> <20080213020344.45c9d924.pj@sgi.com>
 <alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com> <20080213110426.15179378.pj@sgi.com> <alpine.DEB.1.00.0802131050240.9186@chino.kir.corp.google.com> <20080213142956.5ba52101.pj@sgi.com> <20080214042643.dff40c72.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Paul Jackson wrote:

> No and yes.  The manner in which too many nodes (as requested in a
> RELATIVE mask) are folded into too small a cpuset is not actually
> that critical, so long as it doesn't come up empty.  However, what
> I'll be recommending, in a follow-up patch, will be folding the
> larger set into the smaller one modulo the size of the smaller one.
> 

So basically the "relative" nodemask that is passed with 
MPOL_F_RELATIVE_NODES is wrapped around the allowed nodes?

	relative nodemask	mems_allowed	result
	1,3,5			4		4
	1,3,5			4-6		4-6
	1,3,5			4-8		4-5,7
	1,3,5			4-10		4,6,8

Is that correct?

		David
