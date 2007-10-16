Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbXJPCYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbXJPCYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 22:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbXJPCYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 22:24:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38987 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbXJPCYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 22:24:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=NIp0oY9JXSyL33Weq8uLbN9RKQqyS2v4uzn1OHw6soewbJWFRmYTIOIiyQCCTxub3
	M6V/5npYcVZbLSHs9U/Hw==
Date: Mon, 15 Oct 2007 19:24:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 1/11] maps3: add proportional set size accounting in
 smaps
In-Reply-To: <20071016001850.GA19691@waste.org>
Message-ID: <alpine.DEB.0.9999.0710151917060.11508@chino.kir.corp.google.com>
References: <2.290135367@selenic.com> <alpine.DEB.0.9999.0710151633150.16611@chino.kir.corp.google.com> <20071016001850.GA19691@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Matt Mackall wrote:

> > The pss is going to need accessor functions, preferably inlined, and the 
> > comment adjusted stating that all accesses should be through those 
> > functions and not directly to the mem_size_stats struct.
> > 
> > 	static inline u64 pss_up(unsigned long pss)
> > 	{
> > 		return pss << PSS_DIV_BITS;
> > 	}
> > 
> > 	static inline unsigned long pss_down(u64 pss)
> > 	{
> > 		return pss >> PSS_DIV_BITS;
> > 	}
> 
> I think that's overkill for something that has exactly one use of each.
> 

There's no overkill at all, the current uses are already accessed with 
these bitshifts so there's no overhead when using an inlined function 
instead.

To correctly access the pss, these bitshifts are required because the 
decision was made to use the lower PSS_DIV_BITS for rounding.  Thus, you 
need to include accessor functions so that they are always accessed 
correctly now and in the future.

		David
