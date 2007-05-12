Return-Path: <linux-kernel-owner+w=401wt.eu-S1761115AbXELUMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761115AbXELUMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 16:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbXELUMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 16:12:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759022AbXELUMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 16:12:33 -0400
Date: Sat, 12 May 2007 13:11:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Gautham R Shenoy <ego@in.ibm.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] Freezing of kernel threads
In-Reply-To: <alpine.LFD.0.98.0705121241300.3986@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0705121304390.3986@woody.linux-foundation.org>
References: <200705122017.32792.rjw@sisk.pl> <20070512193609.GA31426@in.ibm.com>
 <alpine.LFD.0.98.0705121241300.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 May 2007, Linus Torvalds wrote:
> 
>  - make the rule be that you cannot sleep in the above macro, and make the 
>    rule be that CPU hotplug uses the same mechanisms that module unload 
>    already does!

Side note: we obviously already do the stop_machine_run thing for CPU 
down, so doing it for CPU bringup too would seem to just be a good thing. 
And it means that the locking for CPU's disappearing is the same as the 
locking rules for CPU's appearing: you just want to make sure to disable 
preemption (which you already have to do, to make the "CPU went away" case 
work out).

So how about just making sure "__cpu_up()" gets called with the same 
stop_machine_run() logic? Maybe it's not *quite* a one-liner change, but 
it should come fairly close...

		Linus
