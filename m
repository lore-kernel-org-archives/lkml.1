Return-Path: <linux-kernel-owner+w=401wt.eu-S1763599AbYDPNC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763599AbYDPNC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbYDPNCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:02:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34416 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbYDPNCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:02:21 -0400
Message-ID: <4805F8D0.7000203@firstfloor.org>
Date: Wed, 16 Apr 2008 15:02:08 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: Does process need to have a kernel-side stack all the time?
References: <200804141547.57719.vda.linux@googlemail.com> <87hce4uya8.fsf@basil.nowhere.org> <20080416124728.GA5050@elte.hu>
In-Reply-To: <20080416124728.GA5050@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> no, the primary motivation Arjan and me started working on 4K stacks and 
> implemented it was what Denys mentioned: i had a testcase that ran 
> 50,000 threads before it ran out of memory - i wanted it to run 100,000 
> threads. The improved order-0 behavior was just icing on the cake.

I checked the original changelog and it mentions both with the
dumb reason covered in one sentence and the stall issue deserving
a full paragraph.

Well frankly that was a dumb reason then.  Ok I hadn't imagined you
both really spent time on something dumb :) The stall reason
at least made some sense, although I suspect it is obsolete by now.

My objection to the 100k threads would be less that they
shouldn't be needed (we all know that user space does dumb things), but
that when you have them either with 4k stacks (or 50k threads with 8k
stack) you're dangerously near lowmem exhaustion on 32bit and then
sooner or later the system will have trouble anyways from low lowmem.
It's fundamentally not a reliable setup.

-Andi

