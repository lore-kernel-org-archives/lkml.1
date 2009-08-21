Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZHUSda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZHUSda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbZHUSd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:33:28 -0400
Received: from mga10.intel.com ([192.55.52.92]:60140 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755799AbZHUSd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:33:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,251,1249282800"; 
   d="scan'208";a="486087970"
Message-ID: <4A8EE877.90502@linux.intel.com>
Date: Fri, 21 Aug 2009 11:33:27 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl, catalin.marinas@arm.com,
       Jens Axboe <jens.axboe@oracle.com>, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:tracing/urgent] tracing: Fix too large stack usage in do_one_initcall()
References: <new-submission> <tip-4a683bf94b8a10e2bb0da07aec3ac0a55e5de61f@git.kernel.org> <alpine.LFD.2.01.0908210845540.3158@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908210845540.3158@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> I do wonder, though. Maybe we should never have that MAX_WORK limit, and 
> instead limit the parallelism by actively trying to yield when there's too 
> much work? That bootup sequence _does_ tend to have deep callchains (with 
> all the crazy device register crud), and maybe we should actively see the 
> async work code as not just a way to speed up boot, but also as a way to 
> avoid deep callchains.

makes sense; the MAX_WORK was more a sanity check to kill out of hand recursion
than anything else...
