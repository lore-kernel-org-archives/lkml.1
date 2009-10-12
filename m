Return-Path: <linux-kernel-owner+w=401wt.eu-S933144AbZJLXji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144AbZJLXji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758670AbZJLXjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:39:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38923 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758646AbZJLXjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:39:23 -0400
Date: Tue, 13 Oct 2009 00:38:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nix <nix@esperi.org.uk>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       "=?ISO-8859-14?B?RnLpZOlyaWM=?= L. W. Meunier" <fredlwm@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091013003841.6c2988d0@lxorguk.ukuu.org.uk>
In-Reply-To: <87ljjgfcbu.fsf@spindle.srvr.nix>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	<L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
	<C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>
	<87ljjgfcbu.fsf@spindle.srvr.nix>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So it seems likely to me that this is a kernel bug, somewhere, and the
> TTY layer seems like a good place to look (OK, a horrible place, but a
> *likely* place).

Somewhere around 2.6.29-30 various things went funny in the keyboard
layer for me - notably characters "bleeding" across console switches.

> 
> I'm about to try reverting the suggested commit and will report back. I
> see this failure about once a day, so I'll give it three days to go
> wrong and then (if it doesn't) will presume it works and so inform you.
> 
> 
> (Of course with this commit reverted Emacsen start dropping data from
> their ptys, and as bad luck would have it I live in (X)Emacs, but that's
> on a different machine! so I can have my compile buffer data *and* not
> destroy X ;} )

X doesn't touch the pty layer. It touches vt (extensively) and the input
layers. It's vt/kbd access is also very raw so bypasses much of that
layer. That isn't to say tty isn't the cause but look for input layer
changes too.
