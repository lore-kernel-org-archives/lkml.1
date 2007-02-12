Return-Path: <linux-kernel-owner+w=401wt.eu-S965016AbXBLRlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965016AbXBLRlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 12:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965029AbXBLRlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 12:41:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965016AbXBLRlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 12:41:13 -0500
To: "Martin A. Fink" <fink@mpe.mpg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
References: <200702121502.17130.fink@mpe.mpg.de>
	<p73abzji9xi.fsf@bingen.suse.de> <200702121727.17108.fink@mpe.mpg.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 Feb 2007 19:41:27 +0100
In-Reply-To: <200702121727.17108.fink@mpe.mpg.de>
Message-ID: <p731wkvi5go.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Martin A. Fink" <fink@mpe.mpg.de> writes:

Your mailer seems to be broken. It drops cc.
> 
> If you call fsync in BSD then you get what you expect. anything that is still 
> not on disk will be written. Afterwards fsync returns... So this should be 
> the same like with linux?!

Not necessarily.  The disk may buffer additionally. Handling that
differs widely, but modern Linux forces flushes to platter if the hardware support 
it.

> But the big question still is -- buffered or not -- where do the big 
> variations within linux come frome? I am not writing small blocks. I write 
> huge amounts of data.

1MB is nowhere near huge by modern standards. Many IO subsystems are
only happy with multi MB requests. 

> So the buffer will always be full.

Hardly. Especially not if you do synchronous fsync inbetween.

> If I use a normal SATA-II disk, there are no differences between BSD and Linux 
> when writing to the raw device... So it cant be a buffer-problem alone.

Yes that is something that needs to be investigated. That is why I suggested
oprofile if your assertation of a more CPU overhead on Linux is true.

> I still don't understand the buffer argument. If one writes 25 GB in blocks of 
> 1 MB your buffer should be always full...

Your mental model of a IO subsystem seems to be quite off.
Think what happens when you fsync and submit synchronously.

It's like sending something down a long pipe and waiting until it arrives
at the bottom and you hear the echo of the impact. Then only then you send again. 
There will be always long periods when the pipe will be empty.

If you use large enough blocks these gaps will be quite small and
might effectively become unimportant, but 1MB is nowhere near big enough 
for that.

> Is there a buffered io device that I can use, but that does not use a 
> filesystem?

/dev/sdX*. However it has some other issues that also don't make
it ideal. File systems are usually best.

-Andi
