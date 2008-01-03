Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYACSeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYACSeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYACSdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:33:54 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:45445 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbYACSdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:33:53 -0500
X-Greylist: delayed 871 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 13:33:52 EST
Date: Thu, 3 Jan 2008 10:16:51 -0800
From: Chris Wright <chrisw@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 01/11] Add basic support for gcc profiler
	instrumentation
Message-ID: <20080103181651.GC3627@sequoia.sous-sol.org>
References: <20080103071609.478486470@goodmis.org> <20080103072226.776141236@goodmis.org> <20080103092104.GE10813@elte.hu> <Pine.LNX.4.58.0801030849180.1468@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801030849180.1468@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> Hmm, I know paravirt-ops had an issue with mcount in the RT tree. I can't
> remember the exact issues, but it did have something to do with the way
> parameters were passed in.
> 
> Chris, do you remember what the issues were?

Yes, paravirt ops have a well-specified calling convention (register
based).  There was a cleanup that Andi did that caused the problem
because it removed all the "fastcall" annotations since -mregparm=3
is now always on for i386.  Since MCOUNT disables REGPARM the calling
convention changes (caller pushes to stack, callee expects register)
chaos ensues.  I sent a patch to fix that quite some months back, but
it went stale and I neglected to update it.  Would you like me to dig
it up refresh and resend?

thanks,
-chris
