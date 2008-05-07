Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbYEGO6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbYEGO6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758862AbYEGO56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:57:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57788 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbYEGO54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:57:56 -0400
Message-ID: <4821C370.1030801@firstfloor.org>
Date: Wed, 07 May 2008 16:57:52 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I think turning the BKL into a semaphore was fine per se,

Are there really that many long lived BKL holders? I have some doubts.
Semaphore makes only sense when the critical region is at least
many thousands of cycles to amortize the scheduling overhead.

Ok perhaps this needs some numbers to decide.

 but that was
> when semaphores were fast. 

The semaphores should be still nearly as fast in theory, especially
for the contended case.

> Considering the apparent AIM regressions, we really either need to revert 
> the semaphore consolidation,

Or figure out what made the semaphore consolidation slower? As Ingo
pointed out earlier 40% is unlikely to be a fast path problem, but some
algorithmic problem. Surely that is fixable (even for .26)?

Perhaps we were lucky it showed so easily, not in something tricky.

-Andi
