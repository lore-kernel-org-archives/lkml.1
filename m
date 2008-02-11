Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbYBKTtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbYBKTtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760261AbYBKTtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:49:00 -0500
Received: from relay2.sgi.com ([192.48.171.30]:47361 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760203AbYBKTs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:48:59 -0500
Date: Mon, 11 Feb 2008 11:48:59 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
In-Reply-To: <alpine.DEB.1.00.0802111135090.1671@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0802111146590.25590@schroedinger.engr.sgi.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0802111131270.24563@schroedinger.engr.sgi.com>
 <alpine.DEB.1.00.0802111135090.1671@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, David Rientjes wrote:

> > The second paragraphs seems to indicate that such an approach does not 
> > work since we also use MPOL_xx constants to set flags in the memory 
> > policies?
> > 
> 
> Not sure I'm understanding your question, sorry.
> 
> Mempolicy modes have always been int constants because it doesn't make 
> sense to combine them.  Putting them into 'enum mempolicy_mode' leaves 
> that unchanged.

> Mempolicy flags can be combined (even though my patchset only currently 
> implements one, it's easy to implement others).  So they definitely cannot 
> be enum constants.

> Regardless, storing the policy (mode | flags) in struct mempolicy as a 
> 'short' doesn't help since a negative policy doesn't mean anything.  In 
> preparation for allowing the upper MPOL_FLAG_SHIFT bits to be used to 
> store the flags of this member, I converted it to 'unsigned short'.  This 
> is because the API with userspace is through 'int', which is implicitly 
> signed, and we don't want to sign-extend the upper bit if it's ever used 
> to hold a mempolicy flag.

Then you could follow through with the enum mempolicy thing 
throughtout. Why not use enum mempolicy in struct mempolicy?


