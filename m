Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbZD0MfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbZD0MfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbZD0Mes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:34:48 -0400
Received: from web32602.mail.mud.yahoo.com ([68.142.207.229]:38245 "HELO
	web32602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754194AbZD0Mes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:34:48 -0400
Message-ID: <534721.54493.qm@web32602.mail.mud.yahoo.com>
X-YMail-OSG: 0CpSxegVM1kzaAnu69zoQEeYItBN1bRsGZiSszP2VCZxQsjT3VhsBHDhBH4.Fj6CwS_9VKzvPKH5Nm9nS_HddsGGKgyqGIB6YcRv6IiUY1ROoJLGQqtKo7UHBAC2KCuYN7Dg8LSStvBP2dsP9o2XXVtLZweDiCKJ9QnMCyBAl4omuR_JrydAfjRaLg0cgqEwsaKMeV8sqVnxG76ioFuRlUx.IsQSZtGRqv_RLZadGr09Mk9e.qVubp.og9QkMLHbCbqF0Y5.TCPPgxN8NncLt.kCI2WaV6yLRshOGjiAVOs6ub5uyQXKifHEckopQtvjPkRKxzOxjQ6bDSeSnrg_tplzzA--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <20090424175238.GA19646@csn.ul.ie>
Date: Mon, 27 Apr 2009 05:34:47 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [BUG] 2.6.30-rc3: bnx2 failing to load firmware
To: Mel Gorman <mel@csn.ul.ie>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20090424175238.GA19646@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Mel Gorman <mel@csn.ul.ie>
> To: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>; Michael Chan <mchan@broadcom.com>; David S. Miller <davem@davemloft.net>
> Sent: Friday, April 24, 2009 7:52:39 PM
> Subject: [BUG] 2.6.30-rc3: bnx2 failing to load firmware
> 
> On Tue, Apr 21, 2009 at 08:27:57PM -0700, Linus Torvalds wrote:
> > 
> > Another week, another -rc.
> > 
> 
> Getting this when loading the bnx2 driver
> 
> bnx2 0000:04:00.0: firmware: requesting bnx2/bnx2-mips-06-4.6.16.fw
> bnx2: Can't load firmware file "bnx2/bnx2-mips-06-4.6.16.fw"
> bnx2 0000:04:00.0: PCI INT A disabled
> bnx2: probe of 0000:04:00.0 failed with error -2
> bnx2 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> bnx2 0000:06:00.0: firmware: requesting bnx2/bnx2-mips-06-4.6.16.fw
> bnx2: Can't load firmware file "bnx2/bnx2-mips-06-4.6.16.fw"
> bnx2 0000:06:00.0: PCI INT A disabled
> bnx2: probe of 0000:06:00.0 failed with error -2
> 
> The firmware-related parts of the .config are
> 
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FIRMWARE_MEMMAP=y
> 
> Reverting commit 57579f7629a3d46c307405fbd2ea6bdb650d692f "fixes" it no
> doubt there is a better fix. The patch author (Michael) is cc'd but if
> nothing else happens, I'll investigate more after the weekend.
> 
> dmesg and .config attached.
> 

 just curious, what userspace are you using? I have, starting with 2.6.29, a similar problem with tg3. My RHEL4.3 userspace broke hotplugging, because as of 2.6.29 there are two "sysfs" lines in /"proc/mounts". I fixed it in "/etc/hotplug/firmware.agent" by just assuming "/sys" as the "sysfs" mountpoint.

 Maybe of course totally unrelated.

Cheers
Martin

