Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbXKBAfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbXKBAfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 20:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbXKBAfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 20:35:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbXKBAfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 20:35:43 -0400
Date: Thu, 1 Nov 2007 20:35:26 -0400
From: Rik van Riel <riel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gregory Haskins <gregory.haskins.ml@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
Message-ID: <20071101203526.293cd7f0@bree.surriel.com>
In-Reply-To: <alpine.LFD.0.999.0711010935060.3342@woody.linux-foundation.org>
References: <20071101140146.GA26879@wotan.suse.de>
	<20071101140320.GC26879@wotan.suse.de>
	<4729E567.1050402@gmail.com>
	<alpine.LFD.0.999.0711010935060.3342@woody.linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 09:38:22 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So "unfair" is obviously always bad. Except when it isn't.

Larry Woodman managed to wedge the VM into a state where, on his
4x dual core system, only 2 cores (on the same CPU) could get the
zone->lru_lock overnight.  The other 6 cores on the system were
just spinning, without being able to get the lock.

On the other hand, spinlock contention in the page replacement
code is just a symptom of the fact that we scan too many pages.
It can probably be fixed in other ways...

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
