Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbYLYJUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbYLYJUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 04:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYLYJUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 04:20:09 -0500
Received: from n16b.bullet.scd.yahoo.com ([209.73.160.83]:23504 "HELO
	n16b.bullet.scd.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751541AbYLYJUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 04:20:08 -0500
X-yahoo-newman-spamcop: yes
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 728586.31029.bm@omp409.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=sgBx4wIhIW44cOBBUAbg+Y/18rEvk2QJSK6idhN64z01J+oQsAks61QSV2QHucuYzdpXPyZWT9W1CBQxCSFKXizx3c9Kx9aCF/Pa+p6uapr3gwTuQKgKzib+D0aWgktOrkIfk6rAkbl9alFKrYzqQ3lXH8WYFrT9FxQM7X/QM8E=;
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 25 Dec 2008 01:19:02 -0800 (PST)
From: Luis Sousa <ls.luis_sousa@yahoo.com.br>
Subject: Re: sata io freeze, 2.6.18 and also 2.6.24 [the real culprit]
To: devzero@web.de
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <591505.79008.qm@web46008.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux developers,

I carried this thread on in April 2008 because my computer was crashing every other day. I tried and tried and thought I had reached a solution many a time, but eventually they all proved illusive. Eventually the box kept crashing every other day, applications often dumped core and the only SysRq combination to work was the B one.

But then my motherboard burned out. So I went and bought another one. And magically all my problems disappeared. Interestingly enough, the temperature seems to have gone down at least 15°C.

I'm not sure if this can still be a kernel issue, but it definitely seems not to me. I had installed FreeBSD on the system back then and it would crash also. Anyway, my faith in Linux has risen up once again. This system seems rock solid now, it's been a while.

I'd like to say thanks to all, and I'm glad to have such a great stable system once again. Thank you for developing this incredible system, it is definitely a superior system for me, and "superior" in this case is a self-sufficient term.

Best regards,
--
Luis Sousa

--- Em seg, 14/4/08, Luis Sousa <ls.luis_sousa@yahoo.com.br> escreveu:
De: Luis Sousa <ls.luis_sousa@yahoo.com.br>
Assunto: Re: sata io freeze, 2.6.18 and also 2.6.24 [the real culprit]
Para: devzero@web.de
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Data: Segunda-feira, 14 de Abril de 2008, 22:24

--- devzero@web.de escreveu:

> so - you told, you have your disk attached to this controller:
> 
> 00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID
Controller (rev
> 80)
> 	Subsystem: Micro-Star International Co., Ltd. Unknown device 0430
> 	Flags: bus master, medium devsel, latency 32, IRQ 16
> 	I/O ports at ec00 [size=8]
> 	I/O ports at e800 [size=4]
> 	I/O ports at e400 [size=8]
> 	I/O ports at e000 [size=4]
> 	I/O ports at dc00 [size=16]
> 	I/O ports at d800 [size=256]
> 	Capabilities: <access denied>
> 
> and use sata_via module - and your system works stable with nosmp, but
freezes very soon
> on heavy i/o with smp. disabling dma makes no difference.
> 
> correct ?

Correct. 

But I'm not sure it's an exclusive i/o thing. I've had the box
crash in
situations where I don't think heavy i/o is involved.. for instance, it
crashed two times just as I closed the iceape browser.
 
> then i assume this could be an smp issue, probably a bug in sata_via and
may need further
> investigation.
> 
> there seem no noticeable changes in that driver since 2.6.24 - but maybe
it`s worth
> trying 2.6.25-rc9 to see if it behaves different?

I'm actually running 2.6.25-rc7-git6 now.
(so I really don't think that would make much of a difference)

> absolutely nothing in dmesg on freeze ?

Absolutely nothing. Never.
 
> maybe you could try catching some message with attaching serial console?

Hmm, I have no serial consoles here, and my spare box is dead. 

Unless I can attach netconsole to a windows box.

I can probably crash it in console mode, without Xorg. Then I hope something
might show up in another vt at least.

> how reliably can you crash that box with lots of i/o ? just random crashes
or after a
> certain amount of data written/read ?

There is definitely a random element in it. But I can reliably crash it.
Just trigger some CPU and i/o bound processes. I've crashed it with
operations
which would only read from the disk, for instance unpacking to /dev/null.
Sometimes it takes longer, though.

> could you try if just reading from the raw blockdevice makes a differnce ?
(dd
> if=/dev/sda of=/dev/zero)

Yes, I can try that. But please bear with me as I won't be working full
time
in this. I hope we can get to the bottom of this, but it might not be as quick
as we'd like.

Thank you very much for the help.

I'll write back asap.

Best regards,
--
Luis Sousa

> > -----Ursprüngliche Nachricht-----
> > Von: "Luis Sousa" <ls.luis_sousa@yahoo.com.br>
> > Gesendet: 14.04.08 12:14:26
> > An: devzero@web.de
> > CC: linux-kernel@vger.kernel.org
> > Betreff: Re: sata io freeze, 2.6.18 and also 2.6.24 [the real
culprit]
> 
> 
> > 
> > Hello,
> > 
> > I did as planned, and I dare to say now, with
> > relative certainty, that the reason I have had all
> > these instabilities, including application crashes,
> > sneaky corrupt backups, and the dreaded freezes
> > every other day was SMP and HyperThreading not working
> > properly. Booting with nosmp gives me a stable system.
> > Booting only with the sata-related arguments had
> > the system freeze overnight.
> > 
> > Sincerely,
> > --
> > Luis Sousa
> > 
> > --- devzero@web.de escreveu:
> > 
> > > hi luis, 
> > > 
> > > glad that it worked - but let us better call this a possible
workaround, not a
> solution.
> > > 
> > > mind that you loose lots of performance with this, because all
i/o is handled by the
> cpu
> > > now.
> > > 
> > > > If everything goes well, I'll reduce the command line
> > > > in order to narrow the problem further down.
> > > 
> > > yes, please!
> > > 
> > > regards
> > > roland
> > > 
> > > 
> > > > -----Ursprüngliche Nachricht-----
> > > > Von: "Luis Sousa"
<ls.luis_sousa@yahoo.com.br>
> > > > Gesendet: 12.04.08 17:34:39
> > > > An: devzero@web.de
> > > > CC: linux-kernel@vger.kernel.org
> > > > Betreff: Re: sata io freeze, 2.6.18 and also 2.6.24
[POSSIBLE SOLUTION]
> > > 
> > > 
> > > > 
> > > > Hello all,
> > > > 
> > > > Thanks to valuable help from roland, I was able to
> > > > boot with the following options:
> > > > 
> > > > ``nosmp ide=nodma libata.dma=0''
> > > > 
> > > > after what I ran an agressive stability test for a
> > > > while, with no problem whatsoever. Maybe it's too
> > > > soon to say, but I have a good feeling this time. It
> > > > seems roland figured it out.
> > > > 
> > > > If everything goes well, I'll reduce the command line
> > > > in order to narrow the problem further down.
> > > > 
> > > > (and indeed, this is a hyper-threading single core CPU)
> > > > 
> > > > Sincerely,
> > > > --
> > > > Luis Sousa
> > > > 
> > > > --- devzero@web.de escreveu:
> > > > 
> > > > > did you try UP-kernel or tried booting with
"nosmp" and does that make any
> difference
> > > ?
> > > > > 
> > > > > >This is a 2-processor CPU:
> > > > > ># cat /proc/cpuinfo 
> > > > > >processor       : 0
> > > > > >vendor_id       : GenuineIntel
> > > > > >cpu family      : 15
> > > > > >model           : 4
> > > > > >model name      : Intel(R) Pentium(R) 4 CPU
3.00GHz
> > > > > 
> > > > > most likely this just "appears" as 2-way
processor , but i´m quite sure this is
> just
> > > a
> > > > > single-core CPU, but with HyperThreading enabled.
> > > > > 
> > > > > 
> > > > > regards
> > > > > roland
> > > > > 
> > > > > 
> > > > > 
> > > > > List:       linux-kernel
> > > > > Subject:    sata io freeze, 2.6.18 and also 2.6.24
> > > > > From:       Luis Sousa <ls.luis_sousa () yahoo !
com ! br>
> > > > > Date:       2008-03-28 22:24:48
> > > > > Message-ID: 739784.81690.qm () web46009 ! mail ! sp1 !
yahoo ! com
> > > > > [Download message RAW]
> > > > > 
> > > > > Hello,
> > > > > 
> > > > > I've been having consistent hard system freezes
for a
> > > > > long time, every 2 days or so, and finally decided to
> > > > > move to the most recent stable kernel. Unfortunatelly
> > > > > that didn't fix it. The freezes seem to be
io-related;
> > > > > they started since I moved my drive to sata. They seem
> > > > > to happen mostly when there's an io-intensive
operation,
> > > > > like extracting a big archive; a reboot is needed.
> > > > > 
> > > > > Nothing ever shows up in the logs.
> > > > > 
> > > > > I'm using the following drive:
> > > > > 
> > > > > ATA device, with non-removable media
> > > > >         Model Number:       MAXTOR STM3160215AS       
             
> > > > >         Serial Number:      6RA2TMJ4
> > > > >         Firmware Revision:  3.AAD   
> > > > > 
> > > > > Linux localhost 2.6.24.4 #4 SMP Fri Mar 28 14:51:50
BRT 2008 i686 GNU/Linux
> > > > > 
> > > > > This is a 2-processor CPU:
> > > > > 
> > > > > # cat /proc/cpuinfo 
> > > > > processor       : 0
> > > > > vendor_id       : GenuineIntel
> > > > > cpu family      : 15
> > > > > model           : 4
> > > > > model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
> > > > > stepping        : 9
> > > > > cpu MHz         : 3013.697
> > > > > cache size      : 1024 KB
> > > > > 
> > > > > (same goes for processor : 1)
> > > > > 
> > > > > Sincerely,
> > > > > --
> > > > > Luis Sousa


      Veja quais são os assuntos do momento no Yahoo! +Buscados
http://br.maisbuscados.yahoo.com

