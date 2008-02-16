Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYBPT2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYBPT2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758260AbYBPT2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:28:10 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40007 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756863AbYBPT2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:28:09 -0500
Date: Sat, 16 Feb 2008 11:28:08 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 5/6] mmu_notifier: Support for drivers with revers maps
 (f.e. for XPmem)
In-Reply-To: <20080215193746.5d823092.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802161126560.25573@schroedinger.engr.sgi.com>
References: <20080215064859.384203497@sgi.com> <20080215064933.376635032@sgi.com>
 <20080215193746.5d823092.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, Andrew Morton wrote:

> > +#define mmu_rmap_notifier(function, args...)				\
> > +	do {								\
> > +		struct mmu_rmap_notifier *__mrn;			\
> > +		struct hlist_node *__n;					\
> > +									\
> > +		rcu_read_lock();					\
> > +		hlist_for_each_entry_rcu(__mrn, __n,			\
> > +				&mmu_rmap_notifier_list, hlist)		\
> > +			if (__mrn->ops->function)			\
> > +				__mrn->ops->function(__mrn, args);	\
> > +		rcu_read_unlock();					\
> > +	} while (0);
> > +
> 
> buggy macro: use locals.

Ok. Same as the non rmap version.

> > +EXPORT_SYMBOL(mmu_rmap_export_page);
> 
> The other patch used EXPORT_SYMBOL_GPL.

Ok will make that consistent.


