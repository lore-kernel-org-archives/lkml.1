Return-Path: <linux-kernel-owner+w=401wt.eu-S934265AbZJMUJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265AbZJMUJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934257AbZJMUJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:09:07 -0400
Received: from smtp103.mail.ukl.yahoo.com ([77.238.184.35]:41156 "HELO
	smtp103.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934244AbZJMUJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:09:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Y0gBn9VQwSaFeSvi/dozBwRi1y5n75a1LYCz5QR1rboZP8TxoGYuD142VCwoW2Nu3iZfk0/fl/+y4fwNxkMtn2QirztXVYhnumwLRpXGak9PaQKrLbIJsJ5N8IwRMNwXKcLxaaLuP7twmaIZdcs0B992jYhzik6DhxSLVb1PZxw=  ;
X-Yahoo-SMTP: dGJefyiswBAq8gjvkVdDD_Aeiz1oX_mV
X-YMail-OSG: Y67Jru4VM1n0oPZcH7vx1XcfkZ_VJMfx7bt0wM.jZXWGgpNxLb7eUOh0.9xVhWb93Yh9DAEsOOagY4xf.eqJXLOEJrAkEY7ehw.SIVtVDXnVIGBq1Iy48q6PdKt201jI79wHCg6cgh4T9Rv8t27VEBbn04JG_YfHSbWNnwTEiNABHout6lPt5iLJvULmHqdvgRj25nS_6Nn2H38Qvi_vDi2SPLlNxsgvfnfJ.Dce.y_Vgm8ktmQopCoo0VWcffTp
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AD4DE4C.4010402@yahoo.co.uk>
Date: Tue, 13 Oct 2009 23:08:44 +0300
From: Boyan <btanastasov@yahoo.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: =?ISO-8859-1?Q?=22Fr=E9d=E9ric_L=2E_W=2E_Meunier=22?= 
	<fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>, Nix <nix@esperi.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain> <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk> <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
 > The whole "CPU intensive" thing makes me wonder..

When it breaks the first time and I switch to text console and go back
in X then it is really easy to trigger. Just "make modules_install" is
enough to stop the keyboard. At such cases starting to compile kernel
will keep the keyboard non functional until it is finished.
I don't know the internals of X, but for me it seems something in X is
broken, such as if the system is busy and it takes too much time to
"realize" that some key is pressed, it decides to just "switch off" the
keyboard as it is broken, then when switch to text console and go back
in X it "switches on" the keyboard again.

 >
> Do you have 'CONFIG_PREEMPT' enabled? Normally, "CPU intensive" does not 
> at all increase the likelihood of any kernel races, but with kernel 
> preemption we may well hit some preemption point and switch away, and make 
> some race window much bigger.

Yes, CONFIG_PREEMPT=y

> 
> So if you do have CONFIG_PREEMPT on, try to turn it off and see if it 
> makes the problem go away. Also, are people seeing this always running SMP 
> kernels, or are there UP kernels out there too (on UP _without_ preemption 
> it is almost impossible to hit 99% of all race conditions, so if anybody 
> is running an UP kernel with no preemption, then I'd be very surprised if 
> it is a kernel issue).

My system is UP, Athlon XP, 1.83GHz, video ATI 9550. Now I've tested
with:
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set

and I couldn't trigger the problem.

> 
> But I also still wonder if it might be user-space races, and just the 
> timing differences in the kernel. I don't know the input layer in X well 
> enough, I'm wondering if things like composition engine/window manager 
> could screw up here. Is there some pattern to the X versions (and/or 
> window managers and composition engines)?

For my case it doesn't matter X version - 1.6.1 was the previous Fedora
11 X, and it worked couple of months for me without such problems.
At the middle of September they've updated it to 1.6.4 - only X, not
the driver I'm using (ati) and it started to behave really slow on my
system - I see it as slower redraw of windows, rather irritating,
and I thought the keyboard problem is related to this, but then tested
it with the older version and it was the same.
Finally last weekend found time to bisect this and the result was
the mentioned commit: e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
(pty: avoid forcing 'low_latency' tty flag).

Composite is enabled in my X config, but I don't have compiz or
something like that enabled. DRI is enabled.
