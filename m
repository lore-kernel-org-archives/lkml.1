Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbXFYRBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbXFYRBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 13:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbXFYRAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 13:00:40 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:24011 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbXFYRAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 13:00:38 -0400
Date: Mon, 25 Jun 2007 19:00:35 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Takashi Iwai <tiwai@suse.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <s5hzm2ogqr7.wl%tiwai@suse.de>
Message-ID: <Pine.BSO.4.63.0706251840080.25800@rudy.mif.pg.gda.pl>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
 <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
 <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl>
 <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
 <s5hzm2ogqr7.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1581095560-1182790835=:25800"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1581095560-1182790835=:25800
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 25 Jun 2007, Takashi Iwai wrote:
[..]
>> ALSA still does not provides good soud devices virtualization for more
>> then one application. Each day I'm using bludy words when I'm try to use
>> skype which oppens /dev/mixer after run galeon with flash plugin which
>> opens /dev/snd/pcm* or when I start GNOME session with soud enabled
>> (handled by esd whuich uses ALSA).
>
> So, do you mean the soft-mixing is the biggest issue?  That's just a
> part of a design issue, and if we want to go to that way, the
> impelemtation would be trivial, regardless on ALSA or not.  Totally
> irrelevant argument regarding "remove ALSA".

I dont know is soft mixing is biggest issue but ..
Few minutes ago I'm upgrade to skype 1.4.x.

Lets try again above experiment:

$ strace -f -e trace=file galeon 2>&1 | grep dev/snd
[pid 28593] open("/dev/snd/controlC0", O_RDWR) = 46
[pid 28593] open("/dev/snd/pcmC0D0p", O_RDWR|O_NONBLOCK) = 47

OK .. now I'm enter on www.youtube.com and start playing random video.
Look on above: soud device was oppened in non bloking mode.

After few seconds I'm close tab with video in galeon.
Just after this I'm start skype and try call to test123 and calling isn't 
possible:

$ strace -f -e trace=file skype 2>&1 | grep dev/snd
[pid 30173] open("/dev/snd/controlC0", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC0", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC0", O_RDWR) = 43
[pid 30173] open("/dev/snd/controlC1", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC1", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC1", O_RDWR) = 43
[pid 30173] open("/dev/snd/controlC2", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC2", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC2", O_RDWR) = 43
[pid 30173] open("/dev/snd/controlC3", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC4", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC5", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC7", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC8", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC9", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC10", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC11", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC12", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC13", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC14", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC15", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC16", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC17", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC18", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC19", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC20", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC21", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC22", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC23", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC24", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC25", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC26", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC27", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC28", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC29", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC30", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC31", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC0", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC0", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC0", O_RDWR) = 43
[pid 30173] open("/dev/snd/controlC1", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC1", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC1", O_RDWR) = 43
[pid 30173] open("/dev/snd/controlC2", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC2", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC2", O_RDWR) = 43
[pid 30173] open("/dev/snd/controlC3", O_RDONLY <unfinished ...>
[pid 30173] open("/dev/snd/controlC4", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC5", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC6", O_RDONLY <unfinished ...>
[pid 30173] open("/dev/snd/controlC7", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC8", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC9", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC10", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC11", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC12", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC13", O_RDONLY <unfinished ...>
[pid 30173] open("/dev/snd/controlC14", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC15", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC16", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC17", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC18", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC19", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC20", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC21", O_RDONLY) =tory)
[pid 30173] open("/dev/snd/controlC23", O_RDo such file or directory)
[pid 30173] open("/dev/snd/controlC24", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/control O_RDONLY) = -1 ENOENT (No suchfile or directory)
[pid 30173] open("/dev/snd/controlC26", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC27", O_RDONLY) = -1 ENOENsuch file or directory)
[pid 30173] open("/ev/snd/controlC28", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC29", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/controlC30", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 30173] open("/dev/snd/pcmC0D0p", O_RDWR|O_NONBLOCK|O_ASYNC) = -1 EBUSY (Device or resource busy)
[pid 30173] open("/dev/snd/controlC0", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC0", O_RDWR) = 43
[pid 30173] open("/dev/snd/controlC0", O_RDWR) = 43
[pid 30173] open("/dev/snd/pcmC0D0c", O_RDWR|O_NONBLOCK|O_ASYNC) = 44
[pid 30173] open("/dev/snd/controlC0", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC0", O_RDWR) = 43
[pid 30173] open("/dev/snd/controlC0", O_RDWR) = 43
[pid 30173] open("/dev/snd/pcmC0D0c", O_RDWR|O_NONBLOCK|O_ASYNC) = 44
[pid 30173] open("/dev/snd/controlC0", O_RDONLY) = 43
[pid 30173] open("/dev/snd/controlC0", O_RDWR) = 43
[pid 30173] open("/dev/snd/controlC0", O_RDWR|O_NONBLOCK) = 43
[pid 30173] open("/dev/snd/controlC0", O_RDONLY) = 44
[pid 30173] open("/dev/snd/controlC0", O_RDWR) = 44
[pid 30173] open("/dev/snd/controlC0", O_RDWR) = 44
[pid 30173] open("/dev/snd/pcmC0D0p", O_RDWR|O_NONBLOCK|O_ASYNC) = -1 EBUSY (Device or resource busy)
[..]

/dev/snd/pcmC0D0p is busy ? YES because it was oppened by another 
application in non blocking mode which makes device .. unavalable to other :)
Welcome in wonderful ALSA word ..

And interesting .. why skype tries to open so meny devices (?)

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-1581095560-1182790835=:25800--
