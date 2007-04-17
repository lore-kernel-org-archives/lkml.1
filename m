Return-Path: <linux-kernel-owner+w=401wt.eu-S1031217AbXDQRFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031217AbXDQRFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031215AbXDQRFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:05:22 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:49688 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1031216AbXDQRFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:05:21 -0400
Message-ID: <4624FE88.2010908@ru.mvista.com>
Date: Tue, 17 Apr 2007 21:06:16 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc6-mm1 ATA HPT37x regression
References: <17956.12963.163961.762444@smtp.charter.net>	<4624D4C3.9010109@ru.mvista.com> <17956.63043.521397.597430@smtp.charter.net>
In-Reply-To: <17956.63043.521397.597430@smtp.charter.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:

>>>I was just testing out 2.6.21-rc6-mm1 to test some Cyclades patches
>>>and I noticed that my HPT302 (rev1) controller with a pair of 120gb WD
>>>disks are not longer detected and I get the following in the dmesg
>>>logs:
 
>>>[  148.121490] hpt37x: DPLL did not stabilize.
 
>>>Where before, under 2.6.21-rc6 I got the following:
 
> Sergei> For the moment I thought you're reporting another hpt366.c
> Sergei> driver breakage but then noticed the next line:

> I used to think that I wanted to use that driver too, but it's not
> going to work.  It's because I've got the version 1 of the chip, not
> the newer version 2 or higher version.

   So what?

> It looks like you really mean for me to use the hpt3x2.c driver
> instead, since that's the only other one which mentions the
> PCI_DEVICE_ID_TTI_HPT302 device id in it's init method.

   I actually meant drivers/ide/pci/hpt366.c. :-)
 
>>>[  173.749349] pata_hpt37x: BIOS has not set timing clocks.
>>>[  173.752949] hpt37x: HPT302: Bus clock 33MHz.
 
> Sergei>    Obviously this was bacause of switching from PCI to DPLL
> Sergei>    clock. The old and new drivers are different in how they
> Sergei>    handle DPLL calibration though.  Could you try hpt366.c
> Sergei>    (there's been report about its failure too recently -- not
> Sergei>    enought details yet)?

> I don't think it will work here, it won't even touch the card since
> the pci_device_id won't match at all.  The htp366.c only looks at
> HPT366 ids, while mine is an HPT302 id.

   The driver I've named should work (unless something is broken somewhere, that is).
Basically, it uses wider range to calibrate DPLL.

> As a quick note, 2.6.21-rc7 is working just fine here.

   Yeah, it's still using PCI clock.

> Ok, so do I need to do anything special with the next -mm release and
> the next version?

   Well, let Alan decide that (2Alan: and I said that HPT code is bogus :-).

> Thanks,
> John

MBR, Sergei
