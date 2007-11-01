Return-Path: <linux-kernel-owner+w=401wt.eu-S1760085AbXKAW2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085AbXKAW2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbXKAW2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:28:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38429 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753802AbXKAW2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:28:47 -0400
Date: Thu, 1 Nov 2007 22:30:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: davem@davemloft.net
Subject: Re: [IRDA] IRNET: Fix build when TCGETS2 is defined.
Message-ID: <20071101223010.6780cc98@the-village.bc.nu>
In-Reply-To: <200711011959.lA1JxPWc003735@hera.kernel.org>
References: <200711011959.lA1JxPWc003735@hera.kernel.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 19:59:25 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=49259d34c52df6be482fefca946debe28ba9a2f6
> Commit:     49259d34c52df6be482fefca946debe28ba9a2f6
> Parent:     3b582cc14c50f71eabf1c3cada05acb8dc9f457c
> Author:     David S. Miller <davem@sunset.davemloft.net>
> AuthorDate: Thu Nov 1 02:26:38 2007 -0700
> Committer:  David S. Miller <davem@sunset.davemloft.net>
> CommitDate: Thu Nov 1 02:26:38 2007 -0700
> 
>     [IRDA] IRNET: Fix build when TCGETS2 is defined.
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>

NO NO NO NO NO NO NO

Line disciplines have no business touching termios ioctls. Especially
wrongly. 

Nothing anywhere in the kernel but the core ioctl code should be
processing TCGET/TCSET calls.

Just delete them. It will return -ENOIOCTLCMD and the core tty layer will
process them.

Alan
