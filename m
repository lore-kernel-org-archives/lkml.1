Return-Path: <linux-kernel-owner+w=401wt.eu-S932348AbYDOT4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbYDOT4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763791AbYDOT41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:56:27 -0400
Received: from dell.benran.ru ([83.149.196.126]:37588 "EHLO ari.home"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759139AbYDOT40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:56:26 -0400
Date: Tue, 15 Apr 2008 23:56:24 +0400 (MSD)
From: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ehci-hcd affects hda speed
In-Reply-To: <47E1B062.4060709@keyaccess.nl>
Message-ID: <alpine.LFD.1.10.0804152220560.6429@nev.ubzr>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <200803171700.26274.david-b@pacbell.net> <47DF19AD.405@keyaccess.nl> <200803171855.44552.david-b@pacbell.net> <alpine.LFD.1.00.0803200211230.31035@nev.ubzr>  <47E1B062.4060709@keyaccess.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Sorry, I had virtually no time to answer earlier. If (hopefully) someone 
is still interested, here's my feedback

  On Thu, 20 Mar 2008 at 3:50am, Rene Herman wrote:

RH> I do wonder -- is your hda throughput also the same before _ever_ 
RH> attaching anything to the EHCI controller and after? In my case, the 
RH> slow down only happened after switching on my external USB drive once, 
RH> and would persist from that time until reboot (or unloading ehci-hcd, 
RH> which I kept modular for exactly that reason).
I have repeated experiments with P3B-F and VT6212L combination (to 
improve visibility the AsyncSchedSleepTime is set to 1us):

#0. Nothing is connected to USB, no ehci-hcd loaded
      hda throughput 28+-1MB/s

#1. ehci-hcd loaded, still no USB peripherals
      hda throughput 28+-1 MB/s

#2. Something (USB hub and FLASH drive tested) is attached
      hda throughput 15+-1 MB/s

#3. All USB peripherals are removed
      hda throughput 15+-1 MB/s

#4. ehci-hcd is rmmod'ed
      hda throughput 28+-1MB/s

The oddest peculiarity for me is the hysteretic difference between #1 and 
#3 states. I mean experimental data (hda throughput) depends not on the 
state (hardware/loaded modules), but on the path we followed.

Interestingly enough, sampling registers (via /sys) often shows Async bit 
set of the status register in the state #3. It is always cleared in #1. 
The async file is empty in both states. I wonder, how many degrees of 
freedom does an empty schedule have? Does "empty" mean "has no incomplete 
requests" or "has no requests at all"? Just guessing...

RH> The sleep time wasn't the core problem, so I wonder of later VIA chips do
RH> still have the active async schedule problem...
I don't think this is purely VIA problem. I did not _try_ to install that 
VT6212L card into newer motherboard, but my _feeling_ is that we see an 
"incompatibility" between older PCI mobo chipsets and VIA USB controller. 
Actually, taking into account superior PCI bandwidth of modern PCs (if 
compared with my old P3B-F motherboard) I am not sure we can perform a 
clean reliable test without PCI bus analyzer.

-l
