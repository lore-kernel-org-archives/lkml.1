Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYEONmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYEONmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYEONmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:42:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35454 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751563AbYEONmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:42:14 -0400
Date: Thu, 15 May 2008 14:30:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080515143048.13a137ea@core>
In-Reply-To: <482B65FE.4040402@firstfloor.org>
References: <20080514174955.GA515@elte.hu>
	<6457.1210801515@vena.lwn.net>
	<87bq387cyn.fsf@basil.nowhere.org>
	<alpine.LFD.1.10.0805141515020.3019@woody.linux-foundation.org>
	<482B65FE.4040402@firstfloor.org>
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

> own lock_kernel calls, but why in the old drivers? For those it's very
> unlikely they are used on any SMP system anyways (e.g. anything
> depending on CONFIG_ISA) or if they do only on 2 CPU systems.

Because

- You need to verify the locking assumptions that remain are entirely
driver internal
- At the point you achieve that you've done *ALL* the work required to
add a driver specific lock

