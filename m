Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbZEDTLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbZEDTLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbZEDTLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:11:15 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50737 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbZEDTLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x71uKYpCqBXsNhHmpRYAesdBrDfeR4MSZNWMerVWCGbQGuhW9tVQ3uB7vVoMoJSXk1
         bF1sLzqsLvhabfTpfK0LecNcJOwtYaF+W4oYtU6ekBIYL6AJC01kRlmJ/l3WZ7UxkhOo
         Rm8bxQ+Q9BBcYL4Jm9wDV79UJUti1K7jxfGTM=
Date: Mon, 4 May 2009 23:11:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
Message-ID: <20090504191111.GA31176@lenovo>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu> <20090504131638.GJ4173@lenovo> <alpine.DEB.1.10.0905040940490.9553@qirst.com> <20090504141256.GK4173@lenovo> <alpine.DEB.1.10.0905041011200.17937@qirst.com> <20090504142903.GM4173@lenovo> <20090504152026.GO4173@lenovo> <alpine.DEB.1.10.0905041148490.10044@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905041148490.10044@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Lameter - Mon, May 04, 2009 at 11:54:53AM -0400]
| On Mon, 4 May 2009, Cyrill Gorcunov wrote:
| 
| > You know I only found a message in case if page is already
| > not granted (ie NULL is going to be returned) and right
| > before that we print a warning about that (nopage: label).
| > Which means - no panic here and with (__GFP_NOFAIL | __GFP_REPEAT)
| > just spinning around in attepmt to allocate new memory. And how
| > to behave on atomic allocations. Almost give up... :)
| 
| Could you check for __GFP_FAIL|__GFP_REPEAT somewheres and panic? Not sure
| if __GFP_REPEAT is the right second flag to use.
| 

Well Christoph I've checked those flags (and though for some
max fail iterations counter as well which was then refused).
None of combination seems to satisfy this requirement (don't
return NULL on out-of-memory but panic instead) in clear way.
There is a question remains opened how to behave on a case if
allocation was atomic. Just dunno.

If it is critical to not bring new __GFP_PANIC then
I could be just using __GFP_NOFAIL and nofity a user via
printk that we're in stage of allocating memory (anyway
it looks strange that we have a number of callers with
__GFP_NOFAIL with BUG_ON/if-checks following. But I could
me missing).

	-- Cyrill
