Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbYCHBde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbYCHBde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYCHBd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:33:27 -0500
Received: from smtp-out.google.com ([216.239.45.13]:57121 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYCHBd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:33:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=n74pKgIWcgxaTDCVjAjR6CvG5rThuuN6kF9VMKfJeNET+YpjQ7vYkBUnacAkQ/ogT
	NW/gCREWSn/s+70v+cumQ==
Date: Fri, 7 Mar 2008 17:33:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 2/2] mempolicy: use default_policy mode instead of
 MPOL_DEFAULT
In-Reply-To: <20080307192845.0492c6f9.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0803071730340.6241@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803071720460.4611@chino.kir.corp.google.com> <alpine.DEB.1.00.0803071722170.4611@chino.kir.corp.google.com> <20080307192845.0492c6f9.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Paul Jackson wrote:

> > So instead of checking for comparisons against a mempolicy's mode to
> > MPOL_DEFAULT or falling back stricly to MPOL_DEFAULT throughout the code,
> > we should use the mode that is defined in this struct.
> 
> Is this just a stylistic choice?  That is, is the same machine
> code produced either way?
> 
> If that's the case, could you briefly explain why you prefer
> one style (default_policy.policy) over the other (MPOL_DEFAULT)?
> 

Very fast response!

Yes, the same code is generated since default_policy.policy is statically 
declared as MPOL_DEFAULT.

I chose this because checks in mpol_new() to return NULL if the mode is 
MPOL_DEFAULT is purely based on the fact that, as the default system 
policy, policy task or VMA pointers are set to &default_policy.
