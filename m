Return-Path: <linux-kernel-owner+w=401wt.eu-S1761272AbZJMXBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbZJMXBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760895AbZJMXBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:01:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44400 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760128AbZJMXBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:01:43 -0400
Date: Wed, 14 Oct 2009 00:01:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Fulghum <paulkf@microgate.com>, Boyan <btanastasov@yahoo.co.uk>,
       " =?ISO-8859-14?B?RnLpZOlyaWM=?= L. W. Meunier" <fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>, Nix <nix@esperi.org.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091014000145.3a611c94@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0910131514100.3404@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	<L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
	<C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>
	<87ljjgfcbu.fsf@spindle.srvr.nix>
	<alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>
	<alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
	<4AD3F769.5080405@gmail.com>
	<alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net>
	<4AD437F9.9020708@yahoo.co.uk>
	<alpine.LFD.2.01.0910130745550.3438@localhost.localdomain>
	<4AD4DE4C.4010402@yahoo.co.uk>
	<alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
	<4AD4F548.2030506@microgate.com>
	<alpine.LFD.2.01.0910131514100.3404@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And no, I'm not sure my patch helps. I'd have expected 
> 'tty_buffer_flush()' to be something very rare, for example. But I also 
> didn't really check if we may do it some other way.

It is rare for most applications

> But I _am_ sure that it makes the code a whole lot more straightforward. 
> Bits that say "we're busy flushing" suddenly actually act that way, and 
> pointers that say "this is the head of the buffers" also act that wy.

The more I look the more I think a mutex is the right answer. It also
provides us with a "stop feeding me" lock for ldisc changes and tty close
down bits.
