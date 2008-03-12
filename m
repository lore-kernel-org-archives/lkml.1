Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbYCLIvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbYCLIvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 04:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYCLIvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 04:51:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:37348 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYCLIvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 04:51:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,486,1199692800"; 
   d="scan'208";a="305544589"
Subject: Re: 2.6.25-rc4-git3: Reported regressions from 2.6.24
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <200803100132.57160.rjw@sisk.pl>
References: <200803100132.57160.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Date: Wed, 12 Mar 2008 16:48:15 +0800
Message-Id: <1205311695.3215.26.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-10 at 01:32 +0100, Rafael J. Wysocki wrote:
> [Due to the lack of time for reviewing all of the email threads related to the
> regressions marked as "unresolved" below, I might have missed some patches
> fixing them.  If you are involved in debugging/fixing any of them, please let
> me know if I should update the list.  Thanks!]
> 
> This message contains a list of some regressions from 2.6.24 reported since
> 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> of.  If any of them have been fixed already, please let me know.
> 
> If you know of any other unresolved regressions from 2.6.24, please let me know
> either and I'll add them to the list.  Also, please let me know if any of the
> entries below are invalid.
> 
> 
> Listed regressions statistics:
> 
>   Date          Total  Pending  Unresolved
>   ----------------------------------------
>   2008-03-10      138       66          47
>   2008-03-03      115       65          49
>   2008-02-25       90       51          39
>   2008-02-17       61       45          37
> 
> 
> Unresolved regressions
> ----------------------
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
> Subject		: 2.6.25-rc1: volanoMark 45% regression
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2008-02-13 10:30
> References	: http://lkml.org/lkml/2008/2/13/128
> Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 		  Balbir Singh <balbir@linux.vnet.ibm.com>
Peter reverted the load balance patch and 2.6.25-rc4 accepted the reverting patch.

With kernel 2.6.25-rc5, volanoMark has about 6% regression on my 16-core tigerton. If I apply
patch http://lkml.org/lkml/2008/2/20/83 which fixes the tbench regression issue, volanoMark
regression becomes about 4%.

I tried to bisect down which patch caused the last 4%, but found it's very hard. One thing
is many patches depend on the reverted patches. The other thing is I find the testing result
isn't stable since 2.6.25-rc1. The result variation might be more than 15% sometimes. I ran the
testing against the same kernel for many times to get the best result.

I also tried to tune some sched_XXX parameters under /proc/sys/kernel, but didn't get better result
than the default configuration.

Above regression exists on the 2.93GHz 16-core tigerton. With the less powerful 2.40GHz 16-core
tigerton, the regression is less than 1%, but result is not stable and results of many runs might have
about 15% variation.

On 8-core stoakley, the regression is about 1%.

Sorry for the late update.

-yanmin


