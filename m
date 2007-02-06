Return-Path: <linux-kernel-owner+w=401wt.eu-S1030554AbXBFXLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030554AbXBFXLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030553AbXBFXLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:11:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54771 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030554AbXBFXLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:11:35 -0500
Date: Tue, 6 Feb 2007 15:11:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <20070206143956.b09c674d.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0702061505400.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>
 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
 <1170710272.29759.894.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
 <1170711587.29759.909.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
 <1170712393.29759.925.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>
 <20070205143110.fca62b57.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
 <1170717694.29759.941.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702051525320.8424@woody.linux-foundation.org>
 <1170755101.29759.960.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702060841440.8424@woody.linux-foundation.org>
 <1170801484.29759.1000.camel@pmac.infradead.org> <20070206143956.b09c674d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Feb 2007, Randy Dunlap wrote:
> 
> Yes, that's the solution that I decided on during lunch also:
> 	select <==> depends on

I think yuou can certainly enable an "expert mode", which just reads 
"select" as "depends on".

You'll probably have to do *more* changes to the tools than my suggestion 
to just make them let you know why they can't turn something off, though. 
Why? Some things don't even have questions at all right now, and their 
only life is as implied options that are turned on by others.

And yes, some silly people who hate "select" have tried to turn them into

	bool SUBSYSTEM
		default y
		depends on X || Y || Z || XY || XZ || YZ

or similar, which is a hell of a lot less maintainable than just letting 
X, Y, Z etc do 'select SUBSYSTEM'.

But "select SUBSYSTEM" still does exist, notably in places like SND_PCM 
(where it would just be INSANE to list all the different sound drivers 
that want it as a shitload of "depends on") but also for things like 
NET_CLS and CRYPTO etc.

		Linus
