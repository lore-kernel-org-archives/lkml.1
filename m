Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZEDTfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZEDTfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbZEDTf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:35:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:16469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbZEDTf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:35:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KlTclB+RarlXssmTAOTD7uLwDZVhcx4TNahB4vobeAIU+cOqOwRSt81xeUEp2dKtFR
         486k3ModocBae42j5BPCzlLSCb+DCChKMg/jNCBPt/0in+Q6EqUtNBzQeEyvmgBGsaqI
         RaXfzJCM2/bBtxf2wGB2lhPbZTeVuy+ZgKc9s=
Date: Mon, 4 May 2009 23:35:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
Message-ID: <20090504193526.GC31176@lenovo>
References: <20090504122740.GH4173@lenovo> <20090504192342.GA19481@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504192342.GA19481@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Mel Gorman - Mon, May 04, 2009 at 08:23:43PM +0100]
| On Mon, May 04, 2009 at 04:27:40PM +0400, Cyrill Gorcunov wrote:
| > Hi,
| > 
| > here is an attempt to bring in __GFP_PANIC modifier.
| > The patch is made on top of -tip repo. I've been
| > trying to apply it in top of -mm tree but it
| > seems -tip is a bit newer, at least it already
| > has __GFP_BITS_SHIFT = 22 defined.
| > 
| > Mel, could you take a look?
| > 
| 
| I'm not seeing any users of the new flag so I'm not sure what your intended
| use for the flag is.  Maybe it would have a small saving on call-sites that
| panic but as they are boot-time functions, I would expect the memory is
| getting freed anyway.

Yes they are boot-time, UV apic init at moment (already fixed via BUG_ON).
But I already noticed by Christoph that it's not a good idea to bring
this flag in. Sorry for bothering.

| 
| If this is about should_failslab(), can it be determined that we should not
| fail another way? For example, never randomly fail the allocation if the
| system is booting and __GFP_NOFAIL is specified.
| 
| > For easier review -- here is what is done:
| > 1) __GFP_PANIC introduced
| > 2) __alloc_pages_internal now checks for this flag
| >    and panic if needed.
| > 
| > 	-- Cyrill
