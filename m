Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYCCMhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYCCMhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYCCMgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:36:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbYCCMgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:36:52 -0500
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] cpuidle: avoid singing capacitors
From: Andi Kleen <andi@firstfloor.org>
References: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
Date: Mon, 03 Mar 2008 13:36:50 +0100
In-Reply-To: <20080229193812.31f45b0c@mjolnir.drzeus.cx> (Pierre Ossman's message of "Fri\, 29 Feb 2008 19\:38\:12 +0100")
Message-ID: <p73mypg6l25.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-list@drzeus.cx> writes:

> Many devices today are of a less than stellar quality, and singing
> transistors are a common problem. A high-pitch noise is created, caused
> by power fluctuations as the processor enters and leaves deep sleep at
> a high frequency.
>
> Instead of just disabling the deep sleep (which wastes power). This
> patch merely reduces the number of times it is entered so that the
> frequency doesn't exceed 500 Hz. That should make sure the problem is
> inaudible.
>
> Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
> --
>
> The basic idea is above, but the implementation doesn't quite work. It seems jiffies is not a good time source in this scenario. The time spent in C3 takes a much bigger hit than I expect. The fact that powertop says that it has an average residency of 200 ms in C2 tells me that those should have been spent in C3.

I like the patch in principle, although I think the threshold should
be configurable, not hard coded.

I haven't checked in detail if that is the case, but you need to make
sure that you only reference jiffies on idle exit after the clock
source has caught up with lost jiffies after idle. That might be 
the cause of your problem.

-Andi
