Return-Path: <linux-kernel-owner+w=401wt.eu-S934835AbZJJUKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934835AbZJJUKU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 16:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934816AbZJJUKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 16:10:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:35684 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934775AbZJJUKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 16:10:19 -0400
Subject: Re: [patch 02/28] pm_qos: clean up racy global "name" variable
From: Peter Zijlstra <peterz@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: John Kacur <jkacur@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Mark Gross <mgross@linux.intel.com>
In-Reply-To: <20091010140339.5cb5b17b@bike.lwn.net>
References: <20091010153314.827301943@linutronix.de>
	 <20091010153349.113570550@linutronix.de>
	 <alpine.LFD.2.00.0910102147020.3669@localhost.localdomain>
	 <20091010140339.5cb5b17b@bike.lwn.net>
Content-Type: text/plain
Date: Sat, 10 Oct 2009 22:09:22 +0200
Message-Id: <1255205362.7521.675.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 14:03 -0600, Jonathan Corbet wrote:
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
> ....which works great until somebody enables 64-bit process IDs...:)

PID/TIDs are limited to 2^29, raising it above that will break things
like futexes. Raising it above 2^32 will break heaps of userspace.

That said, 512M tasks still seems like a lot, but if history is
something to go by we'll eventually run out...

