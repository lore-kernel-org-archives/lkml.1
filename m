Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbYBESTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbYBESTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYBESTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:19:31 -0500
Received: from relay1.sgi.com ([192.48.171.29]:44415 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753792AbYBESTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:19:30 -0500
Date: Tue, 5 Feb 2008 10:19:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/6] mmu_notifier: Core code
In-Reply-To: <20080205180557.GC29502@shadowen.org>
Message-ID: <Pine.LNX.4.64.0802051017520.11705@schroedinger.engr.sgi.com>
References: <20080128202840.974253868@sgi.com> <20080128202923.609249585@sgi.com>
 <20080205180557.GC29502@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Andy Whitcroft wrote:

> > +	if (unlikely(!hlist_empty(&mm->mmu_notifier.head))) {
> > +		rcu_read_lock();
> > +		hlist_for_each_entry_safe_rcu(mn, n, t,
> > +					  &mm->mmu_notifier.head, hlist) {
> > +			if (mn->ops->release)
> > +				mn->ops->release(mn, mm);
> 
> Does this ->release actually release the 'nm' and its associated hlist?
> I see in this thread that this ordering is deemed "use after free" which
> implies so.

Right that was fixed in a later release and discussed extensively later. 
See V5.

> I am not sure it makes sense to add a _safe_rcu variant.  As I understand
> things an _safe variant is used where we are going to remove the current

It was dropped in V5.

