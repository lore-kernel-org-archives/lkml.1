Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbZJMAQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbZJMAQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 20:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbZJMAP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 20:15:59 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:58902 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbZJMAP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 20:15:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vfwYzo8lS9WCB713JuF2DqeK8qO5CZnk7CdI2zoZaqS7hAcjFkBR+18K65pVDrJHee
         NiQ57aBTgj1g1BaVU7XQpLrfUIpl5zvu3QI0cItZHzPBIIN2UjHomeNRC8xVvdyYfLcX
         OPRKYTqmImWV+pgHc/NJj8WOYFcyTmFKJR1MA=
Message-ID: <4AD3C680.8060306@gmail.com>
Date: Mon, 12 Oct 2009 17:14:56 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Nix <nix@esperi.org.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>, Ed Tomlinson <edt@aei.ca>,
       =?ISO-8859-1?Q?=22Fr=E9d=E9ric_L=2E_W=2E_Meunier=22?= 
	<fredlwm@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <20091013003841.6c2988d0@lxorguk.ukuu.org.uk> <20091012234641.GF8345@core.coreip.homeip.net>
In-Reply-To: <20091012234641.GF8345@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Tue, Oct 13, 2009 at 12:38:41AM +0100, Alan Cox wrote:
>    
>>> So it seems likely to me that this is a kernel bug, somewhere, and the
>>> TTY layer seems like a good place to look (OK, a horrible place, but a
>>> *likely* place).
>>>        
>> Somewhere around 2.6.29-30 various things went funny in the keyboard
>> layer for me - notably characters "bleeding" across console switches.
>>
>>      
>
> What do you mean by "bleeding"? Are you sure it is not autorepeat
> kicking in?
>
>    
>>> I'm about to try reverting the suggested commit and will report back. I
>>> see this failure about once a day, so I'll give it three days to go
>>> wrong and then (if it doesn't) will presume it works and so inform you.
>>>
>>>
>>> (Of course with this commit reverted Emacsen start dropping data from
>>> their ptys, and as bad luck would have it I live in (X)Emacs, but that's
>>> on a different machine! so I can have my compile buffer data *and* not
>>> destroy X ;} )
>>>        
>> X doesn't touch the pty layer. It touches vt (extensively) and the input
>> layers. It's vt/kbd access is also very raw so bypasses much of that
>> layer. That isn't to say tty isn't the cause but look for input layer
>> changes too.
>>      
>
>    
FWIW:
Something I noticed with fedora/ubuntu(latest) is while opening
a terminal the history(example: pressing up arrow) will just
start firing off as if I pressed the arrow up key and held it,
all the way until the end of the history file( .bash_history).
seems to do this at a random, if I'm compiling most notable during 
./configure.
(When this happens the screen will be garbled with characters similar to 
this:
^C)

During my clfs build I used fedora as the host system, and this behavior 
went
right into the newly created system. When I built another system, I used 
ubuntu
and it seems to not be as bad, but still present.(I'm thinking , if this 
is what
others are experiencing it must be something in  userspace)

Justin P. Mattock
