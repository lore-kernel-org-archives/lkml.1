Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbZGKWYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbZGKWYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 18:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZGKWYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 18:24:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48390 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751413AbZGKWYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 18:24:22 -0400
Date: Sat, 11 Jul 2009 23:24:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Alan Cox <alan@linux.intel.com>, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: possible regression with pty.c commit
Message-ID: <20090711232452.4dc7c1ba@lxorguk.ukuu.org.uk>
In-Reply-To: <20090711191556.GA3845@localdomain.by>
References: <20090711191556.GA3845@localdomain.by>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009 22:15:56 +0300
Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:

> Hello,
> commit d945cb9cce20ac7143c2de8d88b187f62db99bdc ("pty: Rework the pty layer to use the normal buffering logic")
> seems to brake kdesu.

This looks like a timing bug in kdesu at first glance but it may be more
complex.

> close(11)                               = 0

We close one side of the pty/tty pair

> write(10, "stop", 4)                    = 4
> write(10, "\n", 1)                      = 1
> fcntl64(10, F_GETFL)                    = 0x2 (flags O_RDWR)
> read(10, 0xbf840858, 255)               = -1 EIO (Input/output error)		<<<<<<<<<

At this point the other side is closed, we have a hangup and the read
correctly I think gets -EIO.

I will have a look at kdesu on Monday, I've got Fedora setups here so
hopefully I can reproduce it simply.
