Return-Path: <linux-kernel-owner+w=401wt.eu-S1761434AbZJMXRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434AbZJMXRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760951AbZJMXRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:17:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759324AbZJMXRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:17:35 -0400
Date: Tue, 13 Oct 2009 16:16:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Boyan <btanastasov@yahoo.co.uk>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?= 
	<fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>, Nix <nix@esperi.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <20091014001131.302d3272@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0910131612410.3404@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
 <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk> <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain> <4AD4DE4C.4010402@yahoo.co.uk> <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
 <20091013223212.3260a7eb@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0910131548280.3404@localhost.localdomain> <20091014001131.302d3272@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Oct 2009, Alan Cox wrote:
> 
> The better existing lock is probably tty->ldisc_mutex which we take when
> doing ldisc changes (which are an even more dramatic change during
> receive_buf).

Yeah, that makes sense. And then we'd automatically also solve the 
"somebody tries to write during ldisc changes" issue. Not that I've 
checked how much it could help, but maybe we could get rid of _some_ of 
the special "tty_get_ldisc_wait()" kind of hacks.

And having that then protect flushing too would get rid of the 
TTY_FLUSHING and TTY_FLUSHPENDING logic. So it does smell like a good 
solution (without me looking at the code any closer right now, I can't 
take any more tty code reading just now ;)

		Linus
