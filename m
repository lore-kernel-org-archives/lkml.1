Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbXIDK0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbXIDK0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 06:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbXIDK0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 06:26:05 -0400
Received: from ipx20189.ipxserver.de ([80.190.249.56]:2113 "EHLO
	ipx20189.ipxserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbXIDK0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 06:26:00 -0400
Date: Tue, 4 Sep 2007 12:25:57 +0200
From: Christian Leber <christian@leber.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux, 2.6.23-rc5, powersaving degradation, (time spend in C0 goes up after a while)
Message-ID: <20070904102557.GA10866@core>
References: <20070902174038.GA10877@core> <20070902114017.15800e42@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20070902114017.15800e42@laptopd505.fenrus.org>
X-Accept-Language: de en
X-Location: Europe, Germany, Mannheim
X-Operating-System: Debian GNU/Linux (sid)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 02, 2007 at 11:40:17AM -0700, Arjan van de Ven wrote:

Hello,

> can you give us an lspci -vvxx of the system when it's in this "bad"
> state? We have a very vague suspicion on something like this, the lspci
> would help us a lot (this is a really rare thing that we can't really
> reproduce, but it has been reported a few times before)

sure, took some time, I waited yesterday 4h next to the laptop and it
didn't happen ;-)
(i usually run some virtualization and then wakeups are screwed anyway)

This time i also did not forget the powertop output.

The lspcivvxx_good was done with the same linux running, after a resume
from ram, then the wakeup behavior was also ok again.
The difference is:

Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
that is in the good case, and in the bad it is MAbort+


Christian Leber
 
-- 
http://rettetdieti.vde-uni-mannheim.de/


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=powertop_bad

PowerTOP 1.8    (C) 2007 Intel Corporation 

Collecting data for 15 seconds 
Cn	          Avg residency
C0 (cpu running)        (53.8%)
C1		  0.0ms ( 0.0%)
C2		  0.0ms ( 0.2%)
C3		  0.1ms (46.0%)
P-states (frequencies)
  2.01 Ghz     0.8%
  2.00 Ghz     0.0%
  1.60 Ghz     0.0%
   800 Mhz    99.2%
Wakeups-from-idle per second : 6287.5	interval: 15.0s
no ACPI power usage estimate available
Top causes for wakeups:
  35.5% ( 16.1)       firefox-bin : futex_wait (hrtimer_wakeup) 
  27.4% ( 12.5)       <interrupt> : extra timer interrupt 
   8.9% (  4.1)   <kernel module> : usb_hcd_poll_rh_status (rh_timer_func) 
   3.5% (  1.6)              Xorg : do_setitimer (it_real_fn) 
   3.2% (  1.5)              kpdf : schedule_timeout (process_timeout) 
   2.5% (  1.1)              Xorg : schedule_timeout (process_timeout) 
   2.2% (  1.0)            dhcdbd : schedule_timeout (process_timeout) 
   2.2% (  1.0)    NetworkManager : tg3_open (tg3_timer) 
   2.2% (  1.0)           klipper : schedule_timeout (process_timeout) 
   2.2% (  1.0)          kwrapper : do_nanosleep (hrtimer_wakeup) 
   2.2% (  1.0)        ksysguardd : schedule_timeout (process_timeout) 
   1.5% (  0.7)       <interrupt> : eth0 
   0.9% (  0.4)    NetworkManager : schedule_timeout (process_timeout) 
   0.9% (  0.4)     <kernel core> : neigh_table_init_no_netlink (neigh_periodic_timer) 
   0.7% (  0.3)              kded : schedule_timeout (process_timeout) 
   0.4% (  0.2)    adept_notifier : schedule_timeout (process_timeout) 
   0.4% (  0.2)   guidance-power- : schedule_timeout (process_timeout) 
   0.4% (  0.2)     <kernel core> : page_writeback_init (wb_timer_fn) 
   0.4% (  0.2)            kicker : schedule_timeout (process_timeout) 
   0.4% (  0.2)     <kernel core> : __netdev_watchdog_up (dev_watchdog) 
   0.4% (  0.2)   <kernel module> : neigh_table_init_no_netlink (neigh_periodic_timer) 
   0.1% (  0.1)       <interrupt> : PS/2 keyboard/mouse/touchpad 
   0.1% (  0.1)           konsole : schedule_timeout (process_timeout) 
   0.1% (  0.1)               ssh : __neigh_event_send (neigh_timer_handler) 
   0.1% (  0.1)     <kernel core> : dst_run_gc (dst_run_gc) 
   0.1% (  0.1)         ssh-agent : schedule_timeout (process_timeout) 
   0.1% (  0.1)         ssh-agent : do_setitimer (it_real_fn) 
   0.1% (  0.1)         klauncher : schedule_timeout (process_timeout) 
   0.1% (  0.1)     <kernel core> : inet_initpeers (peer_check_expire) 
   0.1% (  0.1)     <kernel core> : addrconf_verify (addrconf_verify) 

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=powertop_good

PowerTOP 1.8    (C) 2007 Intel Corporation 

Collecting data for 15 seconds 
Cn	          Avg residency
C0 (cpu running)        ( 1.0%)
C1		  0.0ms ( 0.0%)
C2		  5.2ms ( 5.6%)
C3		 24.0ms (93.4%)
P-states (frequencies)
  2.01 Ghz     0.0%
  2.00 Ghz     0.0%
  1.60 Ghz     0.0%
   800 Mhz   100.0%
Wakeups-from-idle per second : 49.8	interval: 15.0s
no ACPI power usage estimate available
Top causes for wakeups:
  34.1% (  9.5)       <interrupt> : libata 
   7.2% (  2.0)       <interrupt> : extra timer interrupt 
   5.7% (  1.6)              Xorg : do_setitimer (it_real_fn) 
   5.5% (  1.5)            kicker : schedule_timeout (process_timeout) 
   4.3% (  1.2)              Xorg : schedule_timeout (process_timeout) 
   3.8% (  1.1)              kpdf : schedule_timeout (process_timeout) 
   3.8% (  1.1)              kwin : schedule_timeout (process_timeout) 
   3.8% (  1.1)          kdesktop : schedule_timeout (process_timeout) 
   3.6% (  1.0)            dhcdbd : schedule_timeout (process_timeout) 
   3.6% (  1.0)          ifconfig : tg3_open (tg3_timer) 
   3.6% (  1.0)          kwrapper : do_nanosleep (hrtimer_wakeup) 
   3.6% (  1.0)           klipper : schedule_timeout (process_timeout) 
   3.1% (  0.9)        ksysguardd : schedule_timeout (process_timeout) 
   1.9% (  0.5)   hald-addon-stor : schedule_timeout (process_timeout) 
   1.4% (  0.4)     <kernel core> : neigh_table_init_no_netlink (neigh_periodic_timer) 
   1.4% (  0.4)    NetworkManager : schedule_timeout (process_timeout) 
   1.0% (  0.3)       <interrupt> : ahci 
   1.0% (  0.3)   <kernel module> : neigh_table_init_no_netlink (neigh_periodic_timer) 
   1.0% (  0.3)              kded : schedule_timeout (process_timeout) 
   0.7% (  0.2)     <kernel core> : page_writeback_init (wb_timer_fn) 
   0.7% (  0.2)   guidance-power- : schedule_timeout (process_timeout) 
   0.7% (  0.2)     <kernel core> : __netdev_watchdog_up (dev_watchdog) 
   0.7% (  0.2)    adept_notifier : schedule_timeout (process_timeout) 
   0.5% (  0.1)                sh : start_this_handle (commit_timeout) 
   0.5% (  0.1)         klauncher : schedule_timeout (process_timeout) 
   0.5% (  0.1)         ssh-agent : schedule_timeout (process_timeout) 
   0.5% (  0.1)         ssh-agent : do_setitimer (it_real_fn) 
   0.5% (  0.1)       firefox-bin : futex_wait (hrtimer_wakeup) 
   0.2% (  0.1)       <interrupt> : PS/2 keyboard/mouse/touchpad 
   0.2% (  0.1)       <interrupt> : eth0 
   0.2% (  0.1)           konsole : schedule_timeout (process_timeout) 
   0.2% (  0.1)          gconfd-2 : schedule_timeout (process_timeout) 
   0.2% (  0.1)           syslogd : do_setitimer (it_real_fn) 
   0.2% (  0.1)              hald : schedule_timeout (process_timeout) 

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspcivvxx_bad

00:00.0 Host bridge: Intel Corporation Mobile Memory Controller Hub (rev 0c)
	Subsystem: Dell Unknown device 01fe
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Capabilities: <access denied>
00: 86 80 00 2a 06 00 90 20 0c 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00

00:02.0 VGA compatible controller: Intel Corporation Mobile Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fea00000 (64-bit, non-prefetchable) [size=1M]
	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at eff8 [size=8]
	Capabilities: <access denied>
00: 86 80 02 2a 07 00 90 00 0c 00 00 03 00 00 80 00
10: 04 00 a0 fe 00 00 00 00 0c 00 00 e0 00 00 00 00
20: f9 ef 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 90 00 00 00 00 00 00 00 0b 01 00 00

00:02.1 Display controller: Intel Corporation Mobile Integrated Graphics Controller (rev 0c)
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: Memory at feb00000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: <access denied>
00: 86 80 03 2a 07 00 90 00 0c 00 80 03 00 00 80 00
10: 04 00 b0 fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 d0 00 00 00 00 00 00 00 00 00 00 00

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 4: I/O ports at 6f20 [size=32]
00: 86 80 34 28 05 00 80 02 02 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 21 6f 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 00 00

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #5 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 20
	Region 4: I/O ports at 6f00 [size=32]
00: 86 80 35 28 05 00 80 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 6f 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 09 02 00 00

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #2 (rev 02) (prog-if 20 [EHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 21
	Region 0: Memory at fed1c400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
00: 86 80 3a 28 06 01 90 02 02 20 03 0c 00 00 00 00
10: 00 c4 d1 fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 50 00 00 00 00 00 00 00 05 03 00 00

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
	Subsystem: Dell Unknown device 01fe
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at fe9fc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
00: 86 80 4b 28 06 01 10 00 02 00 03 04 10 00 00 00
10: 04 c0 9f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 50 00 00 00 00 00 00 00 09 01 00 00

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 3f 28 07 05 10 00 02 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 0b 0b 00 f0 00 00 20
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 02 00

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
	Memory behind bridge: fe800000-fe8fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 41 28 07 05 10 00 02 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 0c 0c 00 f0 00 00 20
20: 80 fe 80 fe f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 02 02 00

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0d, subordinate=0e, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fe600000-fe7fffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f01fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 45 28 07 04 10 00 02 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 0d 0e 00 d0 d0 00 00
20: 60 fe 70 fe 01 f0 11 f0 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 04 02 00

00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
	Memory behind bridge: fe500000-fe5fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 49 28 07 04 10 00 02 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 09 09 00 f0 00 00 20
20: 50 fe 50 fe f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 02 02 00

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 4: I/O ports at 6f80 [size=32]
00: 86 80 30 28 05 00 80 02 02 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 6f 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 00 00

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 20
	Region 4: I/O ports at 6f60 [size=32]
00: 86 80 31 28 05 00 80 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 61 6f 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 09 02 00 00

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 21
	Region 4: I/O ports at 6f40 [size=32]
00: 86 80 32 28 05 00 80 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 41 6f 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 03 00 00

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #1 (rev 02) (prog-if 20 [EHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at fed1c000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
00: 86 80 36 28 06 01 90 02 02 20 03 0c 00 00 00 00
10: 00 c0 d1 fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=07, sec-latency=32
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: fe400000-fe4fffff
	Prefetchable memory behind bridge: 00000000f4000000-00000000f7ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 48 24 07 00 10 00 f2 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 03 07 20 20 20 80 a2
20: 40 fe 40 fe 01 f4 f1 f7 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 02 00

00:1f.0 ISA bridge: Intel Corporation Mobile LPC Interface Controller (rev 02)
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: <access denied>
00: 86 80 15 28 07 01 10 02 02 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00

00:1f.1 IDE interface: Intel Corporation Mobile IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 6fa0 [size=16]
00: 86 80 50 28 05 00 80 02 02 8a 01 01 00 00 00 00
10: f1 01 00 00 f5 03 00 00 71 01 00 00 75 03 00 00
20: a1 6f 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00

00:1f.2 SATA controller: Intel Corporation Mobile SATA AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 219
	Region 0: I/O ports at 6eb0 [size=8]
	Region 1: I/O ports at 6eb8 [size=4]
	Region 2: I/O ports at 6ec0 [size=8]
	Region 3: I/O ports at 6ec8 [size=4]
	Region 4: I/O ports at 6ee0 [size=32]
	Region 5: Memory at fe9fb800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
00: 86 80 29 28 07 04 b0 02 02 01 06 01 00 00 00 00
10: b1 6e 00 00 b9 6e 00 00 c1 6e 00 00 c9 6e 00 00
20: e1 6e 00 00 00 b8 9f fe 00 00 00 00 28 10 fe 01
30: 00 00 00 00 80 00 00 00 00 00 00 00 0a 02 00 00

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 10
	Region 0: Memory at fe9fb700 (32-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 10c0 [size=32]
00: 86 80 3e 28 03 01 80 02 02 00 05 0c 00 00 00 00
10: 00 b7 9f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: c1 10 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 02 00 00

03:01.0 CardBus bridge: O2 Micro, Inc. Cardbus bridge (rev 21)
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 168
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fe400000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=03, secondary=04, subordinate=07, sec-latency=176
	Memory window 0: f4000000-f7fff000 (prefetchable)
	Memory window 1: f8000000-fbfff000
	I/O window 0: 00002000-000020ff
	I/O window 1: 00002400-000024ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
00: 17 12 35 71 87 00 10 04 21 00 07 06 00 a8 82 00
10: 00 00 40 fe a0 00 00 02 03 04 07 b0 00 00 00 f4
20: 00 f0 ff f7 00 00 00 f8 00 f0 ff fb 01 20 00 00
30: fd 20 00 00 01 24 00 00 fd 24 00 00 ff 01 c0 05
40: 28 10 fe 01 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

03:01.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02) (prog-if 10 [OHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fe4ff000 (32-bit, non-prefetchable) [size=4K]
	Region 1: Memory at fe4fe800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
00: 17 12 f7 00 17 01 18 02 02 10 00 0c 10 40 00 00
10: 00 f0 4f fe 00 e8 4f fe 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 60 00 00 00 00 00 00 00 03 01 00 00

09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5755M Gigabit Ethernet PCI Express (rev 02)
	Subsystem: Dell Unknown device 01fe
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 218
	Region 0: Memory at fe5f0000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: <access denied>
00: e4 14 73 16 06 05 10 00 02 00 00 02 10 00 00 00
10: 04 00 5f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 82 14 48 00 00 00 00 00 00 00 0a 01 00 00

0c:00.0 Network controller: Intel Corporation Unknown device 4229 (rev 61)
	Subsystem: Intel Corporation Unknown device 1121
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fe8fe000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
00: 86 80 29 42 06 01 10 00 61 00 80 02 10 00 00 00
10: 04 e0 8f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 21 11
30: 00 00 00 00 c8 00 00 00 00 00 00 00 0a 01 00 00


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspcivvxx_good

00:00.0 Host bridge: Intel Corporation Mobile Memory Controller Hub (rev 0c)
	Subsystem: Dell Unknown device 01fe
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Capabilities: <access denied>
00: 86 80 00 2a 06 00 90 20 0c 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00

00:02.0 VGA compatible controller: Intel Corporation Mobile Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fea00000 (64-bit, non-prefetchable) [size=1M]
	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at eff8 [size=8]
	Capabilities: <access denied>
00: 86 80 02 2a 07 00 90 00 0c 00 00 03 00 00 80 00
10: 04 00 a0 fe 00 00 00 00 0c 00 00 e0 00 00 00 00
20: f9 ef 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 90 00 00 00 00 00 00 00 0b 01 00 00

00:02.1 Display controller: Intel Corporation Mobile Integrated Graphics Controller (rev 0c)
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: Memory at feb00000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: <access denied>
00: 86 80 03 2a 07 00 90 00 0c 00 80 03 00 00 80 00
10: 04 00 b0 fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 d0 00 00 00 00 00 00 00 00 00 00 00

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 4: I/O ports at 6f20 [size=32]
00: 86 80 34 28 05 00 80 02 02 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 21 6f 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 00 00

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #5 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 20
	Region 4: I/O ports at 6f00 [size=32]
00: 86 80 35 28 05 00 80 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 6f 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 09 02 00 00

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #2 (rev 02) (prog-if 20 [EHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 21
	Region 0: Memory at fed1c400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
00: 86 80 3a 28 06 01 90 02 02 20 03 0c 00 00 00 00
10: 00 c4 d1 fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 50 00 00 00 00 00 00 00 05 03 00 00

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
	Subsystem: Dell Unknown device 01fe
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at fe9fc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
00: 86 80 4b 28 06 01 10 00 02 00 03 04 10 00 00 00
10: 04 c0 9f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 50 00 00 00 00 00 00 00 09 01 00 00

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 3f 28 07 05 10 00 02 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 0b 0b 00 f0 00 00 00
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 02 00

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
	Memory behind bridge: fe800000-fe8fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 41 28 07 05 10 00 02 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 0c 0c 00 f0 00 00 00
20: 80 fe 80 fe f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 02 02 00

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0d, subordinate=0e, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fe600000-fe7fffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f01fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 45 28 07 04 10 00 02 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 0d 0e 00 d0 d0 00 00
20: 60 fe 70 fe 01 f0 11 f0 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 04 02 00

00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
	Memory behind bridge: fe500000-fe5fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 49 28 07 04 10 00 02 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 09 09 00 f0 00 00 00
20: 50 fe 50 fe f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 02 02 00

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 4: I/O ports at 6f80 [size=32]
00: 86 80 30 28 05 00 80 02 02 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 6f 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 00 00

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 20
	Region 4: I/O ports at 6f60 [size=32]
00: 86 80 31 28 05 00 80 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 61 6f 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 09 02 00 00

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 21
	Region 4: I/O ports at 6f40 [size=32]
00: 86 80 32 28 05 00 80 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 41 6f 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 03 00 00

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #1 (rev 02) (prog-if 20 [EHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at fed1c000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
00: 86 80 36 28 06 01 90 02 02 20 03 0c 00 00 00 00
10: 00 c0 d1 fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=07, sec-latency=32
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: fe400000-fe4fffff
	Prefetchable memory behind bridge: 00000000f4000000-00000000f7ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>
00: 86 80 48 24 07 00 10 00 f2 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 03 07 20 20 20 80 a2
20: 40 fe 40 fe 01 f4 f1 f7 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 02 00

00:1f.0 ISA bridge: Intel Corporation Mobile LPC Interface Controller (rev 02)
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: <access denied>
00: 86 80 15 28 07 01 10 02 02 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00

00:1f.1 IDE interface: Intel Corporation Mobile IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 6fa0 [size=16]
00: 86 80 50 28 05 00 80 02 02 8a 01 01 00 00 00 00
10: f1 01 00 00 f5 03 00 00 71 01 00 00 75 03 00 00
20: a1 6f 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00

00:1f.2 SATA controller: Intel Corporation Mobile SATA AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 219
	Region 0: I/O ports at 6eb0 [size=8]
	Region 1: I/O ports at 6eb8 [size=4]
	Region 2: I/O ports at 6ec0 [size=8]
	Region 3: I/O ports at 6ec8 [size=4]
	Region 4: I/O ports at 6ee0 [size=32]
	Region 5: Memory at fe9fb800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
00: 86 80 29 28 07 04 b0 02 02 01 06 01 00 00 00 00
10: b1 6e 00 00 b9 6e 00 00 c1 6e 00 00 c9 6e 00 00
20: e1 6e 00 00 00 b8 9f fe 00 00 00 00 28 10 fe 01
30: 00 00 00 00 80 00 00 00 00 00 00 00 0a 02 00 00

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 10
	Region 0: Memory at fe9fb700 (32-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 10c0 [size=32]
00: 86 80 3e 28 03 01 80 02 02 00 05 0c 00 00 00 00
10: 00 b7 9f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: c1 10 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 02 00 00

03:01.0 CardBus bridge: O2 Micro, Inc. Cardbus bridge (rev 21)
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 168
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fe400000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=03, secondary=04, subordinate=07, sec-latency=176
	Memory window 0: f4000000-f7fff000 (prefetchable)
	Memory window 1: f8000000-fbfff000
	I/O window 0: 00002000-000020ff
	I/O window 1: 00002400-000024ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
00: 17 12 35 71 87 00 10 04 21 00 07 06 00 a8 82 00
10: 00 00 40 fe a0 00 00 02 03 04 07 b0 00 00 00 f4
20: 00 f0 ff f7 00 00 00 f8 00 f0 ff fb 01 20 00 00
30: fd 20 00 00 01 24 00 00 fd 24 00 00 ff 01 c0 05
40: 28 10 fe 01 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

03:01.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02) (prog-if 10 [OHCI])
	Subsystem: Dell Unknown device 01fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fe4ff000 (32-bit, non-prefetchable) [size=4K]
	Region 1: Memory at fe4fe800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
00: 17 12 f7 00 17 01 18 02 02 10 00 0c 10 40 00 00
10: 00 f0 4f fe 00 e8 4f fe 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 00 00 60 00 00 00 00 00 00 00 03 01 00 00

09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5755M Gigabit Ethernet PCI Express (rev 02)
	Subsystem: Dell Unknown device 01fe
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 218
	Region 0: Memory at fe5f0000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: <access denied>
00: e4 14 73 16 06 05 10 00 02 00 00 02 10 00 00 00
10: 04 00 5f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 fe 01
30: 00 00 82 14 48 00 00 00 00 00 00 00 0a 01 00 00

0c:00.0 Network controller: Intel Corporation Unknown device 4229 (rev 61)
	Subsystem: Intel Corporation Unknown device 1121
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fe8fe000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
00: 86 80 29 42 06 01 10 00 61 00 80 02 10 00 00 00
10: 04 e0 8f fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 21 11
30: 00 00 00 00 c8 00 00 00 00 00 00 00 0a 01 00 00


--PNTmBPCT7hxwcZjr--
