Return-Path: <linux-kernel-owner+w=401wt.eu-S1760556AbYAYVT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbYAYVT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbYAYVTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:19:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:52370 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940AbYAYVTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:19:49 -0500
Subject: Re: [patch 0/4] [RFC] MMU Notifiers V1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20080125114229.GA7454@v2.random>
References: <20080125055606.102986685@sgi.com>
	 <20080125114229.GA7454@v2.random>
Content-Type: text/plain
Date: Sat, 26 Jan 2008 08:18:41 +1100
Message-Id: <1201295921.6815.150.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-25 at 12:42 +0100, Andrea Arcangeli wrote:
> On Thu, Jan 24, 2008 at 09:56:06PM -0800, Christoph Lameter wrote:
> > Andrea's mmu_notifier #4 -> RFC V1
> > 
> > - Merge subsystem rmap based with Linux rmap based approach
> > - Move Linux rmap based notifiers out of macro
> > - Try to account for what locks are held while the notifiers are
> >   called.
> > - Develop a patch sequence that separates out the different types of
> >   hooks so that it is easier to review their use.
> > - Avoid adding #include to linux/mm_types.h
> > - Integrate RCU logic suggested by Peter.
> 
> I'm glad you're converging on something a bit saner and much much
> closer to my code, plus perfectly usable by KVM optimal rmap design
> too. It would have preferred if you would have sent me patches like
> Peter did for review and merging etc... that would have made review
> especially easier. Anyway I'm used to that on lkml so it's ok, I just
> need this patch to be included in mainline, everything else is
> irrelevant to me.

Also, wouldn't there be a problem with something trying to use that
interface to keep in sync a secondary device MMU such as the DRM or
other accelerators, which might need virtual address based
invalidation ?

Ben.


