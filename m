Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYERUKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYERUKu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 16:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYERUKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 16:10:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57145 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753707AbYERUKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 16:10:41 -0400
Date: Sun, 18 May 2008 20:58:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: corbet@lwn.net (Jonathan Corbet)
Cc: Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill empty chardev open/release methods
Message-ID: <20080518205823.4a79aa0f@core>
In-Reply-To: <11727.1211139999@vena.lwn.net>
References: <20080516215517.30101a39@core>
	<11727.1211139999@vena.lwn.net>
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


> As it turns out, a misc driver will still be OK because the BKL has not
> (yet) been pushed past misc_open().  What this does mean, though, is
> that all of those empty and trivial open functions need to be
> revisited.  I thought this looked too easy the first time through...

I think it would be best to make them lock/unlock kernel in the first
pass and then work through them. The BKL can be subtle and evil, but as I
brought it into the world I guess I must banish it ;)


Alan
