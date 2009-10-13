Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbZJMLAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbZJMLAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZJMLAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:00:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33744 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755345AbZJMLAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:00:04 -0400
Date: Tue, 13 Oct 2009 12:00:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Nix <nix@esperi.org.uk>, "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>, Ed Tomlinson <edt@aei.ca>,
       "=?ISO-8859-14?B?RnLpZOlyaWM=?= L. W. Meunier" <fredlwm@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091013120046.5efb3365@lxorguk.ukuu.org.uk>
In-Reply-To: <20091012234641.GF8345@core.coreip.homeip.net>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	<L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
	<C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>
	<87ljjgfcbu.fsf@spindle.srvr.nix>
	<20091013003841.6c2988d0@lxorguk.ukuu.org.uk>
	<20091012234641.GF8345@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 16:46:41 -0700
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Tue, Oct 13, 2009 at 12:38:41AM +0100, Alan Cox wrote:
> > > So it seems likely to me that this is a kernel bug, somewhere, and the
> > > TTY layer seems like a good place to look (OK, a horrible place, but a
> > > *likely* place).
> > 
> > Somewhere around 2.6.29-30 various things went funny in the keyboard
> > layer for me - notably characters "bleeding" across console switches.
> > 
> 
> What do you mean by "bleeding"? Are you sure it is not autorepeat
> kicking in?

Fairly. Just now and then I'll do something like type

"blahblah<alt-f1>"

eg when flipping consoles to check something and the last letter or two
ends up on the screen after the flip (as if the alt-f1 vc switch passes
the data somewhere). I suspect its some kind of asynchronous handling
using the "current console" rather than the "current console at the time
the letter was typed" but it doesn't occur to order so isn't bisectable
and I've never managed to pin down where in the keyboard/vt/tty stack it's
occurring.
