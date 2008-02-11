Return-Path: <linux-kernel-owner+w=401wt.eu-S1760460AbYBKUEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbYBKUEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbYBKUEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:04:39 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3333 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbYBKUEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:04:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=iIhi+61s8b7Ofx7PsljShfyj2XqNDfWNCQ7Cqti6kgRL+BmH8+x2sSCn8+w1h3od/
	+LcWApHrts4OkyXu1w1Og==
Date: Mon, 11 Feb 2008 12:02:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
In-Reply-To: <Pine.LNX.4.64.0802111146590.25590@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.1.00.0802111156420.17652@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <Pine.LNX.4.64.0802111131270.24563@schroedinger.engr.sgi.com> <alpine.DEB.1.00.0802111135090.1671@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0802111146590.25590@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Christoph Lameter wrote:

> Then you could follow through with the enum mempolicy thing 
> throughtout. Why not use enum mempolicy in struct mempolicy?
> 

Mempolicy flags, as I implemented them in patch 2 in this series, are not 
integer constants that are enumerated starting at 0.  They are individual 
bits that are shifted a pre-defined length and intersected with the 
enumerated mode.  This allows both the mode and the flags to be stored in 
the same object.

Just because enum mempolicy_mode is the equivalent of passing an int in C 
is irrelevant; its semantics are that the value is coming from enum 
mempolicy_mode.  That includes _only_ the mode itself:

	enum mempolicy_mode {
		MPOL_DEFAULT,
		MPOL_BIND,
		MPOL_PREFERRED,
		MPOL_INTERLEAVE,
		MPOL_MAX,
	};

And changing the policy member of struct mempolicy to 'enum 
mempolicy_mode' instead of 'unsigned short' would increase its size.  Not 
that it matters, since in the third patch I add a whole nodemask_t, but 
it's simply unnecessary.  Right now we have the capacity to store 256 
individual mempolicy modes (we currently use four) and eight mempolicy 
flags with unsigned short.

		David
