Return-Path: <linux-kernel-owner+w=401wt.eu-S1762025AbYDOUVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762025AbYDOUVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbYDOUV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:21:28 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:43340 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYDOUV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:21:28 -0400
Message-ID: <48050EF1.8050507@keyaccess.nl>
Date: Tue, 15 Apr 2008 22:24:17 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
CC: Alessandro Suardi <alessandro.suardi@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ehci-hcd affects hda speed
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <200803171700.26274.david-b@pacbell.net> <47DF19AD.405@keyaccess.nl> <200803171855.44552.david-b@pacbell.net> <alpine.LFD.1.00.0803200211230.31035@nev.ubzr>  <47E1B062.4060709@keyaccess.nl> <alpine.LFD.1.10.0804152220560.6429@nev.ubzr>
In-Reply-To: <alpine.LFD.1.10.0804152220560.6429@nev.ubzr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-04-08 21:56, Lev A. Melnikovsky wrote:

> Sorry, I had virtually no time to answer earlier. If (hopefully) someone 
> is still interested, here's my feedback

Interested yes, although being no longer in posession of the hardware it's a 
somewhat academic interest...

> I have repeated experiments with P3B-F and VT6212L combination (to 
> improve visibility the AsyncSchedSleepTime is set to 1us):
> 
> #0. Nothing is connected to USB, no ehci-hcd loaded
>       hda throughput 28+-1MB/s
> 
> #1. ehci-hcd loaded, still no USB peripherals
>       hda throughput 28+-1 MB/s
> 
> #2. Something (USB hub and FLASH drive tested) is attached
>       hda throughput 15+-1 MB/s
> 
> #3. All USB peripherals are removed
>       hda throughput 15+-1 MB/s
> 
> #4. ehci-hcd is rmmod'ed
>       hda throughput 28+-1MB/s
> 
> The oddest peculiarity for me is the hysteretic difference between #1 and 
> #3 states. I mean experimental data (hda throughput) depends not on the 
> state (hardware/loaded modules), but on the path we followed.

On the chip having inited itself at least. Yes, your results match what I 
experienced.

> Interestingly enough, sampling registers (via /sys) often shows Async bit 
> set of the status register in the state #3. It is always cleared in #1. 
> The async file is empty in both states. I wonder, how many degrees of 
> freedom does an empty schedule have? Does "empty" mean "has no incomplete 
> requests" or "has no requests at all"? Just guessing...

Should leave this up to David, but as far as I'm aware "no at all".

> RH> The sleep time wasn't the core problem, so I wonder of later VIA chips do
> RH> still have the active async schedule problem...
> I don't think this is purely VIA problem. I did not _try_ to install that 
> VT6212L card into newer motherboard, but my _feeling_ is that we see an 
> "incompatibility" between older PCI mobo chipsets and VIA USB controller.

I very much doubt that. Can't really imagine an off-silicon reason the chip 
would keep scanning the async schedule. I'm also now using a NEC controller 
card in that same machine and it also shows no problems.

> Actually, taking into account superior PCI bandwidth of modern PCs (if 
> compared with my old P3B-F motherboard) I am not sure we can perform a 
> clean reliable test without PCI bus analyzer.

http://lkml.org/lkml/2005/5/30/259

> 
> -l
> 

