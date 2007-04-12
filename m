Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXDLVhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXDLVhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXDLVhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:37:36 -0400
Received: from holomorphy.com ([66.93.40.71]:39123 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbXDLVhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:37:35 -0400
Date: Thu, 12 Apr 2007 14:37:50 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Buytaert_Steven@emc.com, linux-kernel@vger.kernel.org
Subject: Re: sched_yield proposals/rationale
Message-ID: <20070412213750.GF2986@holomorphy.com>
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com> <p737ish90ss.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p737ish90ss.fsf@bingen.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 03:31:31PM +0200, Andi Kleen wrote:
> The only way I could think of to make sched_yield work the way they 
> expect would be to define some way of gang scheduling and give
> sched_yield semantics that it preferably yields to other members
> of the gang.
> But it would be still hard to get these semantics (how to define
> the gangs) into your uncontrollable broken applications and also
> it has the risk of either unfairness or not full utilization of the 
> machine. Getting it to scale well on MP systems would be also likely 
> a challenge.

Gang scheduling isn't a squishy concept whose name can be arbitrarily
repurposed. Perhaps "group scheduling" or similar would be appropriate
if the standard gang scheduling semantics are not what you have in mind.

Standard gang scheduling would not be appropriate for applications that
don't know what they're doing. All threads of a gang falling asleep
when one sleeps (or more properly, the gang is considered either
runnable or unrunnable as a unit) is not to be taken lightly.

I'd call this something like a "directed yield with a group as a target,"
but I wouldn't actually try to do this. I'd try to provide ways for a
directed yield to donate remaining timeslice and dynamic priority if
possible to a particular task associated with a resource, for instance,
a futex or SysV semaphore owner. The priority inversion one desperately
wants to avoid is the resource owner running out of timeslice or
otherwise losing priority to where it falls behind busywaiters such as
callers of sched_yield for the purposes of multitier locking.


-- wli
