Return-Path: <linux-kernel-owner+w=401wt.eu-S1759976AbYBKTpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbYBKTpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbYBKTp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:45:28 -0500
Received: from smtp-out.google.com ([216.239.45.13]:2077 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbYBKTp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:45:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=ZAL8PENCIBI+R3KPotSOdLV/8Fh9xReX5C0F23dzJ91sFM1Uf0jlD3CvOAUwSZFWG
	BaTcQXJ6Y3kwRTytWJLqw==
Date: Mon, 11 Feb 2008 11:40:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
In-Reply-To: <Pine.LNX.4.64.0802111131270.24563@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.1.00.0802111135090.1671@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <Pine.LNX.4.64.0802111131270.24563@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Christoph Lameter wrote:

> > The policy member of struct mempolicy is also converted from type short
> > to type unsigned short.  A negative policy does not have any legitimate
> > meaning, so it is possible to change its type in preparation for adding
> > optional mode flags later.
> 
> The second paragraphs seems to indicate that such an approach does not 
> work since we also use MPOL_xx constants to set flags in the memory 
> policies?
> 

Not sure I'm understanding your question, sorry.

Mempolicy modes have always been int constants because it doesn't make 
sense to combine them.  Putting them into 'enum mempolicy_mode' leaves 
that unchanged.

Mempolicy flags can be combined (even though my patchset only currently 
implements one, it's easy to implement others).  So they definitely cannot 
be enum constants.

Regardless, storing the policy (mode | flags) in struct mempolicy as a 
'short' doesn't help since a negative policy doesn't mean anything.  In 
preparation for allowing the upper MPOL_FLAG_SHIFT bits to be used to 
store the flags of this member, I converted it to 'unsigned short'.  This 
is because the API with userspace is through 'int', which is implicitly 
signed, and we don't want to sign-extend the upper bit if it's ever used 
to hold a mempolicy flag.

		David
