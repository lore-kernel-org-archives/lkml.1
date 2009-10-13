Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbZJMPDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbZJMPDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757970AbZJMPDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:03:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247AbZJMPDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:03:36 -0400
Date: Tue, 13 Oct 2009 08:02:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Nix <nix@esperi.org.uk>, Paul Fulghum <paulkf@microgate.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?= 
	<fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <alpine.LFD.2.01.0910130721530.3438@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910130755360.3438@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
 <20091013113232.384b2432@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0910130721530.3438@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Linus Torvalds wrote:
> 
>  - whoever is _reading_ the buffer, and due to memory ordering may see the 
>    update to the buffer length _before_ it actually sees the data itself. 
>    That spinlock does all the memory ordering too.

Hmm. This one looks like it's ok, because whenever we commit it, we do 
take the spinlock, so '->commit' is protected for the reader side.

>  - scrambling the data order with two writers is certainly less annoying 
>    than potentially screwing up ->used entirely, and having the memcpy's 
>    overflow the buffer. Both writers may have decided that there is enough 
>    room for each one - but that does not mean that there is enough room 
>    for _both_.

.. but this one is still true. Anybody who doesn't lock writers at a 
higher level could easily end up causing some really subtle memory 
corruption.

But maybe all users really are safe. 

		Linus
