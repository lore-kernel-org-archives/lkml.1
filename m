Return-Path: <linux-kernel-owner+w=401wt.eu-S1751307AbXBMMZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbXBMMZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 07:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXBMMZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 07:25:11 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:39484 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbXBMMZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 07:25:09 -0500
Message-ID: <45D1AE13.9000504@citd.de>
Date: Tue, 13 Feb 2007 13:24:51 +0100
From: Matthias Schniedermeyer <ms@citd.de>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Martin A. Fink" <fink@mpe.mpg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
References: <200702121502.17130.fink@mpe.mpg.de> <200702131025.15964.fink@mpe.mpg.de> <45D19014.5080900@citd.de> <200702131129.19270.fink@mpe.mpg.de>
In-Reply-To: <200702131129.19270.fink@mpe.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin A. Fink wrote:

>> Also you have skipped the information how the images "arrive" on the system 
> (PCI(e) card?), that may be important for an "end to end" view of the 
> problem.
> 
> Images arrive via Gigabit Ethernet. GigE Vision standard. (PCIe x4)

The the next question is: ChipSet/Used Protocol/JumboFrames/(NAPI)/... .

Have you already determined the load caused by this part?
Depending on the GigE-Chipset, and Protocol/JumboFrames/(NAPI)/..., the involved overhead can be quite serious.

>> And what's also missing. What is "a long period of time".
>> Calculating best-case with the SSD:
>> 27GB divided by 30MB/s only gives a bit more than 15 Minutes.
>> And worst case with 50MB/s is less than 10 Minutes.
> 
> Well. The testdrive has 27GB. The final drive will have 225 GB. And there will 
> be 3 cameras and thus 3 disks. This means we talk about 140 MB/s for around 
> 90 minutes.
> For space applications with low power but high performance this is a long 
> time... ;-)

The MB/CPU/RAM will be the one specified in the first mail?
My gut feeling says: Forget it.

The needed total bandwidth may be to high and at least the incoming part via GigE may have serious overhead.
150MB/s in via (at least 2) GigE, without Zero-Copy there is another 150MB/s memory to memory.
Then there is the next 150MB/s memory to the discs, without Zero-Copy there also another 150MB/s memory to memory.
In total that's 300MB/s to 600MB/s without any processing.

But on the other hand, hdparm -T says my system (Core2Duo E6700, FSB1066, 2GB DDR2-800 RAM, 32Bit) has a buffer-cache bandwidth around 4000MB/s.
As you don't said which FSB and Memory-Type you have i would guess that your system should reach between 2000MB/s and 3500MB/s of LINEAR(!) memory bandwidth.
(Total usable Memory-Bandwidth is unfortunately also dependent on usage pattern. Large & linear is not as important as with a rotating HDD, but it factors in)



Btw. On the topic of filesystem and Linux performance:
SGI did a "really big" test some time ago width a big iron having 24 Itanium2-CPUs in 12 nodes, and 12*2 GB of ram and having 256 discs using XFS(Which is from SGI!).
The pdf-file is here:
http://oss.sgi.com/projects/xfs/papers/ols2006/ols-2006-paper.pdf

According the the paper the system had a theoretical peak IO-performance of 11.5 GB/s and practically peaked at 10.7GB/s reading and 8.9GB/s writing.
IOW Linux and XFS CAN perform quite well, but the system has to have enough muscle for the job.
And since the paper (and Kernel 2.6.5) the development of Linux hasn't stopped.



-- 
Real Programmers consider "what you see is what you get" to be just as
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated,
cryptic, powerful, unforgiving, dangerous.

