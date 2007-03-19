Return-Path: <linux-kernel-owner+w=401wt.eu-S932495AbXCSVKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495AbXCSVKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbXCSVKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:10:51 -0400
Received: from main.gmane.org ([80.91.229.2]:42348 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495AbXCSVKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:10:50 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: is RSDL an "unfair" scheduler too?
Date: Mon, 19 Mar 2007 17:14:49 -0400
Message-ID: <45FEFD49.2080507@tmr.com>
References: <200703042335.26785.a1426z@gawab.com> <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru> <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu> <45FC525D.5000708@argo.co.il> <20070318012533.GB2986@holomorphy.com> <Pine.LNX.4.64.0703171830130.4964@woody.linux-foundation.org> <20070318052439.GT943@1wt.eu> <20070318060949.GA13583@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <20070318060949.GA13583@gnuppy.monkey.org>
Cc: ck@vds.kolivas.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Huey (hui) wrote:
> On Sun, Mar 18, 2007 at 06:24:40AM +0100, Willy Tarreau wrote:
>>> Dunno. I guess a lot of people would like to then manage the classes, 
>>> which would be painful as hell. 
>> Sure ! I wouldn't like people to point the finger on Linux saying "hey
>> look, they can't write a good scheduler so you have to adjust the knobs
>> yourself!". I keep in mind that Solaris' scheduler is very good, both
>> fair and interactive. FreeBSD was good (I haven't tested for a long time).
>> We should manage to get something good for most usages, and optimize
>> later for specific uses.
> 
> Like I've said in a previous email, SGI schedulers have an interactive
> term in addition to the normal "nice" values. If RSDL ends up being too
> rigid for desktop use, then this might be a good idea to explore in
> addition to priority manipulation.
> 
> However, it hasn't been completely proven that RSDL can't handle desktop
> loads and that needs to be completely explored first. It certain seems
> like, from the .jpgs that were posted earlier in the thread regarding mysql
> performance, that RSDL seems to have improved performance for those set
> ups so it's not universally the case that it sucks for server loads. The
> cause of this performance difference has yet to be pinpointed.

I would say that RSDL is probably a bit better than default for server 
use, although if the server starves for CPU interactive processing at 
the console becomes leisurely indeed. The only thing I would like to 
address is the order of magnitude blips in latency of nice processes, 
which may be solved by playing with time slices. Con hasn't really 
commented on that (or I haven't read down to it).

> 
> Also, bandwidth scheduler like this are a new critical development for
> things like the -rt patch. It would benefit greatly if the RSDL basic
> mechanisms (RR and deadlines) were to somehow slip into that patch and
> be used for a more strict -rt based scheduling class. It would be the basis
> for first-class control over process resource usage and would be a first
> in Linux or any mainstream kernel.

I don't think that RSDL and -rt should be merged, but that's for Ingo 
and Con to discuss. I would love to see RSDL in mainline as soon as it 
is practical, marked as EXPERIMENTAL.
> 
> This would be a powerful addition to Linux as a whole and RSDL should
> not be dismissed without these considerations. If it can somehow be
> integrated into the kernel with interactivity concerns addressed, then
> it would be an all out win for the kernel in both these areas.
> 
I don't think there are a lot of places where it underperforms the 
default scheduler, and it avoids a lot of jackpot cases where an 
overloaded system really bogs down. I would like to see more varied 
testing before any changes are made, unless a simple change would 
improve consistency of latency.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

