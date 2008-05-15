Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbYEONqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbYEONqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYEONqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:46:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35462 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753887AbYEONqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:46:01 -0400
Date: Thu, 15 May 2008 14:34:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080515143430.6a94508d@core>
In-Reply-To: <482B61C2.9070106@firstfloor.org>
References: <20080514174955.GA515@elte.hu>
	<87fxsk7n7e.fsf@basil.nowhere.org>
	<20080514220034.51eae9e0@core>
	<482B5614.3060203@firstfloor.org>
	<20080514221957.6edb2d60@core>
	<alpine.LFD.1.10.0805141435540.3019@woody.linux-foundation.org>
	<482B61C2.9070106@firstfloor.org>
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

> >  - superblock read/write.
> > 
> - fasync
> 
> [had some patches for "fasync_locked", not sure if it's worth it]
> 
> - character device open

file structures - as well

> I tried to recruit kernel janitors some time ago to just do all the
> ioctl -> ioctl_unlocked/explicit lock_kernel changes. There were a few
> patches generated but the effort died down then.

Start at the other end - you can't fix the ioctls until you fix what the
ioctls interact with. That ends up at the basic data structure and once
you fix those the rest just starts to fall into place.
