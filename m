Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbYCHWUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbYCHWUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 17:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYCHWUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 17:20:35 -0500
Received: from smtp-out.google.com ([216.239.33.17]:19541 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYCHWUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 17:20:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=hTEiSwX766d1XYrxgI/CqHdkuO/BzNJfvHygD3PCh3zzKeWkzQSoJizeJETqQrL5r
	WXpaQ99a+uxdBoH5qx1zQ==
Date: Sat, 8 Mar 2008 14:20:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 2/2] mempolicy: use default_policy mode instead of
 MPOL_DEFAULT
In-Reply-To: <1205003580.4918.21.camel@localhost>
Message-ID: <alpine.DEB.1.00.0803081414460.12095@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803071720460.4611@chino.kir.corp.google.com>  <alpine.DEB.1.00.0803071722170.4611@chino.kir.corp.google.com>  <20080307192845.0492c6f9.pj@sgi.com>  <alpine.DEB.1.00.0803071730340.6241@chino.kir.corp.google.com>
 <1205003580.4918.21.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2008, Lee Schermerhorn wrote:

> I have a patch queued up, waiting for things to settle down in
> mempolicy.c, to replace the policy/mode in default_policy with
> MPOL_PREFERRED with preferred_node = -1.  Then, we can remove all of the
> MPOL_DEFAULT cases out of the switches in the allocation paths and
> "clean up" the documentation, including man pages.  MPOL_DEFAULT becomes
> simply an API mechanism to request fall back to the surrounding policy
> scope which, to my mind, is what "default policy" means.
> 

Ok, I'll await your patch that switches default_policy.policy to 
MPOL_PREFERRED.

Using MPOL_DEFAULT purely for falling back to the task or system-wide 
policy, however, seems confusing.  The semantics seem to indicate that 
MPOL_DEFAULT represents the system-wide default policy without any 
preferred node or set of nodes to bind or interleave.  So if a VMA has a 
policy of MPOL_DEFAULT then, to me, it seems like that indicates the 
absence of a specific policy, not a mandate to fallback to the task 
policy.
