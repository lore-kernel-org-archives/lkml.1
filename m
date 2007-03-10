Return-Path: <linux-kernel-owner+w=401wt.eu-S1751859AbXCJTa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbXCJTa6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 14:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXCJTa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 14:30:58 -0500
Received: from holomorphy.com ([66.93.40.71]:58238 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbXCJTa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 14:30:56 -0500
Date: Sat, 10 Mar 2007 11:31:00 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Pluggable Schedulers (was: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler)
Message-ID: <20070310193100.GI2986@holomorphy.com>
References: <200703091625.55361.a1426z@gawab.com> <200703100834.25136.a1426z@gawab.com> <20070310065927.GH2986@holomorphy.com> <200703101947.11960.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703101947.11960.a1426z@gawab.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> Last I checked there were limits to runtime configurability centering
>> around only supporting a compiled-in set of scheduling drivers, unless
>> Peter's taken it the rest of the way without my noticing. It's unclear
>> what you have in mind in terms of dynamic extensibility. My only guess
>> would be pluggable scheduling policy/class support for individual
>> schedulers in addition to plugging the individual schedulers, except
>> I'm rather certain that Williams' code doesn't do anything with modules.

On Sat, Mar 10, 2007 at 07:47:11PM +0300, Al Boldi wrote:
> Correct, it doesn't, yet.  But do you think that PlugSched has the basic 
> infrastructure in place to support this, or would it require a complete 
> redesign/rewrite.

The piece I got done was just representing schedulers as driver-like
affairs (which, embarrassingly enough, needed lots of bugfixing), and
everyone's just been running with that and boot-time switching ever
since. Runtime switching (to module-loaded schedulers or otherwise)
needs a lot of hotplug-esque work. Scheduler class support, pluggable
or otherwise, needs per-scheduler abstracting things out along the same
lines as what was originally done for the overall schedulers
surrounding enqueueing and dequeueing so the scheduler itself only
plucks tasks out of and stuffs tasks into some sort of abstracted-out
queue or set of queues, though I did try to break things down at a low
enough level where they'd be plausible for more than just the one
driver (never distributed) I used to test the design. I dumped the
entire project long before ever getting to where modules entered the
picture, and have never touched modules otherwise, so I'm not entirely
sure what other issues would come up with those after the smoke clears
from runtime switching.

I don't plan on doing anything here myself, since the boot-time
switching etc. is likely already considered offensive enough.

The next time something comes up that bears a risk of positioning me
against the kernel's political winds, I'll just rm it or not write it
at all instead of leaving code around (or worse yet, passing it around)
to be taken up by others. It just leaves a lot of embarrassed explaining
to do when it resurfaces years later, or otherwise leaves a rather bad
taste in my mouth when NIH'd years later like other things not mentioned
here (VM code kept quiet similarly to plugsched) and everyone approves
so long as it didn't come from me.


-- wli
