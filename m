Return-Path: <linux-kernel-owner+w=401wt.eu-S965039AbXBLR4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965039AbXBLR4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 12:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965038AbXBLR4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 12:56:36 -0500
Received: from mpemail.mpe.mpg.de ([130.183.137.110]:38158 "EHLO
	mpemail.mpe.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039AbXBLR4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 12:56:35 -0500
From: "Martin A. Fink" <fink@mpe.mpg.de>
Organization: MPE
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Date: Mon, 12 Feb 2007 18:56:29 +0100
User-Agent: KMail/1.8
References: <200702121502.17130.fink@mpe.mpg.de> <200702121727.17108.fink@mpe.mpg.de> <p731wkvi5go.fsf@bingen.suse.de>
In-Reply-To: <p731wkvi5go.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702121856.29729.fink@mpe.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. Februar 2007 19:41 schrieben Sie:
> "Martin A. Fink" <fink@mpe.mpg.de> writes:
> 
> Your mailer seems to be broken. It drops cc.
> > 
> > If you call fsync in BSD then you get what you expect. anything that is 
still 
> > not on disk will be written. Afterwards fsync returns... So this should be 
> > the same like with linux?!
> 
> Not necessarily.  The disk may buffer additionally. Handling that
> differs widely, but modern Linux forces flushes to platter if the hardware 
support 
> it.
> 
> > But the big question still is -- buffered or not -- where do the big 
> > variations within linux come frome? I am not writing small blocks. I write 
> > huge amounts of data.
> 
> 1MB is nowhere near huge by modern standards. Many IO subsystems are
> only happy with multi MB requests. 
> 
> > So the buffer will always be full.
> 
> Hardly. Especially not if you do synchronous fsync inbetween.

Well no. I write 1 GB in blocks of 1 MB. After that I call fsync. Then I 
process the next Gigabyte...
> 
> > If I use a normal SATA-II disk, there are no differences between BSD and 
Linux 
> > when writing to the raw device... So it cant be a buffer-problem alone.
> 
> Yes that is something that needs to be investigated. That is why I suggested
> oprofile if your assertation of a more CPU overhead on Linux is true.
> 
> > I still don't understand the buffer argument. If one writes 25 GB in 
blocks of 
> > 1 MB your buffer should be always full...
> 
> Your mental model of a IO subsystem seems to be quite off.
> Think what happens when you fsync and submit synchronously.

See above, how I do writing.
> 
> It's like sending something down a long pipe and waiting until it arrives
> at the bottom and you hear the echo of the impact. Then only then you send 
again. 
> There will be always long periods when the pipe will be empty.
> 
> If you use large enough blocks these gaps will be quite small and
> might effectively become unimportant, but 1MB is nowhere near big enough 
> for that.

I tested this: When I write in blocks of 8kB or less the effect you describe 
happens. But above 100kB blocksize there is no more increase of speed.

> 
> > Is there a buffered io device that I can use, but that does not use a 
> > filesystem?
> 
> /dev/sdX*. However it has some other issues that also don't make
> it ideal. File systems are usually best.

My experience with filesystems is: I write some data and the write-function 
returns nearly immediatelly. So I write again. Sometimes it returns only 
after some 100-300ms. I think this happens always then when the buffer is 
full and thus linux starts to write to disk. After this happend, it returns 
again nearly immediatelly and after another while the same trouble happen 
again. But not in a regular order...

I have to store big amounts of data coming from 2 digital cameras to disk. 
Thus I have to write blocks of around 1 MB at 30 to 50 frames per second for 
a long period of time. So it is important for me that the harddisk drive is 
reliable in the sense of "if it is capable of 50 MB/s then it should operate 
at this speed. Constantly."

> 
> -Andi
> 
