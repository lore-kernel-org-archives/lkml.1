Return-Path: <linux-kernel-owner+w=401wt.eu-S934918AbZJJU7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934918AbZJJU7g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 16:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934907AbZJJU7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 16:59:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934906AbZJJU7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 16:59:35 -0400
Date: Sat, 10 Oct 2009 22:58:04 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Jonathan Corbet <corbet@lwn.net>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Mark Gross <mgross@linux.intel.com>
Subject: Re: [patch 02/28] pm_qos: clean up racy global "name" variable
In-Reply-To: <20091010140339.5cb5b17b@bike.lwn.net>
Message-ID: <alpine.LFD.2.00.0910102253530.3669@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de> <20091010153349.113570550@linutronix.de> <alpine.LFD.2.00.0910102147020.3669@localhost.localdomain> <20091010140339.5cb5b17b@bike.lwn.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Oct 2009, Jonathan Corbet wrote:

> On Sat, 10 Oct 2009 21:54:22 +0200 (CEST)
> John Kacur <jkacur@redhat.com> wrote:
> 
> > Hmnn, why 32? Seems arbitrary. At least you see with "process_1234567890" 
> > which is 19, an attempt to show what the maximum string size would be. If 
> > a system were configured to enlarge the maximum PID from 32767 to 4194303 
> > that would still only be 7 digits, so "process_1234567" - which is 16 
> > digits with the newline would enough.
> > 
> > So, I suggest you change that to
> > #define PID_NAME_LEN sizeof("process_1234567")
> 
> ...which works great until somebody enables 64-bit process IDs...:)
> 
> We're talking about 20 bytes of stack space in an almost-never-called
> function. I honestly don't think it's worth worrying about, but if
> somebody wants to tweak it, I'll not complain.
> 
> (Thanks for looking at the patch).
> 

It was a minor nit at best! My point was less about the stack space than 
the readability - which you could argue is a personal style choice here. 
There is nothing else to criticize in these patches. :)

Thomas, I reviewed all 28 patches and applied them.

Thanks

