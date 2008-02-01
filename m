Return-Path: <linux-kernel-owner+w=401wt.eu-S1761737AbYBAD6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761737AbYBAD6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 22:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbYBAD6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 22:58:42 -0500
Received: from relay2.sgi.com ([192.48.171.30]:41131 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751324AbYBAD6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 22:58:41 -0500
Date: Thu, 31 Jan 2008 19:58:40 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 1/3] mmu_notifier: Core code
In-Reply-To: <20080201035249.GE26420@sgi.com>
Message-ID: <Pine.LNX.4.64.0801311957250.17649@schroedinger.engr.sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.553249048@sgi.com>
 <20080201035249.GE26420@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Robin Holt wrote:

> > +	void (*invalidate_range_end)(struct mmu_notifier *mn,
> > +				 struct mm_struct *mm, int atomic);
> 
> I think we need to pass in the same start-end here as well.  Without it,
> the first invalidate_range would have to block faulting for all addresses
> and would need to remain blocked until the last invalidate_range has
> completed.  While this would work, (and will probably be how we implement
> it for the short term), it is far from ideal.

Ok. Andrea wanted the same because then he can void the begin callouts.

The problem is that you would have to track the start-end addres right?

