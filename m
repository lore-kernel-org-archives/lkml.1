Return-Path: <linux-kernel-owner+w=401wt.eu-S1762497AbYDVJf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762497AbYDVJf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbYDVJfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:35:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.112.145]:17439 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYDVJfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:35:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Tue, 22 Apr 2008 02:35:48 -0700
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: dying hdd causing MCE and panic (libata)
Date: Tue, 22 Apr 2008 17:33:26 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B276EB565@hkemmail01.nvidia.com>
In-Reply-To: <480B8992.4090308@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: dying hdd causing MCE and panic (libata)
Thread-Index: AcijEwcgRYI+2W14SKeCCbSvXnEWpwBSD7IQ
References: <fa.wEQ+jetKkQxiDyPBYbk6js8pT+0@ifi.uio.no> <480B8992.4090308@shaw.ca>
From: "Peer Chen" <pchen@nvidia.com>
To: "Robert Hancock" <hancockr@shaw.ca>, "Rumi Szabolcs" <rumi_ml@rtfm.hu>
Cc: <linux-kernel@vger.kernel.org>, "Kuan Luo" <kluo@nvidia.com>,
       "Allen Martin" <AMartin@nvidia.com>
X-OriginalArrivalTime: 22 Apr 2008 09:33:28.0143 (UTC) FILETIME=[EB94B5F0:01C8A45B]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's unresolved machine check error and don't switch to register mode
and read the task file in the driver is the only way to avoid this
error.

BRs
Peer Chen
 

> -----Original Message-----
> From: Robert Hancock [mailto:hancockr@shaw.ca] 
> Sent: Monday, April 21, 2008 2:21 AM
> To: Rumi Szabolcs
> Cc: linux-kernel@vger.kernel.org; Peer Chen; Kuan Luo; Allen Martin
> Subject: Re: dying hdd causing MCE and panic (libata)
> 
> Rumi Szabolcs wrote:
> > Hello all!
> > 
> > A SATA drive in one of my servers has made some final steps towards 
> > the grave and it has put out some obvious signs of this onto the 
> > console (ATA transactions failing) but then it has also 
> thrown an MCE 
> > (CPU context corrupt) and then the kernel has panicked.
> > This server is rock stable otherwise and used to make 
> uptimes measured 
> > in months between planned restarts.
> > 
> > The machine has been removed from power completely and restarted 
> > multiple times but during the boot process it always 
> crashed with an 
> > MCE or a panic or both.
> > 
> > Sorry but I cannot provide exact debug information right 
> now because I 
> > wasn't physically there at the time and I'm still 250kms away from 
> > that server. In fact I've remotely guided two people without a clue 
> > through the phone and they have read things from the 
> console for me, 
> > restarted the machine, etc.
> > 
> > So in the end I told them to open up the server and pull the SATA 
> > cable from that particular drive. Suddenly all the MCEs and 
> panics had 
> > gone away and the machine is running fine since then.
> > 
> > Hardware:
> > 
> > - Nforce4 based motherboard (chipset integrated SATA ports)
> > - Athlon64 single core CPU
> > - Diamondmax 9 SATA hard drive
> > 
> > Kernel:
> > 
> > 2.6.23-gentoo-r3 (no preempt, no smp)
> > 
> > My questions:
> > 
> > - Is it normal that a simple hard disk failure (that is not 
> even the 
> > system disk) causes MCEs and kernel panics?
> > 
> > - Is this a problem that is induced completely on the 
> hardware level 
> > (eg. the southbridge going crazy and making the whole hardware 
> > platform unstable) or a problem that could be fixed or handled 
> > properly on the software (kernel) level?
> 
> It's known that nForce4 ADMA can in certain cases hang on 
> error handling and cause an MCE when we attempt to switch the 
> controller into register mode and read the  ATA registers in 
> order to diagnose the problem. The MCE indicates the CPU 
> timed out waiting for a register read from the chipset on the 
> HyperTranport bus. It's not presently known why this is, or 
> what we could do differently to avoid this problem. We're 
> presently hampered by lack of public information from NVIDIA 
> on this controller to fix this, so the ball is kind of in 
> NVIDIA's court.
> 
> In the latest kernels sata_nv ADMA support is being disabled 
> by default, which may prevent this from happening. However, 
> some odd hotplug/error handling behavior was seen on these 
> controllers before ADMA support was implemented, so it may 
> not entirely fix the problem.
> 
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
