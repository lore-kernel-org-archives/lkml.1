Return-Path: <linux-kernel-owner+w=401wt.eu-S1030394AbXBZSMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030394AbXBZSMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030395AbXBZSMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:12:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50783
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030392AbXBZSMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:12:20 -0500
Date: Mon, 26 Feb 2007 10:12:19 -0800 (PST)
Message-Id: <20070226.101219.18306730.davem@davemloft.net>
To: j.j.green@sheffield.ac.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: sparc64 / bbc_i2c.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0702252352310.32309@parallax.ddns.shef.ac.uk>
References: <1171978032.18442.11.camel@lax.shef.ac.uk>
	<20070225044754.1d849a8d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702252352310.32309@parallax.ddns.shef.ac.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J.J.Green" <j.j.green@sheffield.ac.uk>
Date: Sun, 25 Feb 2007 23:58:48 +0000 (GMT)

> Hi Andrew
> 
> > The code around there looks relatively unbuggy to me.  Removing that
> > remove_wait_queue() would be very bad - it would cause later stack
> > corruption.
> >
> > msleep_interruptible() certainly shouldn't consume CPU like that.  Do we
> > know where the CPU time is being spent?  The output of:
> >
> > readprofile -r
> > sleep 10
> > readprofile -n -v -m /boot/System.map | sort -n -k 3 | tail -40
> >
> > would tell us.
> 
> As was mentioned in another reply, this message by
> Joerg Friedrich
> 
>    http://lists.debian.org/debian-sparc/2007/02/msg00045.html
> 
> gives a possible explanantion of where the time is going.
> I applied the patch to the debian kernel sources for 2.6.18,
> it applied cleanly and fixed the problem.

I've added Joerg's patch to my tree and will push it into
-stable as well.

Reviewing this patch had been sitting deep in my backlog for weeks, I
just never got around to it, sorry.
