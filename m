Return-Path: <linux-kernel-owner+w=401wt.eu-S1763915AbZFQX3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763915AbZFQX3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764324AbZFQX2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:28:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086AbZFQX2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:28:16 -0400
Date: Thu, 18 Jun 2009 01:28:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
In-Reply-To: <20090617193442.GA31944@gallifrey>
Message-ID: <alpine.LNX.2.00.0906180126260.7457@wotan.suse.de>
References: <20090613230842.GA18347@gallifrey> <4A349B67.1070603@zytor.com> <20090614122734.GA1499@gallifrey> <alpine.LRH.2.00.0906161126330.31685@twin.jikos.cz> <20090617193442.GA31944@gallifrey>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, Dr. David Alan Gilbert wrote:

> > > > > [    3.147416] PNP: No PS/2 controller found. Probing ports directly.
> > > > > [    3.174456] serio: i8042 KBD port at 0x60,0x64 irq 1
> > > > > [    3.174961] serio: i8042 AUX port at 0x60,0x64 irq 12
> > > > > [    3.186312] mice: PS/2 mouse device common for all mice
> > > > It does, correctly, identify the keyboard and mode port, so it's
> > > > somewhat odd that it doesn't get used...
> > > Indeed. The only other observation in the older kernel that works
> > > it detects the AUX port first.
> > Booting with 'i8042.debug' will spit some more output into dmesg, which 
> > might help us to see if i8042 is really properly initialized, or something 
> > strange is going on during initialization.
> Please find below the new dmesg created by appending i8042.debug; this was
> taken from a slightly newer build of the same source kernel that I reported; this
> build just had a few more things configured out (parallel port) but exhibits
> the same symptom.
[ ... snip ... ]
> [    2.760232] drivers/input/serio/i8042.c: 20 -> i8042 (command) [3]
> [    2.760496] drivers/input/serio/i8042.c: 65 <- i8042 (return) [3]
> [    2.760586] drivers/input/serio/i8042.c: 60 -> i8042 (command) [3]
> [    2.760725] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [3]
> [    2.760821] drivers/input/serio/i8042.c: d3 -> i8042 (command) [3]
> [    2.760960] drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [3]
> [    2.763945] drivers/input/serio/i8042.c: fe <- i8042 (return) [3]
> [    2.772060] drivers/input/serio/i8042.c: a9 -> i8042 (command) [5]
> [    2.772360] drivers/input/serio/i8042.c: 00 <- i8042 (return) [5]
> [    2.772449] drivers/input/serio/i8042.c: a7 -> i8042 (command) [5]
> [    2.772588] drivers/input/serio/i8042.c: 20 -> i8042 (command) [5]
> [    2.772781] drivers/input/serio/i8042.c: 74 <- i8042 (return) [5]
> [    2.772870] drivers/input/serio/i8042.c: a8 -> i8042 (command) [5]
> [    2.773008] drivers/input/serio/i8042.c: 20 -> i8042 (command) [5]
> [    2.773252] drivers/input/serio/i8042.c: 54 <- i8042 (return) [5]
> [    2.773340] drivers/input/serio/i8042.c: 60 -> i8042 (command) [5]
> [    2.773478] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [5]
> [    2.773572] drivers/input/serio/i8042.c: d3 -> i8042 (command) [5]
> [    2.773712] drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [5]
> [    2.775932] drivers/input/serio/i8042.c: fe <- i8042 (return) [5]
> [    2.784650] drivers/input/serio/i8042.c: Interrupt 12, without any data [6]
> [    2.784760] drivers/input/serio/i8042.c: 60 -> i8042 (command) [6]
> [    2.784901] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [6]
> [    2.785140] drivers/input/serio/i8042.c: Interrupt 1, without any data [6]
> [    2.785247] drivers/input/serio/i8042.c: 60 -> i8042 (command) [6]
> [    2.785387] drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [6]
> [    2.785485] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    2.785964] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    2.795217] mice: PS/2 mouse device common for all mice
> [    2.798180] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [9]
> [    2.800486] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [10]
> [    2.801590] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [10]
> [    2.802961] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [10]
> [    2.803174] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [10]
> [    2.803363] input: PC Speaker as /devices/platform/pcspkr/input/input0
> [    2.805812] evbug.c: Connected device: input0 (PC Speaker at isa0061/input0)
> [    2.805957] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [11]
> [    2.806619] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [11]
> [    2.808965] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [12]
> [    2.809244] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [12]
> [    2.812079] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [13]
> [    2.812302] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [13]
> [    2.812676] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
> [    2.813249] rtc0: alarms up to one day, 114 bytes nvram
> [    2.814610] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [13]
> [    2.814817] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [13]
> [    2.817615] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [14]
> [    2.823470] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    2.827716] evbug.c: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
> [    2.828278] drivers/input/serio/i8042.c: d4 -> i8042 (command) [17]
> [    2.828427] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [17]

Is there any change if you boot with 'i8042.noaux' kernel command-line 
parameter?

-- 
Jiri Kosina
SUSE Labs
