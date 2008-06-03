Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYFCRbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYFCRbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbYFCRar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:30:47 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:34801 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758216AbYFCRao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:30:44 -0400
Date: Tue, 3 Jun 2008 19:30:13 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH 0/4] Fix forcedeth hibernate/wake-on-lan
	problems
Message-ID: <20080603173013.GA9490@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Alan Stern <stern@rowland.harvard.edu>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	David Brownell <david-b@pacbell.net>, linux-acpi@vger.kernel.org,
	linux-pm@lists.linux-foundation.org
References: <20080603061618.GB9301@yamamaya.is-a-geek.org> <Pine.LNX.4.44L0.0806031002510.2363-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0806031002510.2363-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> > > Also, you should run "lspci -vv" as root to see what wakeup signals the 
> > > USB controllers are issuing.
[...]
> > 00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2) (prog-if 20 [EHCI])
> > 	Subsystem: ASUSTeK Computer Inc. Unknown device 8239
> > 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0 (750ns min, 250ns max)
> > 	Interrupt: pin B routed to IRQ 20
> > 	Region 0: Memory at fe02e000 (32-bit, non-prefetchable) [size=256]
> > 	Capabilities: [44] Debug port: BAR=1 offset=0098
> > 	Capabilities: [80] Power Management version 2
> > 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > 		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
> > 	Kernel driver in use: ehci_hcd
> 
> The EHCI controller settings, however, are strange.  The relevant part 
> is the Power Management Status line near the end:
> 
> > 		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
> 
> This means the controller is in the D0 state (as expected) and 
> PME-Enable is currently turned off ("PME" stands for "Power Management 
> Event").  But the PME+ at the end means that as soon as PME does get 
> enabled -- like when the controller is suspended at the start of a 
> system sleep -- it _will_ send a PME signal.
> 
> So for some reason your EHCI controller thinks a wakeup event is 
> pending.  This means you should examine the contents of the "registers" 
> file in the debugfs directory for the EHCI controller, not OHCI.

melchior:/mnt/ehci/0000:00:02.1# cat registers
bus pci, device 0000:00:02.1 (driver 10 Dec 2004)
EHCI Host Controller
EHCI 1.00, hcd state 1
ownership 00000001
SMI sts/enable 0xc0080000
structural params 0x00101a8a
capability params 0x0000a086
status 0008 FLR
command 010009 (park)=0 ithresh=1 period=256 RUN
intrenable 37 IAA FATAL PCD ERR INT
uframe 3f3a
port 1 status 003400 POWER OWNER sig=k
port 2 status 001000 POWER sig=se0
port 3 status 003400 POWER OWNER sig=k
port 4 status 003400 POWER OWNER sig=k
port 5 status 001000 POWER sig=se0
port 6 status 001000 POWER sig=se0
port 7 status 001000 POWER sig=se0
port 8 status 001000 POWER sig=se0
port 9 status 001000 POWER sig=se0
port 10 status 001000 POWER sig=se0
irq normal 0 err 0 reclaim 0 (lost 0)
complete 0 unlink 0

HTH,

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
