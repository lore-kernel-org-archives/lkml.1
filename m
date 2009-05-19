Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbZESSZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbZESSZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 14:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZESSZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 14:25:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753530AbZESSZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 14:25:13 -0400
Date: Tue, 19 May 2009 11:24:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Martin Knoblauch <spamtrap@knobisoft.de>
cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Rgeression: 2.6.30-rc6-git3 build error - ICE from
 drivers/char/random.c
In-Reply-To: <alpine.LFD.2.01.0905191055410.3301@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0905191122320.3301@localhost.localdomain>
References: <688406.16641.qm@web32603.mail.mud.yahoo.com> <20090518203420.GF2658@calx> <alpine.LFD.2.01.0905181506550.3301@localhost.localdomain> <231530.33013.qm@web32601.mail.mud.yahoo.com> <alpine.LFD.2.01.0905190745230.3301@localhost.localdomain>
 <950448.6018.qm@web32607.mail.mud.yahoo.com> <alpine.LFD.2.01.0905191055410.3301@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 May 2009, Linus Torvalds wrote:
> 
> I guess getting rid of 'jiffies' is also worth it. Even at its very worst, 
> 'get_cycles()' should return jiffy-level information, so adding in jiffies 
> doesn't add anything to it.

I take that back. If there isno TSC at all, "get_cycles()" might just be 
returning zero. So the jiffies fallback is probably better than nothing.

So I'll just remove the (long)&ret part. And you already said that that 
fixed it both with my previous patch and without, so I guess it's already 
tested.

		Linus
