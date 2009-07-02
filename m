Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbZGBNGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbZGBNGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZGBNG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:06:27 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:48455 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbZGBNG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:06:26 -0400
Subject: Re: Exiting with locks still held (was Re: [PATCH] kmemleak: Fix 
	scheduling-while-atomic bug)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
In-Reply-To: <84144f020907020554n1b098e28o8b4a4a58a08728e3@mail.gmail.com>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
	 <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
	 <20090701093015.GA6862@elte.hu>
	 <1246441592.8492.38.camel@pc1117.cambridge.arm.com>
	 <20090701110438.GA15958@elte.hu>
	 <1246538899.13320.86.camel@pc1117.cambridge.arm.com>
	 <84144f020907020554n1b098e28o8b4a4a58a08728e3@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 02 Jul 2009 14:06:03 +0100
Message-Id: <1246539963.13320.91.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2009 13:06:07.0838 (UTC) FILETIME=[DD0EA7E0:01C9FB15]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 15:54 +0300, Pekka Enberg wrote:
> On Thu, Jul 2, 2009 at 3:48 PM, Catalin Marinas<catalin.marinas@arm.com> wrote:
> > It could be but I can't figure out a solution. If there is only one task
> > opening and closing the kmemleak file, everything is fine. In
> > combination with shell piping I think I get the kmemleak file descriptor
> > released from a different task than the one that opened it.
> >
> > For example, the badly written code below opens kmemleak and acquires
> > the scan_mutex in the parent task but releases it in the child (it needs
> > a few tries to trigger it). With waitpid() in parent everything is fine.
[...]
> Well, you are not supposed to hold on to locks when returning from a
> system call ("sys_open") anyway. You can probably do the exclusion
> with a kmemcheck specific flag?

Acquiring the mutex in "open" and releasing it in "release" was easier.
I'll see if I can move the mutex to the seq_read functions which
actually need it.

-- 
Catalin

