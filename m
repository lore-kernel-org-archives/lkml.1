Return-Path: <linux-kernel-owner+w=401wt.eu-S1761313AbZJMVDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313AbZJMVDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760815AbZJMVDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:03:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbZJMVDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:03:06 -0400
Date: Tue, 13 Oct 2009 14:02:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Boyan <btanastasov@yahoo.co.uk>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?= 
	<fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>, Nix <nix@esperi.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910131358140.26777@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
 <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk> <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain> <4AD4DE4C.4010402@yahoo.co.uk>
 <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Linus Torvalds wrote:
> 
> Anyway, I'm not entirely happy with this patch, and I haven't actually 
> TESTED it so it might well be totally broken [..]

It is.

Looking over the patch a bit more, at a minimum that

	if (test_and_set_bit(TTY_FLUSHING, &tty->flags)) {

line should be

	if (!test_and_set_bit(TTY_FLUSHING, &tty->flags)) {

(ie add the '!') since we want to do things if the bit wasn't set before 
(and if it was already set it all turns into a no-op).

But apart from that obvious typo, the patch still looks good even after 
looking it through a bit more. It's still TOTALLY UNTESTED, though!

		Linus
