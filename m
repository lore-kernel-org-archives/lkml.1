Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYENWWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYENWWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYENWVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:21:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50339 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYENWVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:21:53 -0400
Message-ID: <482B65FE.4040402@firstfloor.org>
Date: Thu, 15 May 2008 00:21:50 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
References: <20080514174955.GA515@elte.hu> <6457.1210801515@vena.lwn.net> <87bq387cyn.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805141515020.3019@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805141515020.3019@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 15 May 2008, Andi Kleen wrote:
>> The goal less being to get rid of BKL in old drivers, but not 
>> requiring BKL in new drivers. Basically all BKL assumptions
>> in interfaces really should go.
> 
> No, we really do want to get rid of BKL in old drivers too. Or at least in 
> the interfaces.

In the interfaces definitely yes and all subsystems should have their
own lock_kernel calls, but why in the old drivers? For those it's very
unlikely they are used on any SMP system anyways (e.g. anything
depending on CONFIG_ISA) or if they do only on 2 CPU systems.

Of course if you can find someone to do the work it wouldn't be
bad, just wouldn't seem like a particularly useful investment of time to
me.

Also it would be bad if the people who did such conversions didn't
actually test it and that's a great danger with many old drivers because
nearly nobody has the hardware (and if they do it won't be in a SMP system)

-Andi

