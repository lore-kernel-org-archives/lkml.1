Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZLBLCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZLBLCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 06:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZLBLCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 06:02:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:54127 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbZLBLCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 06:02:00 -0500
Subject: Re: [PATCH 3/7] sched: refactor try_to_wake_up()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>, tglx@linutronix.de, mingo@elte.hu,
       avi@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <4B163DEA.2050303@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-4-git-send-email-tj@kernel.org>
	 <1259744733.6028.233.camel@marge.simson.net>  <4B16388F.90707@kernel.org>
	 <1259748618.6028.282.camel@marge.simson.net>  <4B163DEA.2050303@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 12:01:19 +0100
Message-ID: <1259751679.4003.466.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 19:14 +0900, Tejun Heo wrote:
> On 12/02/2009 07:10 PM, Mike Galbraith wrote:
> >>> I think it would _look_ better with the thing just
> >>> duplicated/stripped down and called what it is,
> >>> sched_notifier_wakeup() or such.
> >>
> >> Sorry, I'm not following.  Can you elaborate a bit?
> > 
> > I mean copying ttwu, stripping out locking etc, and renaming the result
> > would look better.  No functional difference though, and binary growth
> > would be left in the wake of such a duplication.
> 
> Ah... okay.  Well, that was the first approach (with some missing
> parts).  Peter wasn't particularly happy with code duplication and
> suggested refactoring ttwu and reuse common parts.

Right, esp since it missed some parts.

I haven't yet had time to look at this patch, but yeah, sharing code
seems like a good idea since its tricky and fragile code.



