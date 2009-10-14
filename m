Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbZJNBWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbZJNBWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 21:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZJNBWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 21:22:02 -0400
Received: from mail.lang.hm ([64.81.33.126]:37536 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbZJNBWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 21:22:01 -0400
Date: Tue, 13 Oct 2009 18:20:37 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?= 
	<fredlwm@gmail.com>,
       Boyan <btanastasov@yahoo.co.uk>,
       "Justin P. Mattock" <justinmattock@gmail.com>, Nix <nix@esperi.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <alpine.LFD.2.01.0910131806310.6146@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0910131819260.22169@asgard.lang.hm>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
 <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk> <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain> <4AD4DE4C.4010402@yahoo.co.uk> <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
 <alpine.LFD.2.01.0910131413240.3596@localhost.localdomain> <alpine.LNX.2.01.0910132153221.5212@dyndns.pervalidus.net> <alpine.LFD.2.01.0910131806310.6146@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Linus Torvalds wrote:

> On Tue, 13 Oct 2009, Fr?d?ric L. W. Meunier wrote:
>>
>> For now (more than 3h), it isn't doing any harm. And no keyboard lockups.
>
> I think it was Boyan who said he could trigger it "easily", and everybody
> else had a hard time to reproduce the problem, so I'll consider your "good
> for 3h" to not really be a confirmation either way. But at least it's not
> totally broken.
>
>> BTW, the old version of the patch was funny. It booted, but at the login
>> prompt I could only enter the first letter.
>
> Yeah, each time somebody read from a tty, the reading would also get rid
> of all the buffers, but would leave buf.tail set to the last one (that had
> been freed).
>
> Which then resulted in all subsequent IO going to that tail buffer, but
> nobody ever seeing it, because 'head' was NULL, and would stay that way as
> long as 'tail' existed (which it would until the tty was flushed, which it
> would never be).
>
> So you'd only ever see the first read (which could obviously be more than
> one character, but you'd have to type REALLY FAST to get there ;^)

Interesting, I had a hadful of times in the last several months where I 
ran into something like this, but switching virtual terminals cleared it 
up.

David Lang
