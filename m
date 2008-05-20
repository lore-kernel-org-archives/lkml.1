Return-Path: <linux-kernel-owner+w=401wt.eu-S932960AbYETTFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbYETTFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764557AbYETTFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:05:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34314 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763428AbYETTFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:05:03 -0400
Date: Tue, 20 May 2008 19:51:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH, RFC] char dev BKL pushdown
Message-ID: <20080520195157.50384ac9@core>
In-Reply-To: <200805201921.53530.arnd@arndb.de>
References: <25447.1211296423@vena.lwn.net>
	<200805201921.53530.arnd@arndb.de>
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

> Right, unless Alan or Wim are confident enough that removing the
> BKL won't break the drivers (more than they are today).
> Almost all of the open functions go along the lines of
> 
> int open(struct file *f, struct inode *i)
> {
> 	if (wd_is_open)
> 		return -EBUSY;
> 	wd_is_open = 1;
> 	
> 	start_wd();
> 
> 	return nonseekable_open(f, i);
> }
> 
> nonseekable_open doesn't need the BKL by itself, and the wd_is_open
> variable is protected by the misc_mtx mutex.
> I can't see any scenario in which start_wd() would need the BKL, or

You need to review the use of misc_register(). Which is what I did
already and sorted out for each watchdog - the job is done and completed
and the various problem cases fixed. Watchdog has already been made BKL
removal safe in the patch series I sent.

Alan
