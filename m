Return-Path: <linux-kernel-owner+w=401wt.eu-S1765653AbZDBJWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765653AbZDBJWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbZDBJV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:21:56 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55506 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZDBJVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:21:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18900.33695.919419.831813@cargo.ozlabs.ibm.com>
Date: Thu, 2 Apr 2009 20:21:35 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/9] perf_counter: fix update_userpage()
In-Reply-To: <1238662858.8530.5648.camel@twins>
References: <20090328194359.426029037@chello.nl>
	<20090328194929.546464621@chello.nl>
	<18894.49084.341238.775487@cargo.ozlabs.ibm.com>
	<1238662238.8530.5622.camel@twins>
	<1238662858.8530.5648.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> The below might work:
> 
>   u32 seq;
>   s64 count;
> 
> again:
>   seq = pc->lock;
> 
>   if (unlikely(seq & 1)) {

I don't believe we can ever see this condition, since pc->lock is
updated in the kernel either at interrupt level on the cpu this task
is running on, or in the kernel in the context of this task.  So this
userspace code can never run in the middle of the kernel updating
things.

Paul.
