Return-Path: <linux-kernel-owner+w=401wt.eu-S1760599AbYFTVog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599AbYFTVog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYFTVo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:44:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40128
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbYFTVoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:44:25 -0400
Date: Fri, 20 Jun 2008 14:44:24 -0700 (PDT)
Message-Id: <20080620.144424.168785883.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806201723120.14221@engineering.redhat.com>
References: <Pine.LNX.4.64.0806201707270.8990@engineering.redhat.com>
	<20080620.142034.30884440.davem@davemloft.net>
	<Pine.LNX.4.64.0806201723120.14221@engineering.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Fri, 20 Jun 2008 17:25:26 -0400 (EDT)

> On Fri, 20 Jun 2008, David Miller wrote:
> 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > Date: Fri, 20 Jun 2008 17:14:41 -0400 (EDT)
> >
> > It means i386 and every other platform potentially has the same exact
> > problem.
> >
> > What point wrt. sparc64 are you trying to make here? :-)
> 
> The difference is that i386 takes minimum 4 bytes per stack frame and 
> sparc64 192 bytes per stack frame. So this problem will kill sparc64 
> sooner.
> 
> But yes, it is general problem and should be solved in arch-independent 
> code.

I agree on both counts.  Although I'm curious what the average stack
frame sizes look like on x86_64 and i386, and also how this area
appears on powerpc.

One mitigating factor on sparc64 is that typically when there are lots
of devices with interrupts there are also lots of cpus, and we evenly
distribute the IRQ targetting amongst the available cpus on sparc64.

This is probably why, in practice, these problems tend to not surface
often.

In any event, with the work you've accomplished and my implementation
of IRQ stacks for sparc64 we should be able to get things in much
better shape.
