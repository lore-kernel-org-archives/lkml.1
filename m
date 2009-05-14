Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbZENUjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbZENUjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbZENUiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:38:52 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56988 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbZENUiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:38:51 -0400
Subject: Re: Misleading OOM messages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0905141546040.1381@qirst.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0905121708470.14226@qirst.com>
	 <20090514092909.GG1365@ucw.cz>
	 <alpine.DEB.1.10.0905141546040.1381@qirst.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 13:38:39 -0700
Message-Id: <1242333519.15391.210.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 15:46 -0400, Christoph Lameter wrote:
> On Thu, 14 May 2009, Pavel Machek wrote:
> > It can be 'low on memory' if you play with mlock() a bit.
> 
> But that is a reclaim failure becuase of mlocking pages.
> 
> > It is out of memory if you run out of swap (or have no swap to begin with).
> 
> That is a swap config issue.

The other thing that I find confusing myself is that we're almost never
at '0 pages free' (which is what I intrinsically think) when we OOM.
We're just under the watermarks and not apparently making any progress.
But I don't think we want to say "under the watermarks" in our error
message.

> > I believe message is often correct. What message would you suggest?
> 
> "Failure to reclaim memory"

The problem I have with that is that it also doesn't tell the whole.
story.  It's the end symptom when *just* before we OOM, but it doesn't
characterize the whole thing very well.  It's like saying the Titanic
sunk because "too much water onboard." :)  It's true, but it
concentrates a bit too much on the end state.

To me, it's a question of how much information we can get out in a line
or two on the console.  Is something like this better?
        
        "Unable to satisfy memory allocation request and not making
        progress reclaiming from other sources."

We can't exactly go spitting out an entire tutorial in dmesg, but could
we stick a short URL in there?  Like http://linux-mm.org/OOM perhaps?

-- Dave

