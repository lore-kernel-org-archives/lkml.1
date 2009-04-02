Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbZDBJ2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbZDBJ2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757218AbZDBJ1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:27:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934487AbZDBJ1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:27:44 -0400
Subject: Re: [PATCH 2/9] perf_counter: fix update_userpage()
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <18900.33695.919419.831813@cargo.ozlabs.ibm.com>
References: <20090328194359.426029037@chello.nl>
	 <20090328194929.546464621@chello.nl>
	 <18894.49084.341238.775487@cargo.ozlabs.ibm.com>
	 <1238662238.8530.5622.camel@twins> <1238662858.8530.5648.camel@twins>
	 <18900.33695.919419.831813@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Apr 2009 11:28:37 +0200
Message-Id: <1238664517.8530.5705.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 20:21 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > The below might work:
> > 
> >   u32 seq;
> >   s64 count;
> > 
> > again:
> >   seq = pc->lock;
> > 
> >   if (unlikely(seq & 1)) {
> 
> I don't believe we can ever see this condition, since pc->lock is
> updated in the kernel either at interrupt level on the cpu this task
> is running on, or in the kernel in the context of this task.  So this
> userspace code can never run in the middle of the kernel updating
> things.

Colour me paranoid ;-)
