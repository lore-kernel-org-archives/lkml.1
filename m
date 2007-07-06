Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbXGFPSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbXGFPSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbXGFPSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:18:00 -0400
Received: from web32602.mail.mud.yahoo.com ([68.142.207.229]:46110 "HELO
	web32602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755324AbXGFPSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:18:00 -0400
X-YMail-OSG: pMoK8CMVM1n9C_Wek5j4BCoJ2UR7i69Xysor8Z5f8IAmkY7JA7m.kE8Rn_HVrpVbZ_QHwhGLT93.C8Q.kaxW6jeRAQ--
X-RocketYMMF: knobi.rm
Date: Fri, 6 Jul 2007 08:17:54 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Re: Understanding I/O behaviour
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220707060725q34005bcfu8f225cf1e3391e61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <37949.90952.qm@web32602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Daniel J Blueman <daniel.blueman@gmail.com> wrote:

> On 5 Jul, 16:50, Martin Knoblauch <spamtrap@knobisoft.de> wrote:
> > Hi,
> >
> >  for a customer we are operating a rackful of HP/DL380/G4 boxes
> that
> > have given us some problems with system responsiveness under [I/O
> > triggered] system load.
> [snip]
> 
> IIRC, the locking in the CCISS driver was pretty heavy until later in
> the 2.6 series (2.6.16?) kernels; I don't think they were backported
> to the 1000 or so patches that comprise RH EL 4 kernels.
> 
> With write performance being really poor on the Smartarray
> controllers
> without the battery-backed write cache, and with less-good locking,
> performance can really suck.
> 
> On a total quiescent hp DL380 G2 (dual PIII, 1.13GHz Tualatin 512KB
> L2$) running RH EL 5 (2.6.18) with a 32MB SmartArray 5i controller
> with 6x36GB 10K RPM SCSI disks and all latest firmware:
> 
> # dd if=/dev/cciss/c0d0p2 of=/dev/zero bs=1024k count=1000
> 509+1 records in
> 509+1 records out
> 534643200 bytes (535 MB) copied, 11.6336 seconds, 46.0 MB/s
> 
> # dd if=/dev/zero of=/dev/cciss/c0d0p2 bs=1024k count=100
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 22.3091 seconds, 4.7 MB/s
> 
> Oh dear! There are internal performance problems with this
> controller.
> The SmartArray 5i in the newer DL380 G3 (dual P4 2.8GHz, 512KB L2$)
> is
> perhaps twice the read performance (PCI-X helps some) but still
> sucks.
> 
> I'd get the BBWC in or install another controller.
> 
Hi Daniel,

 thanks for the suggestion. The DL380g4 boxes have the "6i" and all
systems are equipped with the BBWC (192 MB, split 50/50).

 The thing is not really a speed daemon, but sufficient for the task.

 The problem really seems to be related to the VM system not writing
out dirty pages early enough and then getting into trouble when the
pressure gets to high.

Cheers
Martin



------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
