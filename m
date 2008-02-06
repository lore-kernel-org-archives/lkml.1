Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbYBFVva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbYBFVva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758735AbYBFVvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:51:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52455 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYBFVvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:51:19 -0500
Subject: Re: RT scheduler config, suggestions and questions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47A9F6BE.1010800@qualcomm.com>
References: <47A8F328.5070107@qualcomm.com>
	 <1202279815.19243.34.camel@lappy> <1202297381.19243.48.camel@lappy>
	 <47A9F6BE.1010800@qualcomm.com>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 22:50:55 +0100
Message-Id: <1202334655.6274.4.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-06 at 10:04 -0800, Max Krasnyanskiy wrote:
> Peter Zijlstra wrote:
> > On Wed, 2008-02-06 at 07:36 +0100, Peter Zijlstra wrote:
> > 
> >>> btw I can see "watchdog" being very useful to catch hard-RT tasks that exceed the deadline.
> >>> But's it gotta be per thread.
> >> It is.
> >>
> >>> Single setting per user is not enough. Unless a use has a single RT task.
> >> ?
> > 
> > Ah, its starting to make sense, you want it configurable per thread, not
> > process wide. Yes, I see how that is useful, just no idea how to expose
> > that to user-space atm.
> Yes. That's what I meant. I don't think overall per process setting is that useful.
> Per thread though would be useful.
> 
> How to expose that to the user-space ? The best option in my opinion is to extend
> struct sched_param. That way both sched_setparam() and pthread_attr_setschedparam() 
> can be used to set new attributes and it's backwards compatible.
> Something like:
> 
> struct sched_param {
> 	...
> 	unsigned int sched_rt_limit;
> 	unsigned int sched_rt_...;
> };

I'm somewhat afraid to touch sched_param, but it seems I need to change
it anyway soonish, so I'd better figure out how to do that.



