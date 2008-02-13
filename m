Return-Path: <linux-kernel-owner+w=401wt.eu-S1764027AbYBMEE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764027AbYBMEE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 23:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbYBMEEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 23:04:50 -0500
Received: from smtp-out.google.com ([216.239.45.13]:48596 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbYBMEEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 23:04:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=AsEAlHObWoxXiOBpr3QOweL5zA4fc033daevKOMlpT+u9IWjTPA4qlP5PQmkOn6VX
	m19+4jY4KaQWpDm58Jxjw==
Date: Tue, 12 Feb 2008 20:03:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, akpm@linux-foundation.org,
       clameter@sgi.com, ak@suse.de, linux-kernel@vger.kernel.org,
       mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <20080212215242.0342fa25.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <1202862136.4974.41.camel@localhost>
 <20080212215242.0342fa25.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Paul Jackson wrote:

> > 1) we've discussed the issue of returning EINVAL for non-empty nodemasks
> > with MPOL_DEFAULT.  By removing this restriction, we run the risk of
> > breaking applications if we should ever want to define a semantic to
> > non-empty node mask for MPOL_DEFAULT. 
> 
> The bigger risk, in my view, is breaking some piece of existing user code.
> Properly written user code wouldn't break, but that doesn't mean much.
> Changes, even minor corner case changes, often break something, so should
> not be done with out cause.  Whether or not code cleanup in mempolicy.c is
> sufficient cause here is not clear to me.
> 
> Future room for growth doesn't mean so much for me here; if we close one
> future alternative, we always have others, such as more mode flag bits.
> 

I've redone my patchset based on the feedback that I've received, and in 
my latest revisions I folded the entire equivalent of mpol_check_policy() 
into mpol_new().

Lee, you feel strongly that non-empty nodemasks passed with MPOL_DEFAULT 
should be considered invalid and rejected by the kernel, as the current 
implementation does.  I've brought up a counter-argument based on the 
set_mempolicy() man page and the Linux documentation that don't specify 
anything about what the nodemask shall contain if it's not a NULL pointer.

My position was to give the user the benefit of the doubt.  Because Linux 
has been vague in specifying what the nodemask shall contain, that (to me) 
means that it can contain anything.  It's undefined, in a standards sense.  
The only thing that we should look for is whether the user passed 
MPOL_DEFAULT as the first parameter and then we should effect that policy 
because it's clearly the intention.

I don't think there's a super strong case for either behavior, and that's 
why I just folded the mpol_check_policy() logic straight into mpol_new().  

		David
