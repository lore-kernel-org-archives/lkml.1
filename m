Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYCJWUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYCJWUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYCJWU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:20:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35338 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751515AbYCJWUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:20:25 -0400
Date: Mon, 10 Mar 2008 22:06:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ioctl: locking for tty_wait_until_sent
Message-ID: <20080310220643.60f36bee@core>
In-Reply-To: <87od9m5iu4.fsf@basil.nowhere.org>
References: <20080310215325.2b8d33e8@core>
	<87od9m5iu4.fsf@basil.nowhere.org>
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

On 10 Mar 2008 23:12:51 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> > This function still depends on the big kernel lock in some cases. Push
> > locking into the function ready for removal of the BKL from ioctl call
> > paths.
> 
> Didn't you forget the .ioctl -> .unlocked_ioctl change?

We are not yet ready to unlock the device ioctl paths for tty. We still
explicitly take the BKL in the ioctl paths when calling the following
methods

driver:
	->wait_until_sent()
	->break_ctl()
	->tiocmget
	->tiocmset
	->ioctl
ldisc:
	->ioctl

As well as all the open/close/hangup/ldisc change logic

I'm pretty close to removing it from the modem , ioctl and break methods
and its working for me but needs a few drivers tweaking further.

