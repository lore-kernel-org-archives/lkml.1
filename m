Return-Path: <linux-kernel-owner+w=401wt.eu-S1761923AbYBAEP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761923AbYBAEP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYBAEPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:15:16 -0500
Received: from relay1.sgi.com ([192.48.171.29]:55228 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316AbYBAEPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:15:15 -0500
Date: Thu, 31 Jan 2008 22:15:13 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Andrea Arcangeli <andrea@qumranet.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 1/3] mmu_notifier: Core code
Message-ID: <20080201041512.GF26420@sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.553249048@sgi.com> <20080201035249.GE26420@sgi.com> <Pine.LNX.4.64.0801311957250.17649@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801311957250.17649@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 07:58:40PM -0800, Christoph Lameter wrote:
> On Thu, 31 Jan 2008, Robin Holt wrote:
> 
> > > +	void (*invalidate_range_end)(struct mmu_notifier *mn,
> > > +				 struct mm_struct *mm, int atomic);
> > 
> > I think we need to pass in the same start-end here as well.  Without it,
> > the first invalidate_range would have to block faulting for all addresses
> > and would need to remain blocked until the last invalidate_range has
> > completed.  While this would work, (and will probably be how we implement
> > it for the short term), it is far from ideal.
> 
> Ok. Andrea wanted the same because then he can void the begin callouts.
> 
> The problem is that you would have to track the start-end addres right?

Yep.  We will probably no do that in the next week, but I would expect
we have that working before we submit xpmem again.  We will probably
just chain them up in a regular linked list.

Thanks,
Robin
