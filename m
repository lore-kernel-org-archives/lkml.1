Return-Path: <linux-kernel-owner+w=401wt.eu-S1761950AbXJDVUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761950AbXJDVUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758974AbXJDVUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:20:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59149 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758440AbXJDVUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:20:20 -0400
Date: Thu, 4 Oct 2007 14:20:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: Andi Kleen <ak@suse.de>, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [13/18] x86_64: Allow fallback for the stack
In-Reply-To: <20071004153940.49bd5afc@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0710041418100.12779@schroedinger.engr.sgi.com>
References: <20071004035935.042951211@sgi.com> <20071004040004.708466159@sgi.com>
 <200710041356.51750.ak@suse.de> <Pine.LNX.4.64.0710041220010.12075@schroedinger.engr.sgi.com>
 <20071004153940.49bd5afc@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007, Rik van Riel wrote:

> > Well we can now address the rarity. That is the whole point of the 
> > patchset.
> 
> Introducing complexity to fight a very rare problem with a good
> fallback (refusing to fork more tasks, as well as lumpy reclaim)
> somehow does not seem like a good tradeoff.

The problem can become non-rare on special low memory machines doing wild 
swapping things though.

> > It will be more common if the stack size is increased beyond 8k.
> 
> Why would we want to do such a thing?

Because NUMA requires more stack space. In particular support for very 
large cpu configurations of 16k may require 2k cpumasks on the stack.
 
> 8kB stacks are large enough...

For many things yes. I just want to have the compile time option to 
increase it.
