Return-Path: <linux-kernel-owner+w=401wt.eu-S1764041AbZFLQF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764041AbZFLQF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761306AbZFLQFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:05:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60135 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763035AbZFLQFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:05:41 -0400
Message-ID: <4A327CB1.6060009@redhat.com>
Date: Fri, 12 Jun 2009 12:05:05 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] HWPOISON: define VM_FAULT_HWPOISON to 0 when	feature
 is disabled
References: <20090611142239.192891591@intel.com> <20090611144430.414445947@intel.com> <20090612112258.GA14123@elte.hu> <20090612125741.GA6140@localhost> <20090612131754.GA32105@elte.hu> <alpine.LFD.2.01.0906120827020.3237@localhost.localdomain> <20090612153501.GA5737@elte.hu>
In-Reply-To: <20090612153501.GA5737@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> So i think hwpoison simply does not affect our ability to get log 
> messages out - but it sure allows crappier hardware to be used.
> Am i wrong about that for some reason?

You are :)

A 2-bit memory error can be a temporary failure, eg.
due to a cosmic ray.  If bit errors could be prevented
in hardware, there would be no reason to have ECC at all.

The only reason to stop using that page is because we
do not know for sure whether the error was temporary
or permanent (or dependent on a particular bit pattern).

Userspace needs to be notified that some data disappeared,
if it did - for clean pagecache and swap cache pages, the
kernel can simply take the page away and wait for a page
fault...

The sysadmin needs to know that something happened too,
because the hardware *might* have a problem.

However, a 2-bit error does not imply that the hardware
actually needs to be replaced.

-- 
All rights reversed.
