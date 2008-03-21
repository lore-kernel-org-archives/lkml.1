Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYCUScI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYCUScI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYCUSbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:31:55 -0400
Received: from brick.kernel.dk ([87.55.233.238]:16262 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbYCUSbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:31:55 -0400
Date: Fri, 21 Mar 2008 19:31:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, paulus@samba.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Message-ID: <20080321183149.GB15355@kernel.dk>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <1FE6DD409037234FAB833C420AA843ECE137D9@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECE137D9@orsmsx424.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21 2008, Luck, Tony wrote:
> > When/if more archs are converted, it'll of course look even better.
> > Comments? I've verified that this builts and boots on x86, x86-64
> > and powerpc. IA64 may still need a one-liner change, I don't have
> > access to that platform anymore so I can't verify that myself. It
> > does build, however :-)
> 
> Can you give me a clue as to which line needs the one-liner ... although
> it builds cleanly for IA64 it panics with a dereference NULL fault. It

My thinking was that it may need a bit of help to ensure that the init
function for single call data works,
kernel/smp.c:init_call_single_data() specifically. It may be run before
the arch code has setup all CPU related structures, not sure...

> looks like we were in the list_add_tail(&data->list, &dst->list) code.

Is it data or dst being NULL? Looking at your trace, it must be dst.
Which makes me believe that it is indeed a missing call of the above
function at the right time. So some help would be accepted there :)

-- 
Jens Axboe

