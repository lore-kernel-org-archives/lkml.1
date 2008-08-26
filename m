Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbYHZWJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbYHZWJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbYHZWJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:09:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:22520 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYHZWJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:09:46 -0400
Subject: Re: [PATCH 1/4] mutex: add mutex_lock_timeout()
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>, Len Brown <len.brown@intel.com>,
       Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org
In-Reply-To: <48B471F7.1080907@linux.intel.com>
References: <1219777186-4787-1-git-send-email-dwalker@mvista.com>
	 <48B45A48.6080604@linux.intel.com>
	 <1219780298.3797.24.camel@dhcp32.mvista.com>
	 <48B471F7.1080907@linux.intel.com>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 15:09:42 -0700
Message-Id: <1219788582.3797.68.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 23:13 +0200, Andi Kleen wrote:
> >> However what you can do is to ask Len again when he's back. Ultimately
> >> it is his decision and he might decide that he can deal with AML lockdep
> >> issues longer term.
> > 
> > For instance these changes could go into linux-next until the 2.6.29
> > merge window .. Len should be back by then, and we should have a much
> > better idea what kind of problems may exist, if any..
> 
> Sorry I'm not convinced that linux-next testing can resolve that.
> It doesn't really have enough hardware/tester coverage. Also linux-next
> is really only for stuff that is going to be merged, and from
> my current perspective it's not.

What form of testing do you suggest? I only have access to so many
machines..

> >> Don't think it makes all that much sense to resubmit the completion
> >> patch though. It's unrelated to the other patches anyways (not sure
> >> why you mix them together)
> > 
> > It's all related .. 
> 
> I don't think it is. You keep claiming that but it's just not true.
> You have not so far brought up a single argument why the semaphores
> should be changed to completions.

The over arching goal is to remove semaphores from the kernel. AFAIK
there is broad support for that, and it has been discusses.. ACPI uses
semaphores like mutexes, which I changed to actually use mutexes. ACPI
also uses semaphores as completions , which I've changed to just
directly use completions.

Using semaphores has the side effect that you don't know for sure how
the semaphore is being used. It could be a completion, it could be a
mutex, it could be something else completely.. With ACPI this was hard
to figure out .. ACPI locking is not that readable, and not that easy to
understand..

By using completions your making your code more readable. By using
mutexes, you get faster, and more readable code. Your also allowing your
locking to be checked by lockdep.

Daniel

