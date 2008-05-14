Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYENV3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYENV3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbYENV3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:29:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47058 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750828AbYENV3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:29:15 -0400
Date: Wed, 14 May 2008 22:17:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080514221730.5334246d@core>
In-Reply-To: <482B56B9.8040703@zytor.com>
References: <20080514174955.GA515@elte.hu>
	<87fxsk7n7e.fsf@basil.nowhere.org>
	<20080514220034.51eae9e0@core>
	<482B5614.3060203@firstfloor.org>
	<482B56B9.8040703@zytor.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So you just stick unlock_kernel()/lock_kernel() around the call
> > to TTY (or similar to the entry points)
> > 
> 
> ... assuming that the ISDN code doesn't assume lock continuity across 
> the TTY call.

And procfs and between the tty and the net config code and ...

Keeping the BKL just in legacy places doesn't work. A counting mutex (ie
one you can self multi-lock) might be very useful to fix some of these
however as once we push it down to the point of being a driver specific
lock we can just give it a driver mutex
