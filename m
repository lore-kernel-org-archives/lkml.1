Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbYACMnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbYACMnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 07:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbYACMng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 07:43:36 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:39531 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYACMnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 07:43:35 -0500
Date: Thu, 03 Jan 2008 13:43:33 +0100
Message-Id: <83531397@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: jengelh@linux01.gwdg.de
Subject: Re: serial console _after_ boot ? - was: Redirect kernel console
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/7RWKQC9sLPxoM5pZ7fHvxyR+sFYz134seHG1Qz0xyDvE0Y
 kzZMU7i92jj18j+vXWB1DR8PVIaGFEeilKOljb6O992JoJrxqc=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi !

i was wondering how to make kernel messages appear on /dev/ttyS0 without a reboot, i.e. kernelparam "console=ttyS0"

after playing for a while with setconsole, setterm and klogconsole i didn`t find a way to make that happen.

i can do "setconsole /dev/tty1 </dev/console" and then "echo test >/dev/console" and see "test" on tty1

"setterm -msg on -msglevel 8 >/dev/console"  (or >/dev/tty1), modprobe loop;rmmod loop - and i see the kernel message there
   
i can do "setconsole /dev/ttyS0 </dev/console" and then "echo test >/dev/console" and see "test" on ttyS0

BUT :

"setterm -msg on -msglevel 8 >/dev/console"  (or >/dev/ttyS0), modprobe loop;rmmod loop  ......  nothing!

since i came across jan`s posting from 2005, which didn`t get a reply i think it`s not that stupid to ask again...

any clue how to do that at runtime or what`s the issue here ? (see excerpts below) 

i can set 
regards
roland



List:       linux-kernel
Subject:    Redirect kernel console
From:       Jan Engelhardt <jengelh () linux01 ! gwdg ! de>
Date:       2005-08-13 12:48:22
Message-ID: Pine.LNX.4.61.0508131447220.4457 () yvahk01 ! tjqt ! qr
[Download message RAW]

Hi,


there is a klogconsole utiltity that allows to change the console to which 
kernel messages are printed. However, is it possible to redirect to ttyS0 
without a reboot?


Jan Engelhardt
------- 





>> Subject: Re: serial console _after_ boot ?

>> > Setterm outputs the correct escape sequences to stdout. You can 
>> > configure another tty using 'setterm -msglevel 8 -msg on > /dev/ttyS0'. 
>> > I tested this on the standard kernel consoles (/dev/tty1-9), and it 
>> > worked. You obviously need root access to write the escape sequences to 
>> > the tty's.
>> 
>> oh - yes, this works! but with tty1-9 only.
>> not with ttyS0 :(
>
>.....as the docs tell.....
>
> Some options  however  (marked  "virtual  consoles  only" below)  do  not  correspond to a terminfo(5) capability.
>
>      -msg [on|off] (virtual consoles only)
>              Enables or disables the sending of kernel printk() messages to the console.
>
>       -msglevel 1-8 (virtual consoles only)
>              Sets the console logging level for kernel printk() messages.  All messages strictly more important than  this
>              will  be  printed, so a logging level of 0 has the same effect as -msg on and a logging level of 8 will print
>              all kernel messages.  klogd(8) may be a more convenient interface to the logging of kernel messages.


> > > but i don`t have change_console. 
> > > searched the net and found that this eventually should be part of sysvinit package.
> > > but mine doesn`t provide that tool.
> > > 
> > > found "setconsole" which looks like something similar, but "setconsole /dev/ttyS0 < /dev/console"
> > > doesn`t have any effect
> > 
> > What distribution do you use? I have change_console on gentoo, yet I 
> > cannot find the tool on a debian etch. But that's a vserver, so it's 
> > probably not a reference.
> 
> i have opensuse 10.3

_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

