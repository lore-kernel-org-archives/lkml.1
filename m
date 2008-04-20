Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYDTSTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYDTSTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYDTSTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:19:13 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:43939 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbYDTSTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:19:12 -0400
Date: Sun, 20 Apr 2008 12:21:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: dying hdd causing MCE and panic (libata)
In-reply-to: <fa.wEQ+jetKkQxiDyPBYbk6js8pT+0@ifi.uio.no>
To: Rumi Szabolcs <rumi_ml@rtfm.hu>
Cc: linux-kernel@vger.kernel.org, Peer Chen <pchen@nvidia.com>,
       Kuan Luo <kluo@nvidia.com>, Allen Martin <AMartin@nvidia.com>
Message-id: <480B8992.4090308@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.wEQ+jetKkQxiDyPBYbk6js8pT+0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rumi Szabolcs wrote:
> Hello all!
> 
> A SATA drive in one of my servers has made some final steps towards
> the grave and it has put out some obvious signs of this onto the
> console (ATA transactions failing) but then it has also thrown an
> MCE (CPU context corrupt) and then the kernel has panicked.
> This server is rock stable otherwise and used to make uptimes
> measured in months between planned restarts.
> 
> The machine has been removed from power completely and restarted
> multiple times but during the boot process it always crashed with
> an MCE or a panic or both.
> 
> Sorry but I cannot provide exact debug information right now because
> I wasn't physically there at the time and I'm still 250kms away from
> that server. In fact I've remotely guided two people without a clue
> through the phone and they have read things from the console for me,
> restarted the machine, etc.
> 
> So in the end I told them to open up the server and pull the SATA
> cable from that particular drive. Suddenly all the MCEs and panics
> had gone away and the machine is running fine since then.
> 
> Hardware:
> 
> - Nforce4 based motherboard (chipset integrated SATA ports)
> - Athlon64 single core CPU
> - Diamondmax 9 SATA hard drive
> 
> Kernel:
> 
> 2.6.23-gentoo-r3 (no preempt, no smp)
> 
> My questions:
> 
> - Is it normal that a simple hard disk failure (that is not even
> the system disk) causes MCEs and kernel panics?
> 
> - Is this a problem that is induced completely on the hardware
> level (eg. the southbridge going crazy and making the whole
> hardware platform unstable) or a problem that could be fixed
> or handled properly on the software (kernel) level?

It's known that nForce4 ADMA can in certain cases hang on error handling 
and cause an MCE when we attempt to switch the controller into register 
mode and read the  ATA registers in order to diagnose the problem. The 
MCE indicates the CPU timed out waiting for a register read from the 
chipset on the HyperTranport bus. It's not presently known why this is, 
or what we could do differently to avoid this problem. We're presently 
hampered by lack of public information from NVIDIA on this controller to 
fix this, so the ball is kind of in NVIDIA's court.

In the latest kernels sata_nv ADMA support is being disabled by default, 
which may prevent this from happening. However, some odd hotplug/error 
handling behavior was seen on these controllers before ADMA support was 
implemented, so it may not entirely fix the problem.
