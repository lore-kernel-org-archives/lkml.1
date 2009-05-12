Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbZELXEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbZELXEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZELXEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:04:16 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:37780 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZELXEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:04:16 -0400
Message-ID: <4A0A0069.4090502@nortel.com>
Date: Tue, 12 May 2009 17:04:09 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jussi Laako <jussi@sonarnerd.net>
CC: Peter Zijlstra <peterz@infradead.org>,
       James Courtier-Dutton <James@superbug.co.uk>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       d.faggioli@sssup.it
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
References: <4959198A.3020209@sonarnerd.net>	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net>	 <1232954745.4863.4.camel@laptop>  <4A07E044.8040807@sonarnerd.net> <1242107859.11251.301.camel@twins> <4A094707.5040307@sonarnerd.net> <4A099670.5060902@nortel.com> <4A09A525.4080107@sonarnerd.net> <4A09AB2E.8030002@nortel.com> <4A09B7A1.2060706@sonarnerd.net>
In-Reply-To: <4A09B7A1.2060706@sonarnerd.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2009 23:04:13.0602 (UTC) FILETIME=[F7927020:01C9D355]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jussi Laako wrote:
> Chris Friesen wrote:
> 
>>Of course, without glibc/pthreads support you would only be able to set
>>the nice level for the current thread since you don't have any way to
>>map from "pthread_t *" to tid.  And you wouldn't be able to create new
>>threads with a particular nice level already set.
> 
> 
> This is the problem... It has to work this way, otherwise it's pretty
> useless.

Then you're hooped, because glibc checks for scheduler policies it
"knows" about.

>>But that argument
>>holds true for a new sched policy as well, because glibc checks the
>>policy internally and only knows about the normal three.
> 
> 
> Don't tell that to my system, where also SCHED_IDLE, SCHED_BATCH (which
> are btw not listed on POSIX either) ...and... SCHED_MM work. It goes
> directly to kernel which does the checks and fails if it sees fit.

Really?  You can call pthread_attr_setschedpolicy() with a policy of
SCHED_MM?  On my copy of glibc 2.8 it explicitly checks for
FIFO/RR/OTHER and anything else is rejected.

Chris
