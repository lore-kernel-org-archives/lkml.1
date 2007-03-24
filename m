Return-Path: <linux-kernel-owner+w=401wt.eu-S1751613AbXCXVlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbXCXVlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 17:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXCXVlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 17:41:50 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51537 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbXCXVlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 17:41:50 -0400
Date: Sat, 24 Mar 2007 13:41:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, kiran@scalex86.org
Subject: Re: [rfc][patch] queued spinlocks (i386)
Message-Id: <20070324134128.7882f905.akpm@linux-foundation.org>
In-Reply-To: <20070323103243.GE11577@wotan.suse.de>
References: <20070323085910.GA11577@wotan.suse.de>
	<20070323100418.GA30740@elte.hu>
	<20070323103243.GE11577@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 23 Mar 2007 11:32:44 +0100 Nick Piggin <npiggin@suse.de> wrote:
>
> I'm not as concerned about the contended performance of spinlocks
>

The contended case matters.  Back in 2.5.something I screwed up the debug
version of one of the locks (rwlock, iirc) - it was simply missing a
cpu_relax(), and some people's benchmarks halved.

> This was just something I had in mind when the hardware lock
> starvation issue came up

It looks like a good way to address the lru_lock starvation/capture
problem.  But I think I'd be more comfortable if we were to introduce it as
a new lock type, rather than as a reimplementation of the existing
spin_lock().   Initially, at least.
