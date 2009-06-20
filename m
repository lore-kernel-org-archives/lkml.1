Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZFTLER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZFTLER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 07:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZFTLEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 07:04:04 -0400
Received: from mx.treblig.org ([80.68.94.177]:49857 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbZFTLED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 07:04:03 -0400
Date: Sat, 20 Jun 2009 13:03:57 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
Message-ID: <20090620120357.GA11272@gallifrey>
References: <20090613230842.GA18347@gallifrey> <4A349B67.1070603@zytor.com> <20090614122734.GA1499@gallifrey> <alpine.LRH.2.00.0906161126330.31685@twin.jikos.cz> <20090617193442.GA31944@gallifrey> <alpine.LNX.2.00.0906180126260.7457@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0906180126260.7457@wotan.suse.de>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.29.2-bytemark-kvm-tickless-2009-05-05 (i686)
X-Uptime: 13:02:09 up 25 days,  5:23,  2 users,  load average: 0.05, 0.02, 0.00
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Kosina (jkosina@suse.cz) wrote:
> On Wed, 17 Jun 2009, Dr. David Alan Gilbert wrote:
> 
> > > > > > [    3.147416] PNP: No PS/2 controller found. Probing ports directly.
> > > > > > [    3.174456] serio: i8042 KBD port at 0x60,0x64 irq 1
> > > > > > [    3.174961] serio: i8042 AUX port at 0x60,0x64 irq 12
> > > > > > [    3.186312] mice: PS/2 mouse device common for all mice
> > > > > It does, correctly, identify the keyboard and mode port, so it's
> > > > > somewhat odd that it doesn't get used...
> > > > Indeed. The only other observation in the older kernel that works
> > > > it detects the AUX port first.
> > > Booting with 'i8042.debug' will spit some more output into dmesg, which 
> > > might help us to see if i8042 is really properly initialized, or something 
> > > strange is going on during initialization.
> > Please find below the new dmesg created by appending i8042.debug; this was
> > taken from a slightly newer build of the same source kernel that I reported; this
> > build just had a few more things configured out (parallel port) but exhibits
> > the same symptom.

<old dmesg removed>

> Is there any change if you boot with 'i8042.noaux' kernel command-line 
> parameter?

Yes, with i8042.noaux it works; dmesg snippet included below.

And in reply to hpa, it doesn't have a mouse port.

Dave


[    0.000000] Linux version 2.6.30-gort1 (dg@davros) (gcc version 4.4.0 (Ubuntu 4.4.0-5ubuntu1) ) #7 Sun Jun 14 17:36:35 BST 2009

<snip>

[    0.000000] Kernel command line: root=/dev/hda3 ro i8042.debug i8042.noaux

<snip>

[    3.077551] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    3.088908] PNP: No PS/2 controller found. Probing ports directly.
[    3.093940] drivers/input/serio/i8042.c: 20 -> i8042 (command) [3]
[    3.094208] drivers/input/serio/i8042.c: 65 <- i8042 (return) [3]
[    3.094302] drivers/input/serio/i8042.c: 60 -> i8042 (command) [3]
[    3.094448] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [3]
[    3.094747] drivers/input/serio/i8042.c: Interrupt 1, without any data [3]
[    3.094862] drivers/input/serio/i8042.c: 60 -> i8042 (command) [3]
[    3.095004] drivers/input/serio/i8042.c: 65 -> i8042 (parameter) [3]
[    3.095109] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.105959] mice: PS/2 mouse device common for all mice
[    3.109928] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [7]
[    3.112313] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [8]
[    3.113456] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [8]
[    3.114838] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [8]
[    3.115088] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [8]
[    3.116804] input: PC Speaker as /devices/platform/pcspkr/input/input0
[    3.117798] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [9]
[    3.118865] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [9]
[    3.120837] evbug.c: Connected device: input0 (PC Speaker at isa0061/input0)
[    3.121351] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [10]
[    3.121911] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [10]
[    3.124399] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [11]
[    3.125181] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [11]
[    3.127544] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [11]
[    3.127943] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [11]
[    3.129976] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    3.130647] rtc0: alarms up to one day, 114 bytes nvram
[    3.131110] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [12]
[    3.139526] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    3.145384] evbug.c: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)

<snip>

[   27.856504] drivers/input/serio/i8042.c: 3a <- i8042 (interrupt, 0, 1) [6193]
[   27.856868] evbug.c: Event. Dev: input1, Type: 4, Code: 4, Value: 58
[   27.857066] evbug.c: Event. Dev: input1, Type: 1, Code: 58, Value: 1
[   27.857202] evbug.c: Event. Dev: input1, Type: 0, Code: 0, Value: 0
[   27.857401] evbug.c: Event. Dev: input1, Type: 17, Code: 1, Value: 1
[   27.857510] evbug.c: Event. Dev: input1, Type: 0, Code: 0, Value: 0
[   27.907539] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [6206]
[   27.909983] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [6206]
[   27.910415] drivers/input/serio/i8042.c: 04 -> i8042 (kbd-data) [6206]
[   27.912829] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [6207]
[   27.942394] drivers/input/serio/i8042.c: ba <- i8042 (interrupt, 0, 1) [6214]
[   27.942804] evbug.c: Event. Dev: input1, Type: 4, Code: 4, Value: 58
[   27.943006] evbug.c: Event. Dev: input1, Type: 1, Code: 58, Value: 0
[   27.943122] evbug.c: Event. Dev: input1, Type: 0, Code: 0, Value: 0
[   28.053823] drivers/input/serio/i8042.c: 3a <- i8042 (interrupt, 0, 1) [6242]
[   28.054182] evbug.c: Event. Dev: input1, Type: 4, Code: 4, Value: 58
[   28.054383] evbug.c: Event. Dev: input1, Type: 1, Code: 58, Value: 1
[   28.054520] evbug.c: Event. Dev: input1, Type: 0, Code: 0, Value: 0
[   28.054708] evbug.c: Event. Dev: input1, Type: 17, Code: 1, Value: 0
[   28.054815] evbug.c: Event. Dev: input1, Type: 0, Code: 0, Value: 0
[   28.055613] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [6243]
[   28.058048] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [6243]
[   28.058327] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [6243]
[   28.060724] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [6244]
[   28.117266] drivers/input/serio/i8042.c: ba <- i8042 (interrupt, 0, 1) [6258]
[   28.117627] evbug.c: Event. Dev: input1, Type: 4, Code: 4, Value: 58
[   28.117823] evbug.c: Event. Dev: input1, Type: 1, Code: 58, Value: 0
[   28.117934] evbug.c: Event. Dev: input1, Type: 0, Code: 0, Value: 0
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
