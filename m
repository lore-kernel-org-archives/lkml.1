Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYKNBa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYKNBa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbYKNBZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:25:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55011 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbYKNBZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:25:32 -0500
Message-ID: <491CD248.8030209@zytor.com>
Date: Thu, 13 Nov 2008 17:20:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104210643.GH29626@one.firstfloor.org> <20081105102643.GA11383@elte.hu> <200811141211.23496.nickpiggin@yahoo.com.au>
In-Reply-To: <200811141211.23496.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> 
> I heard from an Intel hardware engineer that Nehalem has some
> really fancy logic in it to make locked instructions "free", that
> was nacked from earlier CPUs because it was too costly. So obviously
> it is taking a fair whack of transistors or power for them to do it.
> And even then it is far from free, but still seems to be one or two
> orders of magnitude more expensive than a regular instruction.
> 

Last I heard it was still a dozen-ish cycles even on Nehalem.

> 
> IMO, we shouldn't stop bothering about LOCK prefix in the forseeable
> future.
> 

Even if a CPU came out *today* that had zero-cost locks we'd have to
worry about it for at least another 5-10 years.  The good news is that
we're doing pretty good with it for now, but I don't believe in general
we can avoid the fact that improving LOCK performance helps everything
when you're dealing with large numbers of cores/threads.

	-hpa

