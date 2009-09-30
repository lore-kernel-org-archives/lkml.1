Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZI3L1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZI3L1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 07:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZI3L1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 07:27:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43856 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751405AbZI3L1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 07:27:43 -0400
Date: Wed, 30 Sep 2009 12:28:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dhowells@redhat.com,
       akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove pty_ops_bsd and pty_bsd_ioctl() as they're not
 used
Message-ID: <20090930122823.685d4e7e@lxorguk.ukuu.org.uk>
In-Reply-To: <29895.1254306000@redhat.com>
References: <alpine.LFD.2.01.0909290909280.6996@localhost.localdomain>
	<alpine.LFD.2.01.0909280743310.3349@localhost.localdomain>
	<20090928135332.4300.56046.stgit@warthog.procyon.org.uk>
	<20090928151628.62955233@lxorguk.ukuu.org.uk>
	<395.1254239745@redhat.com>
	<29895.1254306000@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> Also, does it matter if someone issues TIOCGPTN on a legacy pty master?  There
> is a number in tty->index that can be returned.  If it can, then

Not a lot - providing someone isn't using it as a way to tell pty types
apart (which I have seen done in example code)

> pty_bsd_ioctl() can be merged with pty_unix98_ioctl(), and possibly both
> ioctls can be given to the generic tty ioctl handling 

I would keep 

	if (type == FOO)

as far away from the generic tty ioctl code as possible. It's already
convoluted and complex with zillions of ioctl calls. Separating out lots
of the console and other ioctls properly cleaned it up no end and going
backwards would be a bad mistake.
