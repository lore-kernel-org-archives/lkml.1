Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbZJMM5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbZJMM5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZJMM5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:57:07 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:49197 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbZJMM5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:57:06 -0400
Date: Tue, 13 Oct 2009 18:26:14 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>, vatsa@in.ibm.com,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
Message-ID: <20091013125614.GE26069@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20090930124919.GA19951@in.ibm.com> <4AC35EDD.1080902@openvz.org> <20090930142537.GJ19951@in.ibm.com> <20090930143953.GA2014@in.ibm.com> <4AD466E5.4010206@openvz.org> <20091013120354.GF24787@MAIL.13thfloor.at> <4AD4705D.6020109@openvz.org> <20091013123047.GC26069@linux.vnet.ibm.com> <4AD4765B.3010907@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD4765B.3010907@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 04:45:15PM +0400, Pavel Emelyanov wrote:
> Dhaval Giani wrote:
> > On Tue, Oct 13, 2009 at 04:19:41PM +0400, Pavel Emelyanov wrote:
> >>> as I already stated, it seems perfectly fine for me 
> >> You're not the only one interested in it, sorry. Besides, I
> >> got your point in "I'm find with it". Now get mine which is
> >> about "I am not".
> >>
> >>> can be trivially mapped to the two values, by chosing a
> >>> fixed multiplicative base (let's say '1s' to simplify :) 
> >>>
> >>>   with 50%, you get 1s/0.5s
> >>>   with 20%, you get 1s/0.2s
> >>>   with  5%, you get 1s/0.05s
> >>>
> >>> well, you get the idea :)
> >> No I don't.
> >> Is 1s/0.5s worse or better than 2s/1s?
> >> How should I make a choice?
> > 
> > I would say it depends on your requirement. How fast do you want to
> > respond back to the user? Wiht lower bandwidth, you would want to have
> > shorter periods so that the user would not get the impression that he
> > has to "wait" to get CPU time. But having a very short period is not a
> > good thing, since there are other considerations (such as the overhead of
> > hard limits).
> 
> That's it - long period is bad for one reason, short period is bad for 
> some other one and neither of them is clearly described unlike the 
> limit itself.
> 
> In other words there are two numbers we're essentially playing with:
> * the limit (int percents, Hz, whatever)
> * and this abstract "badness"
> 
> Can't we give the user one of them for "must be configured" usage, put
> the other one in some "good for most users" position and let the user
> move it later on demand?
> 

Right, but is this not more of a policy decision as opposed to an
infrastructure one and better handled in userspace?

> Yet again - weights in CFQ CPU-sched, ionoce in CFQ-iosched, bandwidth
> in tc (traffic shaping), etc. are all clean for end-user. Plus there are
> other fine tunes, that user should not configure by default, but which
> change the default behavior. I propose to create simple and clean 
> interface for limits as well. If you think that virtual cpu power is 
> not good, ok. Let's ask user for a percentage and give him yet another
> option to control this "badness" or "responsiveness".
> 

How is virtual cpu power defined? GHz is not a clear definition. It
means different things (in terms of performance) for different
processors. Do you want to define it as getting x cycles of a CPU in
y seconds for the cgroup, or do you want to define it as a certain number
of operations in a second. If it is the former, I think we can map it to
the current interface in userspace itself.  Why don't we define this
metric, and then look to solve the problem? 

thanks,
-- 
regards,
Dhaval
