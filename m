Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbYEKQsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbYEKQsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 12:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYEKQsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 12:48:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113AbYEKQsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 12:48:11 -0400
Date: Sun, 11 May 2008 09:47:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Matthew Wilcox <matthew@wil.cx>, Sven Wegener <sven.wegener@stealer.net>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
In-Reply-To: <20080511143227.GA3220@elte.hu>
Message-ID: <alpine.LFD.1.10.0805110945250.3330@woody.linux-foundation.org>
References: <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org> <20080511114803.GA8289@parisc-linux.org> <20080511125049.GA22513@elte.hu> <20080511125216.GA25040@elte.hu>
 <20080511130226.GR19219@parisc-linux.org> <20080511135414.GA2328@elte.hu> <20080511142222.GU19219@parisc-linux.org> <20080511143227.GA3220@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 May 2008, Ingo Molnar wrote:
> 
> but the problem is that by serializing the wakeup chains naively you 
> introduced a more than 50% AIM7 performance regression.

No, the problem is that the BKL shouldn't be a semaphore at all. 
Performance fixed.

After that, it's *purely* a correctness issue, and then we might as well 
be fair and not allow the stealing of semaphores from under waiters at 
ALL. Which is what Matthews original code did.

In other words, current -git is fine, and was already confirmed by Sven 
to fix the bug (before *any* of your patches were), and was earlier 
confirmed to fix the AIM7 performance regression (better than *any* of 
your patches were).  

So I fixed the problems last night already. Stop wasting everybody's time.

		Linus
