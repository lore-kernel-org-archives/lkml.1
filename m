Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbYHFFEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbYHFFEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYHFFDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:03:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61156 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbYHFFDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:03:54 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5354"; a="5350575"
Message-ID: <489930B5.9030906@qualcomm.com>
Date: Tue, 05 Aug 2008 22:03:49 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>	<20080802063900.6615e5ca.pj@sgi.com>	<48948C3A.6050805@qualcomm.com>	<20080802225127.2b0d138b.pj@sgi.com>	<4895F3ED.4020805@qualcomm.com>	<20080804010033.0d1b0549.pj@sgi.com>	<48977E81.4040207@qualcomm.com>	<20080804225636.541527e8.pj@sgi.com>	<4898B873.6000308@qualcomm.com>	<20080805180521.be7010e1.pj@sgi.com>	<48991973.90109@qualcomm.com>	<20080805222927.6dd95f5f.pj@sgi.com>	<4899202B.6030303@qualcomm.com> <20080805232856.78dd50f7.pj@sgi.com>
In-Reply-To: <20080805232856.78dd50f7.pj@sgi.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> ... the wrong part of my reply ...
> 
> Was the right part where you wrote:
>> We'd actually be changing more things.
> 
> I also don't care that much how much code is changed;
> if it must be changed, then change it to what is best,
> which may not necessarily be the minimum change.
Sure. What I'm saying is that I do not think it's the best
to change all the paths to be async.

> If an asynchronous sched domain rebuild is needed in
> some places, then consider just using it everywhere,
> rather than providing two code paths to rebuild, one
> sync and one async.
I still do not see a good reason why. IMO exceptions are acceptable.
Only domain rebuilds triggered by cpuset fs writes need to be async.
I do not see a good technical reason why the rest needs to be converted
and retested.

> Ask not how we got here; ask where we should be.
> 
> In particular, and in this specific case, having the
> dual code paths really did make it a little more difficult
> for me to understand the code, as evidenced by the back
> and forth discussion on how to name the confusingly
> similar functions.  Such naming controversies are usually
> a sign of code duplication or improper factoring.
I'm not sure what you're referring to. There was no back an forth.
You suggested reverting the rename and I pointed out that it was not
a rename, I simply factored out the part that generates the
masks. That was it.

> That additional difficulty in understanding this code
> was a key factor in delaying my review of your code.
> I'd look at it, my mind was glaze over, and I'd put
> it aside for a few days.  This happened repeatedly.
> 
> Fine code is like fine art ... spare, elegant, compelling
> in its expression.
To be fair the fact that you had trouble understanding my code does
not automatically mean that it was not artistic ;-).

Max
