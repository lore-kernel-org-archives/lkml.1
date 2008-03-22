Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYCVM3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYCVM3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 08:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYCVM3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 08:29:14 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22466 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbYCVM3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 08:29:13 -0400
Date: Sat, 22 Mar 2008 13:29:03 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, paulus@samba.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Message-ID: <20080322122903.GD15355@kernel.dk>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <1FE6DD409037234FAB833C420AA843ECE137D9@orsmsx424.amr.corp.intel.com> <20080321183149.GB15355@kernel.dk> <1FE6DD409037234FAB833C420AA843ECE1387F@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECE1387F@orsmsx424.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21 2008, Luck, Tony wrote:
> > My thinking was that it may need a bit of help to ensure that the init
> > function for single call data works,
> 
> The problem may be worse than that.  I see that you have a per-cpu
> "call_single_queue" on which you do some list operations.  On ia64
> the per-cpu variables live at the same virtual address on each processor
> with a per-cpu TLB mapping directing them to a different physical
> address on each.  This makes Linux lists very confused.

Funky, how does accessing other CPU's per-cpu variables work on ia64
then? Perhaps I made some false assumptions. Unfortunately I have no
access to any IA64 machines, so I either have to yank the ia64 bits
(which is unfortunate, since Alan tests on those :-) or rely on a bit of
help from you and/or others in getting that bit right.

-- 
Jens Axboe

