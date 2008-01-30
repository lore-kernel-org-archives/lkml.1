Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYA3WUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYA3WUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbYA3WUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:20:37 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57161 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386AbYA3WUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:20:37 -0500
Date: Wed, 30 Jan 2008 16:20:35 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>, Andrea Arcangeli <andrea@qumranet.com>,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/6] mmu_notifier: Core code
Message-ID: <20080130222035.GX26420@sgi.com>
References: <20080130022909.677301714@sgi.com> <20080130022944.236370194@sgi.com> <20080130153749.GN7233@v2.random> <20080130155306.GA13746@sgi.com> <Pine.LNX.4.64.0801301116510.27491@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801301116510.27491@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 11:19:28AM -0800, Christoph Lameter wrote:
> On Wed, 30 Jan 2008, Jack Steiner wrote:
> 
> > Moving to a different lock solves the problem.
> 
> Well it gets us back to the issue why we removed the lock. As Robin said 
> before: If its global then we can have a huge number of tasks contending 
> for the lock on startup of a process with a large number of ranks. The 
> reason to go to mmap_sem was that it was placed in the mm_struct and so we 
> would just have a couple of contentions per mm_struct.
> 
> I'll be looking for some other way to do this.

I think Andrea's original concept of the lock in the mmu_notifier_head
structure was the best.  I agree with him that it should be a spinlock
instead of the rw_lock.

Thanks,
Robin
