Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbXJISjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbXJISjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXJISjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:39:23 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38841 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753080AbXJISjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:39:23 -0400
Date: Tue, 9 Oct 2007 11:39:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Rik van Riel <riel@redhat.com>, Andi Kleen <ak@suse.de>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [13/18] x86_64: Allow fallback for the stack
In-Reply-To: <200710082255.05598.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0710091138250.32162@schroedinger.engr.sgi.com>
References: <20071004035935.042951211@sgi.com> <200710071735.41386.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0710081032030.26382@schroedinger.engr.sgi.com>
 <200710082255.05598.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2007, Nick Piggin wrote:

> The tight memory restrictions on stack usage do not come about because
> of the difficulty in increasing the stack size :) It is because we want to
> keep stack sizes small!
> 
> Increasing the stack size 4K uses another 4MB of memory for every 1000
> threads you have, right?
> 
> It would take a lot of good reason to move away from the general direction
> we've been taking over the past years that 4/8K stacks are a good idea for
> regular 32 and 64 bit builds in general.

We already use 32k stacks on IA64. So the memory argument fail there.

> > I have some concerns about the medium NUMA systems (a few dozen of nodes)
> > also running out of stack since more data is placed on the stack through
> > the policy layer and since we may end up with a couple of stacked
> > filesystems. Most of the current NUMA systems on x86_64 are basically
> > two nodes on one motherboard. The use of NUMA controls is likely
> > limited there and the complexity of the filesystems is also not high.
> 
> The solution has until now always been to fix the problems so they don't
> use so much stack. Maybe a bigger stack is OK for you for 1024+ CPU
> systems, but I don't think you'd be able to make that assumption for most
> normal systems.

Yes that is why I made the stack size configurable.

