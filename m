Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYAPN4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYAPN4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 08:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYAPN43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 08:56:29 -0500
Received: from www.tglx.de ([62.245.132.106]:45742 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYAPN43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:56:29 -0500
Date: Wed, 16 Jan 2008 14:54:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <efault@gmx.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [clocksource] jiffies as clocksource kills box
In-Reply-To: <1200376168.4137.40.camel@homer.simson.net>
Message-ID: <alpine.LFD.0.99999.0801161449160.3764@localhost.localdomain>
References: <1200376168.4137.40.camel@homer.simson.net>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008, Mike Galbraith wrote:

> Greetings,
> 
> Per $subject, echo jiffies > current_clocksource pretty thoroughly kills
> my P4 box, and does so with every kernel I have (2.6.22->present).  I
> can drive the box via mouse clicks and poke around, but trying to select
> another clocksource thereafter is nogo.. cat current_clocksource emits
> jiffies, and box remains comatose unless prodded.

I guess your box has high resolution timers and/or dynamic ticks
enabled. In that case we really can not switch to jiffies. We also
have to prevent PIT from being selected. 

I have a patch pending for the PIT issue. Will add jiffies to this as
well.

We'll fix that in .25 as it requires root user interaction and does
not show up magically.

Thanks,
	tglx
