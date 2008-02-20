Return-Path: <linux-kernel-owner+w=401wt.eu-S1762399AbYBTCtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762399AbYBTCtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbYBTCtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:49:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbYBTCtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:49:31 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Shi Weihua <shiwh@cn.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
 check
In-Reply-To: Shi Weihua's message of  Wednesday, 20 February 2008 10:23:01 +0800 <47BB8F05.3050001@cn.fujitsu.com>
References: <47B95C4D.6080000@cn.fujitsu.com>
	<20080218134720.GA28851@elte.hu>
	<47BA299A.3040207@cn.fujitsu.com>
	<20080219185009.122ED2701BA@magilla.localdomain>
	<47BB7922.1010400@cn.fujitsu.com>
	<20080220011822.C510B2701BA@magilla.localdomain>
	<47BB83E2.1030504@cn.fujitsu.com>
	<20080220014419.B85D02701BA@magilla.localdomain>
	<47BB8F05.3050001@cn.fujitsu.com>
X-Shopping-List: (1) Cretinous ecstasy yies
   (2) Runcible ants
   (3) Stimulating intrinsic rectractors
   (4) Skeptical ambidextrous compasses
Message-Id: <20080220024928.0EE172701BA@magilla.localdomain>
Date: Tue, 19 Feb 2008 18:49:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I spent some time read you mail carefully and dig into the code again.
> 
> And yes, you are right. It's possible that SA_ONSTACK has been cleared
> before the second signal on the same stack comes.

It's not necessary for SA_ONSTACK to have "been cleared", by which I assume
you mean a sigaction call with SA_ONSTACK not set in sa_flags.  That is
indeed possible, but it's not the only case your patch broke.  It can just
be a different signal whose sigaction never had SA_ONSTACK, when you are
still on the signal stack from an earlier signal that did have SA_ONSTACK.

> So this patch is wrong  :( . I will revise the other 4 patches.

For 2 and 3, I would rather just wait until we unify signal.c anyway.


Thanks,
Roland
