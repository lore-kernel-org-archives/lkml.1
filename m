Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbYKRMSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbYKRMSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 07:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYKRMR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 07:17:57 -0500
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:19636 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752029AbYKRMR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 07:17:56 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #11954] sysprof tracer ABI regression in 2.6.28rc1
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
	<Q7OAnAv0V3D.A.MbF.8AGIJB@chimera>
	<ye8k5b2eetz.fsf@camel11.daimi.au.dk> <20081117162431.GG12081@elte.hu>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 18 Nov 2008 13:17:53 +0100
In-Reply-To: <20081117162431.GG12081@elte.hu>
Message-ID: <ye8bpwd6xe6.fsf@camel04.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Soeren Sandmann <sandmann@daimi.au.dk> wrote:
> 
> > There are no ABI guarantees for the sysprof tracer at this point, 
> > given that it is in debugfs [...]
> 
> to avoid situations like this, it would be nice to print out the 
> format string itself in the trace header, in printf format string 
> style. That way if there's a trivial expansion in trace format, it can 
> be detected (and even followed) by user-space - without some ugly 
> version based API.

It's not clear to me that sysprof userspace could realistically do
runtime detection. It would require (a) using sscanf() to parse the
output and (b) that only the types changed, not the actual content or
ordering. (a) is likely a non-starter performance-wise (the first
version actually did this and it was too slow), and (b) means there
are strict limits to what could be changed anyway.


Soren
