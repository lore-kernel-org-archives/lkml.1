Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZENUuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZENUuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZENUtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:49:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4463 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZENUtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:49:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=qQ9gRXBmg8bhWQC160jgGoKFww7T2CSMEdqkEXgMAFynddlYPDRUJlXCLRpYv8jG6
	A3spCupPkFtx765EOc8aw==
Date: Thu, 14 May 2009 13:49:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Christoph Lameter <cl@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
In-Reply-To: <1242333519.15391.210.camel@nimitz>
Message-ID: <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com> <alpine.DEB.1.10.0905121708470.14226@qirst.com> <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com>
 <1242333519.15391.210.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Dave Hansen wrote:

> The problem I have with that is that it also doesn't tell the whole.
> story.  It's the end symptom when *just* before we OOM, but it doesn't
> characterize the whole thing very well.  It's like saying the Titanic
> sunk because "too much water onboard." :)  It's true, but it
> concentrates a bit too much on the end state.
> 
> To me, it's a question of how much information we can get out in a line
> or two on the console.  Is something like this better?
>         
>         "Unable to satisfy memory allocation request and not making
>         progress reclaiming from other sources."
> 
> We can't exactly go spitting out an entire tutorial in dmesg, but could
> we stick a short URL in there?  Like http://linux-mm.org/OOM perhaps?
> 

I think switching all the oom killer messages to be "no available memory" 
as it is in the MPOL_BIND case would be the best alternative.  We 
currently use "out of memory" even for cpusets, for example, when it 
happens because it cannot accommodate any more hardwall allocations while 
there may be an abundance of memory elsewhere that it cannot access.  I 
also think "no available memory" makes more sense than "out of memory" 
when describing situations where we're at or below the minimum watermarks 
for all allowable zones.  Either that or "no allowable memory".
