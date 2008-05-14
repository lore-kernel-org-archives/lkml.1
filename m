Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbYENWNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbYENWNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYENWMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:12:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbYENWMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:12:49 -0400
Date: Wed, 14 May 2008 15:11:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
In-Reply-To: <20080514224600.5bb5db5c@core>
Message-ID: <alpine.LFD.1.10.0805141510120.3019@woody.linux-foundation.org>
References: <20080514174955.GA515@elte.hu> <20080514224600.5bb5db5c@core>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 May 2008, Alan Cox wrote:
> 
> Here is a fun one for general discussion - right now driver probe
> functions request resources. We have no ordering on the requests so we
> have deadlocks if two drivers do resource requests for conflicting
> resources in reverse order.

resource requests aren't blocking, so it wouldn't actually be a deadlock. 
It would just be a "both failed, try again".

That said, two drivers shouldn't be probing the same hardware at the same 
time regardless, so I can't imagine that it's much of a problem in real 
life. 

		Linus
