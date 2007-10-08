Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbXJHRgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbXJHRgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbXJHRgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:36:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56751 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755073AbXJHRgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:36:43 -0400
Date: Mon, 8 Oct 2007 10:36:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Rik van Riel <riel@redhat.com>, Andi Kleen <ak@suse.de>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [13/18] x86_64: Allow fallback for the stack
In-Reply-To: <200710071735.41386.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0710081032030.26382@schroedinger.engr.sgi.com>
References: <20071004035935.042951211@sgi.com> <20071004153940.49bd5afc@bree.surriel.com>
 <Pine.LNX.4.64.0710041418100.12779@schroedinger.engr.sgi.com>
 <200710071735.41386.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2007, Nick Piggin wrote:

> > The problem can become non-rare on special low memory machines doing wild
> > swapping things though.
> 
> But only your huge systems will be using huge stacks?

I have no idea who else would be using such a feature. Relaxing the tight 
memory restrictions on stack use may allow placing larger structures on 
the stack in general.

I have some concerns about the medium NUMA systems (a few dozen of nodes) 
also running out of stack since more data is placed on the stack through 
the policy layer and since we may end up with a couple of stacked 
filesystems. Most of the current NUMA systems on x86_64 are basically 
two nodes on one motherboard. The use of NUMA controls is likely 
limited there and the complexity of the filesystems is also not high.


