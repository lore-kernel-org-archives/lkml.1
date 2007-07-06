Return-Path: <linux-kernel-owner+w=401wt.eu-S1763014AbXGFOZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763014AbXGFOZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbXGFOZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:25:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:19207 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbXGFOZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=aqzeyACoJibFhZSGMoKVfByBUtKtIgIG8nzSp/FU3BVT0xmm6ILWlZoe7SX2c9N61VcN+g7ZqUDOD/6nuWIRFg+ahGbMvrBpPK2X3EfptmyDVADku7nihLQlPNmTS7+mRQRXJXcq6NtAUmOeYdwNIO9XO7Ygtmzg5j9x5YOm7Gg=
Message-ID: <6278d2220707060725q34005bcfu8f225cf1e3391e61@mail.gmail.com>
Date: Fri, 6 Jul 2007 15:25:16 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Martin Knoblauch" <spamtrap@knobisoft.de>
Subject: Re: Understanding I/O behaviour
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Jul, 16:50, Martin Knoblauch <spamtrap@knobisoft.de> wrote:
> Hi,
>
>  for a customer we are operating a rackful of HP/DL380/G4 boxes that
> have given us some problems with system responsiveness under [I/O
> triggered] system load.
[snip]

IIRC, the locking in the CCISS driver was pretty heavy until later in
the 2.6 series (2.6.16?) kernels; I don't think they were backported
to the 1000 or so patches that comprise RH EL 4 kernels.

With write performance being really poor on the Smartarray controllers
without the battery-backed write cache, and with less-good locking,
performance can really suck.

On a total quiescent hp DL380 G2 (dual PIII, 1.13GHz Tualatin 512KB
L2$) running RH EL 5 (2.6.18) with a 32MB SmartArray 5i controller
with 6x36GB 10K RPM SCSI disks and all latest firmware:

# dd if=/dev/cciss/c0d0p2 of=/dev/zero bs=1024k count=1000
509+1 records in
509+1 records out
534643200 bytes (535 MB) copied, 11.6336 seconds, 46.0 MB/s

# dd if=/dev/zero of=/dev/cciss/c0d0p2 bs=1024k count=100
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 22.3091 seconds, 4.7 MB/s

Oh dear! There are internal performance problems with this controller.
The SmartArray 5i in the newer DL380 G3 (dual P4 2.8GHz, 512KB L2$) is
perhaps twice the read performance (PCI-X helps some) but still sucks.

I'd get the BBWC in or install another controller.

Daniel
-- 
Daniel J Blueman
