Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZK1LPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZK1LPE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 06:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZK1LPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 06:15:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51698 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbZK1LPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 06:15:03 -0500
To: paulmck@linux.vnet.ibm.com
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] "fair" rw spinlocks
From: Andi Kleen <andi@firstfloor.org>
References: <20091123145409.GA29627@wotan.suse.de>
	<20091128020739.GA18149@linux.vnet.ibm.com>
Date: Sat, 28 Nov 2009 12:15:07 +0100
In-Reply-To: <20091128020739.GA18149@linux.vnet.ibm.com> (Paul E. McKenney's message of "Fri, 27 Nov 2009 18:07:39 -0800")
Message-ID: <87pr72529w.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>
> The usual trick would be to keep per-fair-rwlock state in per-CPU
> variables.  If it is forbidden to read-acquire one nestable fair rwlock
> while read-holding another, then this per-CPU state can be a single
> pointer and a nesting count.  On the other hand, if it is permitted to
> read-acquire one nestable fair rwlock while holding another, then one
> can use a small per-CPU array of pointer/count pairs.

The problem is that in preemptible kernels kernel threads can switch
CPUs all the time.  How would you sync the per CPU state then?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
