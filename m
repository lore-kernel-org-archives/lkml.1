Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab0BKVCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:02:11 -0500
Received: from smtp-out.google.com ([216.239.33.17]:23674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab0BKVCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:02:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=CI68IReqrDBY1rSO0NsKaD9QBEvLjlj4sjHOLXQrtqt/WvKzt+EMLRGwaVuZ6QIo/
	ftMuLmXFSLbY2JN7LUMzg==
Date: Thu, 11 Feb 2010 13:01:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Bowler <nbowler@elliptictech.com>
cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 4/7 -mm] oom: badness heuristic rewrite
In-Reply-To: <20100211150712.GA13140@emergent.ellipticsemi.com>
Message-ID: <alpine.DEB.2.00.1002111257300.1461@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100228540.8001@chino.kir.corp.google.com> <4B73833D.5070008@redhat.com> <alpine.DEB.2.00.1002102332200.22152@chino.kir.corp.google.com>
 <20100211150712.GA13140@emergent.ellipticsemi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Nick Bowler wrote:

> > As mentioned in the changelog, we've exported these minimum and maximum 
> > values via a kernel header file since at least 2006.  At what point do we 
> > assume they are going to be used and not hardcoded into applications?  
> > That was certainly the intention when making them user visible.
> 
> The thing is, even when the macros are used, their values are hardcoded
> into programs once the code is run through a compiler.  That's why it's
> called an ABI.
> 

Right, that's the second point that I listed: since the semantics of the 
tunable have radically changed from the bitshift to an actual unit 
(proportion of available memory), those applications need to change how 
they use oom_adj anyway.  The bitshift simply isn't extendable with any 
sane heuristic that is predictable or works with any reasonable amount of 
granularity, so this change seems inevitable in the long term.

We may be forced to abandon /proc/pid/oom_adj itself and introduce the 
tunable with a different name: oom_score_adj, for example, to make it 
clear that it's a different entity.
