Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbXLSVjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbXLSVjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 16:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbXLSVjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 16:39:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:21603 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbXLSVjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 16:39:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,186,1196668800"; 
   d="scan'208";a="243699529"
Message-ID: <47698F4E.40209@intel.com>
Date: Wed, 19 Dec 2007 13:38:22 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Parag Warudkar <parag.warudkar@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] e1000: Use deferrable timer for watchdog
References: <Pine.LNX.4.64.0712182040470.3616@mini.warudkars.net>	 <47696AC9.90204@intel.com> <82e4877d0712191139k4dbae463icf2a59c8c0104010@mail.gmail.com>
In-Reply-To: <82e4877d0712191139k4dbae463icf2a59c8c0104010@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2007 21:38:58.0868 (UTC) FILETIME=[90477740:01C84287]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> On 12/19/07, Kok, Auke <auke-jan.h.kok@intel.com> wrote:
> [snip]
> 
>> I can't possibly see any benefit from this other than that you just add up to a
>> whole second to the initialization cycle, which is bad.
>>
> Well, Ok but it can't be bad - I've been using this patch sometime and
> haven't seen any problem at all and powertop shows it reduces the
> wakeups-from-idle.
> 
> But whatever - no big deal since it already uses round_jiffies().

why would this patch reduce wakeups even more than round_jiffies()? Does it make
our ~2 second update interval not reliable? can you quantify "shows it reduces" ?
Or timer only runs once every two seconds...

maybe I just don't understand the effect of timer_set_deferrable() - we're already
deferring it ourselves when we want to. If that is not working then I suggest that
we fix that first instead of postponing the critical first run of the e1000
watchdog task.

People in the datacenter really don't want to see more delays when bringing up
link, and we get frequent calls about it already being long on gigabit (not even
minding spanning tree). Adding 25% to that time isn't going to down very nicely
with them.
