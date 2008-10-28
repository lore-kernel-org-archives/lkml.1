Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYJ1XGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYJ1XGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYJ1XGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:06:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:38372 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbYJ1XGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:06:43 -0400
Date: Wed, 29 Oct 2008 08:06:09 +0900
To: jens.axboe@oracle.com
Cc: jeremy@goop.org, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with
 BIOVEC_PHYS_MERGEABLE
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081027115659.GZ22217@kernel.dk>
References: <20081027094111.GU22217@kernel.dk>
	<4905A961.9000603@goop.org>
	<20081027115659.GZ22217@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081029080603J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 12:57:00 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, Oct 27 2008, Jeremy Fitzhardinge wrote:
> > Jens Axboe wrote:
> > >Pretty much baffles me as well, xen should just need to do
> > >
> > >#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)       0
> > >  
> > 
> > It needs to be a runtime switch, since we only want to do this when 
> > actually running under Xen.  Also, its possible that the two pages might 
> > actually be physically contiguous, so they could be merged anyway.
> 
> Alright, then add a xen_biovec_phys_mergeable(vec1, vec2) in the xen
> code that actually checks this for real. You can add your switch there
> as well. Then put the BIOVEC_PHYS_MERGEABLE() in the xen arch includes,
> done.
> 
> What Tomo is saying is that this has nothing to do with virtual merging,
> and he's right.

Yeah, overriding BIOVEC_PHYS_MERGEABLE perfectly works for Xen. And it
is not related with BIO_VMERGE_BOUNDARY at all.

Ingo, please put this patch into your tree:

http://marc.info/?l=linux-kernel&m=122482703716620&w=2


Thanks,
