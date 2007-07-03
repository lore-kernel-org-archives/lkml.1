Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbXGCWZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbXGCWZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbXGCWZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:25:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39954 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753077AbXGCWZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:25:21 -0400
Date: Tue, 3 Jul 2007 23:31:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Morten Helgesen <morten@sourcepoet.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] genericserial: Remove bogus optimisation check and dead
 code paths
Message-ID: <20070703233135.502bba84@the-village.bc.nu>
In-Reply-To: <468AC156.5040402@sourcepoet.org>
References: <20070703152021.6eb8013d@the-village.bc.nu>
	<468A5F89.70900@sourcepoet.org>
	<20070703162655.6a001fdc@the-village.bc.nu>
	<468AC156.5040402@sourcepoet.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jul 2007 23:36:22 +0200
Morten Helgesen <morten@sourcepoet.org> wrote:


>  /*
>  > Problems to take into account are:
>  >       -1- Interrupts that empty part of the buffer.
> ->       -2- page faults on the access to userspace. 
> +>       -2- Page faults on access to userspace. 

#2 no longer applies (don't before the caller)
>  >       -3- Other processes that are also trying to do a "write".   
#3 no longer applies (locked by tty layer)

> -	/* get exclusive "write" access to this port (problem 3) */
> +	/* Get exclusive "write" access to this port (problem 3) */
>  	/* This is not a spinlock because we can have a disk access (page 
> -		 fault) in copy_from_user */

No copy_from_user any more. Actually that locking code wants review and
maybe removal so is another project altogether


Definitely an improvement

Acked-by: Alan Cox <alan@redhat.com>
