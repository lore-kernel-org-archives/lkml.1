Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbYHGNQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbYHGNQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYHGNOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:14:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49527 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754013AbYHGNOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:14:45 -0400
Date: Thu, 7 Aug 2008 11:15:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: md@google.com (Michael Davidson)
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: prevent binaries from making system calls using
 the wrong syscall interface
Message-ID: <20080807111539.2895a2c4@lxorguk.ukuu.org.uk>
In-Reply-To: <20080807003459.37CC629624@localhost>
References: <20080807003459.37CC629624@localhost>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently there is nothing to prevent 64 bit binaries from
> attempting to make system calls using the 32 bit system call
> interfaces and vice versa.

What about applications that choose to do this
- Test tools
- Tools where certain interfaces are only available 32bit ?

> Since the 32 bit and 64 bit system call numbers are different
> this means that a binary could attempt to obfuscate which system
> calls it was actually making by using the "wrong" system call
> interface. In particular, the call to audit_syscall_entry()
> relies on checking the TIF_IA32 flag to determine whether it is
> dealing with a 32 or 64 bit system call without regard to the
> actual type of system call that was made.While this specific issue
> could be addressed by checking the TS_COMPAT flag in threadinfo_status
> it seems preferable to simply disallow this situation altogether.

That is a significant change of kernel ABI considering it exists just to
wallpaper over crappy audit tools.

I'm definitely against that approach.

Alan
