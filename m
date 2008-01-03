Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbYACTTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbYACTTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 14:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbYACTTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 14:19:00 -0500
Received: from gw.goop.org ([64.81.55.164]:52555 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbYACTS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 14:18:59 -0500
Message-ID: <477D34FB.6070601@goop.org>
Date: Thu, 03 Jan 2008 11:18:19 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Chris Wright <chrisw@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Chris Wright <chrisw@sous-sol.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>,
       LKML <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 01/11] Add basic support for gcc profiler	instrumentation
References: <20080103071609.478486470@goodmis.org>	<20080103072226.776141236@goodmis.org>	<20080103092104.GE10813@elte.hu>	<Pine.LNX.4.58.0801030849180.1468@gandalf.stny.rr.com> <20080103181651.GC3627@sequoia.sous-sol.org>
In-Reply-To: <20080103181651.GC3627@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
>   
>> Hmm, I know paravirt-ops had an issue with mcount in the RT tree. I can't
>> remember the exact issues, but it did have something to do with the way
>> parameters were passed in.
>>
>> Chris, do you remember what the issues were?
>>     
>
> Yes, paravirt ops have a well-specified calling convention (register
> based).  There was a cleanup that Andi did that caused the problem
> because it removed all the "fastcall" annotations since -mregparm=3
> is now always on for i386.  Since MCOUNT disables REGPARM the calling
> convention changes (caller pushes to stack, callee expects register)
> chaos ensues.  I sent a patch to fix that quite some months back, but
> it went stale and I neglected to update it.  Would you like me to dig
> it up refresh and resend?

Ingo/Andrew have been accepting patches to systematically remove all the
fastcall annotations from the kernel, so adding them back isn't going to
help.

Ingo and I discussed whether we need to reannotate paravirt.h (either
with fastcall or something else indicating a register-only calling
convention), specifically because of the -pg issue, but I think the
conclusion was that whatever problem existed no longer does, and there's
no incompatibility between -pg and regparm.

    J
