Return-Path: <linux-kernel-owner+w=401wt.eu-S1762113AbYETLwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762113AbYETLwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbYETLv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:51:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38638 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbYETLv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:51:56 -0400
Date: Tue, 20 May 2008 08:49:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "koos vriezen" <koos.vriezen@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Krufky <mkrufky@infradead.org>
Subject: Re: mplayer v4l hangs in 2.6.25.2/4 (likely regression)
Message-ID: <20080520084911.17201a98@areia>
In-Reply-To: <20080517132050.2dae0ddd@infradead.org>
References: <d4e708d60805170954n6b2044c7h306bc6cb76bf798d@mail.gmail.com>
	<20080517111639.21a3e177@infradead.org>
	<d4e708d60805171211q1a1966a3i78dc3dc98d275dd1@mail.gmail.com>
	<20080517122640.2d15aeed@infradead.org>
	<20080517123452.79b82be2@infradead.org>
	<d4e708d60805171306n698192aas66b42a9468253448@mail.gmail.com>
	<20080517132050.2dae0ddd@infradead.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.1; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

Sorry for a late answer. I'm currently travelling on a short vacations.

On Sat, 17 May 2008 13:20:50 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Sat, 17 May 2008 22:06:12 +0200
> "koos vriezen" <koos.vriezen@gmail.com> wrote:
> 
> > 2008/5/17 Arjan van de Ven <arjan@infradead.org>:
> > 
> > > > so.. bttv first takes "fh->cap.vb_lock" in vidiocgmbuf, then
> > > > calls videobuf_mmap_setup(), and the first thing that does
> > is to also take fh->cap.vb_lock!  This isn't even an ABBA deadlock,
> > but a straight AA deadlock :)
> > 
> > Looks like I'm the only one actually running this code ;-)
> > 
> > > and here is an (untest) patch that should fix this problem:
> > > Koos, can you apply this to your kernel tree and report back if this
> > > fixes your deadlock?
> > 
> > patching file drivers/media/video/bt8xx/bttv-driver.c
> > patching file drivers/media/video/videobuf-core.c
> > Hunk #1 succeeded at 335 (offset 4 lines).
> > Hunk #2 succeeded at 1093 (offset -36 lines).
> > patching file include/media/videobuf-core.h
> > Hunk #1 succeeded at 227 (offset -10 lines).
> > 
> > Deadlock is gone, only mplayer fails to unmute the audio.

I have a trivial patch to fix this already. I'll add it soon to my tree and
send Linus.
> 
> that's something else entirely ;)
> 
> I'll call your deadlock bug fixed by the patch...
> 
> Mauro: will you send this on to Linus or should this go direct?

The fix looks sane. I prefer to just remove the lock call from bttv, instead of
calling  __videobuf_mmap_setup() and make this symbol global. The better is to
avoid locking inside the drivers, except during the interrupts, and inside
videbuf code. This is what we're doing on the other drivers.

So, it would be better if you could change your patch to remove the lock/unlock
at bttv-driver handling for this ioctl.

To solve the bug, both ways work, so:

Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>

Could you please send it to Linus and to -stable for me? Otherwise, I'll do
this by Monday.

Cheers,
Mauro
