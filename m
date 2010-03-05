Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab0CENCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 08:02:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44291 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752066Ab0CENCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 08:02:37 -0500
Date: Fri, 5 Mar 2010 13:04:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Mike Hayward <hayward@loup.net>, foosaa@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-mm@kvack.org
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
 program
Message-ID: <20100305130426.1c9414d1@lxorguk.ukuu.org.uk>
In-Reply-To: <87f94c371003042201n72ce8578vc01331678b52da75@mail.gmail.com>
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>
	<20100303224245.ae8d1f7a.akpm@linux-foundation.org>
	<f875e2fe1003040458o3e13de97v3d839482939b687b@mail.gmail.com>
	<201003041631.o24GVl51005720@alien.loup.net>
	<f875e2fe1003041012m680ffc87i50099ed011526440@mail.gmail.com>
	<201003050042.o250gsUC007947@alien.loup.net>
	<87f94c371003042201n72ce8578vc01331678b52da75@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For clarity, most ATA class disk drives are spec'ed to have one
> non-recoverable error per 150TB or so of writes.  Disk drives do blind
> writes.  (ie. They are not verified).  So we should all expect to have
> the occasional silent data corruption on write.  The problem is
> compounded with bad cables, controllers, RAM, etc.

Cable errors should only be a PATA issue, SATA protects the command block
and the data.

> The only way for the linux kernel even attempt to fix that is for it
> to do a read verify on everything it writes.  For the vast majority of
> uses that is just not acceptable for performance reasons.

It's also the wrong layer

> OTOH, if data integrity is of the utmost for you, then you should
> maintain a md5hash or similar for your critical files and verify them
> any time you make a copy.  btrfs may offer a auto read-verify.  I
> don't know much about btrfs.

If you deal with utterly enormous amounts of data (as some clusters and
the like do) you protect your data from application to application layer.
It leaves ECC protected memory and it comes back to ECC protected memory
with a hash. That covers a lot of the errors by the OS, hardware, cables,
busses - even drive memory.

