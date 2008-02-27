Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbYB0HjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbYB0HjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbYB0Hi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:38:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbYB0Hi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:38:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Tomasz Grobelny <tomasz@grobelny.oswiecenia.net>
Subject: Re: [PATCH] x86 tls prevent_tail_call
In-Reply-To: Ingo Molnar's message of  Wednesday, 27 February 2008 08:26:17 +0100 <20080227072617.GB4638@elte.hu>
References: <20080226210018.A031B26F9A4@magilla.localdomain>
	<20080227072617.GB4638@elte.hu>
X-Windows: more than enough rope.
Message-Id: <20080227073821.0C34C2700FD@magilla.localdomain>
Date: Tue, 26 Feb 2008 23:38:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> i'm wondering, have you seen this happen in practice? We use 
> sys_set_thread_area() for every new task started up. I guess we havent 
> seen problems in the field yet because this early during startup tasks 
> do not normally receive signals? (or if they do they are fatal and no 
> user signal context is used.)

Tomasz saw it.  I don't know what compiler or exact options to it he used.

> btw., this whole thing of us having to notice such tail-optimization 
> incidents is totally fragile and unreliable. Shouldnt there be a "dont 
> tail-optimize me" attribute which we could stick into asmlinkage? 

I agree.  It's come up before.  I'll talk to compiler folks about it again.

> Perhaps sparse could detect asmlinkage functions that do not do 
> prevent_tail_call()s?

That sounds like a good idea to me.


Thanks,
Roland

