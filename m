Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbZKEVEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbZKEVEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 16:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758894AbZKEVEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 16:04:46 -0500
Received: from smtp4.ultrahosting.com ([74.213.175.253]:51380 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758656AbZKEVEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 16:04:46 -0500
Date: Thu, 5 Nov 2009 16:03:39 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Andi Kleen <andi@firstfloor.org>
cc: npiggin@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: Subject: [RFC MM] mmap_sem scaling: Use mutex and percpu counter
 instead
In-Reply-To: <87r5sc7kst.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.1.10.0911051558220.7668@V090114053VZO-1>
References: <alpine.DEB.1.10.0911051417370.24312@V090114053VZO-1> <alpine.DEB.1.10.0911051419320.24312@V090114053VZO-1> <87r5sc7kst.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, Andi Kleen wrote:

> I'm not sure making all writers more expensive is really a good idea.

The scaling problems that I have seen (like simple concurrent page faults)
are due to lock contention on mmap_sem and due to counter updates in
mm_struct.

> For example it will definitely impact the AIM7 multi brk() issue
> or the mysql allocation case, which are all writer intensive. I assume
> doing a lot of mmaps/brks in parallel is not that uncommon.

No its not that common. Page faults are much more common. The AIM7 seems
to be an artificial case? What does mysql do for allocation? If its brk()
related then simply going to larger increases may fix the issue??

> My thinking was more that we simply need per VMA locking or
> some other per larger address range locking. Unfortunately that
> needs changes in a lot of users that mess with the VMA lists
> (perhaps really needs some better abstractions for VMA list management
> first)

We have range locking through the distribution of the ptl for systems with
more than 4 processors. One can use that today to lock ranges of the
address space.
