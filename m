Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYHZTv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYHZTv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYHZTvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:51:44 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:10862 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531AbYHZTvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:51:43 -0400
Subject: Re: [PATCH 1/4] mutex: add mutex_lock_timeout()
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>, Len Brown <len.brown@intel.com>,
       Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org
In-Reply-To: <48B45A48.6080604@linux.intel.com>
References: <1219777186-4787-1-git-send-email-dwalker@mvista.com>
	 <48B45A48.6080604@linux.intel.com>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 12:51:38 -0700
Message-Id: <1219780298.3797.24.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 21:32 +0200, Andi Kleen wrote:
> Daniel,
> 
> My decision on this patchkit is to reject it for now, because:
> 
> - I'm worried about the long term maintenance impact of doing full
> lockdep checking on AML controlled locks. Since I'm keeping ACPI
> only temporarily I don't want to leave an potentially problematic
> legacy.

I think we have to allow some testing before there could be claim that
there would be a major problem.

> However what you can do is to ask Len again when he's back. Ultimately
> it is his decision and he might decide that he can deal with AML lockdep
> issues longer term.

For instance these changes could go into linux-next until the 2.6.29
merge window .. Len should be back by then, and we should have a much
better idea what kind of problems may exist, if any..

> Don't think it makes all that much sense to resubmit the completion
> patch though. It's unrelated to the other patches anyways (not sure
> why you mix them together)

It's all related .. I removed the semaphores in ACPI which are actually
mutexes in the first three patches. Your left with only semaphores that
are locked.. Locked semaphores are really completions, so it's natural
to convert them.

I would have liked to change the name in ACPI from "semaphore" to
"completion" , but you and Bob seemed to have some serious objections to
it, w.r.t other operating systems that are using that ACPI code.

Daniel

