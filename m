Return-Path: <linux-kernel-owner+w=401wt.eu-S932973AbXBPHUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbXBPHUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932985AbXBPHUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:20:46 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56379 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973AbXBPHUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:20:45 -0500
Date: Thu, 15 Feb 2007 23:19:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 11/21] Xen-paravirt: Add apply_to_page_range() which
 applies a function to a pte range.
Message-Id: <20070215231936.073fadd3.akpm@linux-foundation.org>
In-Reply-To: <45D55805.908@goop.org>
References: <20070216022449.739760547@goop.org>
	<20070216022531.344125142@goop.org>
	<20070215223727.6819f962.akpm@linux-foundation.org>
	<45D55805.908@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 23:06:45 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > On Thu, 15 Feb 2007 18:25:00 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >   
> >> Add a new mm function apply_to_page_range()[...]
> > There was some discussion about this sort of thing last week.  The
> > consensus was that it's better to run the callback against a whole pmd's
> > worth of ptes, mainly to amortise the callback's cost (a lot).
> >
> > It was implemented in
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm1/broken-out/smaps-extract-pmd-walker-from-smaps-code.patch
> 
> Yes I was looking at that and wondering what the upshot would be.  I'll
> have a closer look, but it seems like it should be usable.

It's a question of who-merges-first.  I wasn't planning on merging the
smaps stuff into 2.6.21.

Perhaps the best approach is to proceed as-is and clean things up once it's
all merged.

I guess your pte-at-a-time walker could be quite simply implemented underneath
the smaps pmd-at-a-time walker.
