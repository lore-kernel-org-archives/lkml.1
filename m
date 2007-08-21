Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbXHUWNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbXHUWNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 18:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbXHUWNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 18:13:39 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:35228 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbXHUWNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 18:13:38 -0400
Message-ID: <46CB626F.8020801@gmail.com>
Date: Wed, 22 Aug 2007 00:08:47 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Jos=E9_Luis_Pati=F1o_Andr=E9s?= 
	<jopan@alumni.uv.es>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problems with IDE on linux 2.6.22.X
References: <200708212149.12912.jopan@alumni.uv.es>
In-Reply-To: <200708212149.12912.jopan@alumni.uv.es>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2007 09:49 PM, José Luis Patiño Andrés wrote:

> Somebody tolds me that I can solve this problem unchecking the
> IDE_GENERIC option in the kernel configuration. It's true, but when I do
> this the DVD device is not recognized by the kernel. No exists.

The OpenSuSE Live CD thing not booting may mean you have a deeper problem,
but please note that you shouldn't be using ide-disk:

> In my working 2.6.20.15 kernel, the 'cat /proc/ide/drivers' command
> outputs this:

> ###################
> #ide-disk		version	1.18
> #ide-cdrom	version	4.61
> ###################
> 
> But in 2.6.22.X, the output is only:
> ###################
> #ide-disk		version 1.18
> ###################

You have a SATA harddrive (Hitachi Travelstar 5K100 100GB SATA/2.5") and an
IDE (also known as PATA) DVD drive (LG GMA-4082N). That is, your disk should 
be driven by the:

"Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"

under the "Serial ATA (prod) and Parallel ATA (experimental) drivers" menu, 
and it seems this driver should also take care of your DVD. Not sure from 
your report what you are using -- first try with only that driver, and 
nothing from the old "ATA/ATAPI/MFM/RLL support" menu selected.

In that situation, your harddrive works, but your DVD does not?

If so, this should be fixed in the driver, but to get things working I 
believe you may try with both the above driver for your harddisk and the old 
IDE driver for the DVD:

<*>   Enhanced IDE/MFM/RLL disk/cdrom/tape/floppy support
<*>     Include IDE/ATAPI CDROM support (NEW)
[*]     PCI IDE chipset support
[*]     Generic PCI bus-master DMA support
<*>       Intel PIIXn chipsets support

(do not select IDE/ATA-2 disk support)

where you may need to boot with a "libata.atapi_enabled=0" kernel parameter.

Not actually particularly sure if that works given that it's the same chip 
and all it seems but anyways, please first verify results with only that 
SATA driver.

Rene.
