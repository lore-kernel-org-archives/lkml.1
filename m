Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbYHFUqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbYHFUqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbYHFUpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:45:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:54257 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347AbYHFUpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:45:52 -0400
Date: Wed, 6 Aug 2008 13:45:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Oruba <peter.oruba@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/5] [PATCH 3/5] x86: Run Intel ucode-updates via
 workqueue.
Message-ID: <20080806134522.697b09f1@infradead.org>
In-Reply-To: <489A0A16.8060802@qualcomm.com>
References: <20080806152117.198754464@amd.com>
	<20080806152319.773811325@amd.com>
	<20080806084446.68683aaf@infradead.org>
	<489A0A16.8060802@qualcomm.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2008 13:31:18 -0700
Max Krasnyansky <maxk@qualcomm.com> wrote:

> Arjan van de Ven wrote:
> > On Wed, 6 Aug 2008 17:21:20 +0200
> > Peter Oruba <peter.oruba@amd.com> wrote:
> > 
> > [ no description or reason ]
> > 
> > Why is this?
> > 
> > I'm not very happy about this.. it means practically that this stuff
> > *has* to run late. Probably later than we want to.
> > (Like.. we may want to redo the microcode during resume.. which is
> > not a schedulable context)
> 
> Dmitry and I tried to figure out how soon does it need to run.

you're not going to like the answer, but it's "as soon as possible".
Unlike normal boot, hotplug is a case where the bios hasn't been able
to put a normal microcode in. 

> Nobody had a strong argument why it must run synchronously in the 
> hotplug path.

Ok we as Intel really want it as early as possible.

> Sure we want it as soon as possible and I'd say
> workqueue is soon enough.
> Existing hotplug path does not guaranty any ordering and original 
> microcode interface was driven from user-space. So clearly it was not 
> considered very critical.

well that's why it changed to no longer use the userspace driven thing..


> 
> Max


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
