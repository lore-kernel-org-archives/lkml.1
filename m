Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbXDRH3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbXDRH3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 03:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXDRH3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 03:29:20 -0400
Received: from main.gmane.org ([80.91.229.2]:57127 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbXDRH3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 03:29:19 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: James Bruce <bruce@andrew.cmu.edu>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
Date: Wed, 18 Apr 2007 03:29:00 -0400
Message-ID: <4625C8BC.9060804@andrew.cmu.edu>
References: <20070417061503.GC1057@wotan.suse.de> <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com> <20070417070949.GR8915@holomorphy.com> <20070417073308.GB30559@elte.hu> <20070417090538.GU8915@holomorphy.com> <20070417092422.GA19414@elte.hu> <20070417220809.GF11166@waste.org> <20070417223256.GP2986@holomorphy.com> <20070417223909.GO11115@waste.org> <20070417225902.GQ2986@holomorphy.com> <20070417225723.GP11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: dhcp-7-156.dsl.telerama.com
User-Agent: Icedove 1.5.0.10 (X11/20070329)
In-Reply-To: <20070417225723.GP11115@waste.org>
Cc: ck@vds.kolivas.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Tue, Apr 17, 2007 at 03:59:02PM -0700, William Lee Irwin III wrote:
>> On Tue, Apr 17, 2007 at 03:32:56PM -0700, William Lee Irwin III wrote:
>> I'm working with the following suggestion:
>>
>> On Tue, Apr 17, 2007 at 09:07:49AM -0400, James Bruce wrote:
>>> Nonlinear is a must IMO.  I would suggest X = exp(ln(10)/10) ~= 1.2589
>>> That value has the property that a nice=10 task gets 1/10th the cpu of a
>>> nice=0 task, and a nice=20 task gets 1/100 of nice=0.  I think that
>>> would be fairly easy to explain to admins and users so that they can
>>> know what to expect from nicing tasks.
>> I'm not likely to write the testcase until this upcoming weekend, though.
> 
> So that means there's a 10000:1 ratio between nice 20 and nice -19. In
> that sort of dynamic range, you're likely to have non-trivial
> numerical accuracy issues in integer/fixed-point math.

Well, you *are* specifying vastly different priorities.  The question is 
how many nice=20 tasks should it take to interfere with a nice=-19 task? 
  If you've only got a 100:1 ratio, 100 nice=20 tasks will take ~50% of 
the CPU away from a nice=-19 task.  I don't think that's ideal, as in my 
mind a -19 task shouldn't have to care how many nice=20 tasks there are 
(within reason).  IMHO, if a user is running a CPU hog at nice=-19, and 
expecting nice=20 tasks to run immediately, I don't think the scheduler 
is the problem.

> (Especially if your clock is jiffies-scale, which a significant number
> of machines will continue to be.)
> 
> I really think if we want to have vastly different ratios, we probably
> want to be looking at BATCH and RT scheduling classes instead.

I, like all users, can live with anything, but there should be a clear 
specification of what the user should expect.  Magic changes in the 
function at nice=0, or no real clear meaning at all (mainline), are both 
things that don't help the users to figure that out.  I like the 
exponential base because shifting all tasks up or down one nice level 
does not change the relative cpu distribution (i.e. two tasks 
{nice=-5,nice=0} get the same relative cpu distribution as if they were 
{nice=0,nice=5}.  An exponential base is the only way that property can 
hold.

Now, perhaps implementation issues may prevent something like the 
"1.2589" ratio rule from being realized, but I'm not sure we should 
throw it out _before_ we know that it's actually a problem.  This is the 
same sort of resistance that the timekeeping code updates faces (using 
nanoseconds everywhere instead of "natural" clock bases), but that got 
addressed eventually.

  - Jim Bruce

