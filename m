Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966784Ab0B0A7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 19:59:53 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:60921 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966750Ab0B0A7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 19:59:52 -0500
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] mm: Remove ZERO_SIZE_PTR.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201002260635.o1Q6ZYET040848@www262.sakura.ne.jp>
	<alpine.DEB.2.00.1002261009320.7719@router.home>
In-Reply-To: <alpine.DEB.2.00.1002261009320.7719@router.home>
Message-Id: <201002270959.EEI05786.OOFFQVMFJLOtSH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 27 Feb 2010 09:59:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 26 Feb 2010, Tetsuo Handa wrote:
> 
> > Everybody should check for ptr != NULL, and most callers are actually checking
> > for ptr != NULL. But nobody is checking for ptr != ZERO_SIZE_PTR.
> 
> That is so intentionally because some kernel subsystem can do a zero size
> allocation.
> 
So, not only users *can* do zero size allocation,
but also there *are* users who are intentionally doing zero size allocation.
Then, we can't remove ZERO_SIZE_PTR.

> > Yes, this is the fault of caller. But ZERO_SIZE_PTR is too small value to
> > distinguish "NULL pointer dereference" and "ZERO_SIZE_PTR dereference" because
> > address printed by oops message can easily exceed ZERO_SIZE_PTR when
> > "struct foo" is large.
> 
> Correct.

Maybe PAGE_SIZE / 2 is better than 16?

Thanks.
