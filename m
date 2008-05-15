Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbYEOPLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbYEOPLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbYEOPLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:11:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46859 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbYEOPLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:11:00 -0400
Message-ID: <482C5281.7020306@firstfloor.org>
Date: Thu, 15 May 2008 17:10:57 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
References: <20080514174955.GA515@elte.hu>	<6457.1210801515@vena.lwn.net>	<87bq387cyn.fsf@basil.nowhere.org>	<alpine.LFD.1.10.0805141515020.3019@woody.linux-foundation.org>	<482B65FE.4040402@firstfloor.org> <18476.20788.142218.370584@stoffel.org>
In-Reply-To: <18476.20788.142218.370584@stoffel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
>>>>>> "Andi" == Andi Kleen <andi@firstfloor.org> writes:
> 
> Andi> Linus Torvalds wrote:
>>> On Thu, 15 May 2008, Andi Kleen wrote:
>>>> The goal less being to get rid of BKL in old drivers, but not 
>>>> requiring BKL in new drivers. Basically all BKL assumptions
>>>> in interfaces really should go.
>>> No, we really do want to get rid of BKL in old drivers too. Or at least in 
>>> the interfaces.
> 
> Andi> In the interfaces definitely yes and all subsystems should have
> Andi> their own lock_kernel calls, but why in the old drivers? For
> Andi> those it's very unlikely they are used on any SMP system anyways
> Andi> (e.g. anything depending on CONFIG_ISA) or if they do only on 2
> Andi> CPU systems.
> 
> I'm still running an SMP server with ISA slots. 

I do too (although one CPU has died recently), but how many ISA devices
do you use in it? Mine used to have a ISA ISDN card, but that was it
and then no ISA anymore even though the slots are still in there.

Also on 2 CPU systems BKL is not that critical anyways. It only starts
to hurt on larger CPU counts.

-Andi

