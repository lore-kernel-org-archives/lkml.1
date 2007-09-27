Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbXI0ADn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbXI0ADn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 20:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXI0ADf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 20:03:35 -0400
Received: from xenotime.net ([66.160.160.81]:34788 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751067AbXI0ADe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 20:03:34 -0400
Date: Wed, 26 Sep 2007 17:03:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jim Paris <jim@jtan.com>, linas@austin.ibm.com
Cc: AndrewL733 <AndrewL733@aol.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       samson yeung <fragmede@onepatchdown.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, bbermack@alum.mit.edu,
       Justin Mazzola Paluska <jmp@mit.edu>
Subject: Re: NMI error and Intel S5000PSL Motherboards
Message-Id: <20070926170330.ee8fb5b4.rdunlap@xenotime.net>
In-Reply-To: <20070926234814.GA27743@jim.sh>
References: <c038f5910709261207k740ad130k151a9b0c8d8e48e0@mail.gmail.com>
	<20070926135229.67edd4eb.rdunlap@xenotime.net>
	<c038f5910709261207k740ad130k151a9b0c8d8e48e0@mail.gmail.com>
	<46FA3092.70108@aol.com>
	<20070926121655.55334682@the-village.bc.nu>
	<46FA3092.70108@aol.com>
	<20070925215819.c993e2d8.rdunlap@xenotime.net>
	<46FA3092.70108@aol.com>
	<20070925195946.cef5ae9d.rdunlap@xenotime.net>
	<46FA3092.70108@aol.com>
	<20070926234814.GA27743@jim.sh>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 19:48:14 -0400 Jim Paris wrote:

> Hello,
> 
> > We have about 100 servers based on Intel S5000PSL-SATA motherboards. 
> > They have been running for anywhere between 1 and 10 months. For the 
> > past few months, after updating them all to the 2.6.20.15 kernel 
> > (because of a bug in the 2.6.18 kernel), we are seeing some strange NMI 
> > errors. For example:
> > 
> > Aug 29 09:02:10 master kernel: Uhhuh. NMI received for unknown reason 30.
> > Aug 29 09:02:10 master kernel: Do you have a strange power saving mode enabled?
> > Aug 29 09:02:10 master kernel: Dazed and confused, but trying to continue
> 
> I'm also working with Andrew and Samson.  It seems that the cause of
> the problem is CONFIG_PCIEAER, which was introduced after 2.6.18 and
> defaults to y.
> 
> With CONFIG_PCIEAER=n, scanpci works fine with no errors.  This is the
> workaround that they'll likely use for now.

Glad that you found it.

> With CONFIG_PCIEAER=y, scanpci always triggers the NMI error.  The
> option aerdriver.forceload=1 has no effect.

The 'forceload' option only forces the driver to load even when the
ACPI hardware initialization routine fails.

It would be nice to be able to disable PCIEAER at boot time though.
Shouldn't be difficult.


> The related dmesg output at boot is:
> 
>   Evaluate _OSC Set fails. Status = 0x0005
>   Evaluate _OSC Set fails. Status = 0x0005
>   aer_init: AER service init fails - Run ACPI _OSC fails
>   aer: probe of 0000:00:02.0:pcie01 failed with error 2
>   aer_init: AER service init fails - No ACPI _OSC support
>   aer: probe of 0000:00:03.0:pcie01 failed with error 1
>   Evaluate _OSC Set fails. Status = 0x0005
>   Evaluate _OSC Set fails. Status = 0x0005
>   aer_init: AER service init fails - Run ACPI _OSC fails
>   aer: probe of 0000:00:04.0:pcie01 failed with error 2
>   Evaluate _OSC Set fails. Status = 0x0005
>   Evaluate _OSC Set fails. Status = 0x0005
>   aer_init: AER service init fails - Run ACPI _OSC fails
>   aer: probe of 0000:00:05.0:pcie01 failed with error 2
>   Evaluate _OSC Set fails. Status = 0x0005
>   Evaluate _OSC Set fails. Status = 0x0005
>   aer_init: AER service init fails - Run ACPI _OSC fails
>   aer: probe of 0000:00:06.0:pcie01 failed with error 2
>   aer_init: AER service init fails - No ACPI _OSC support
>   aer: probe of 0000:00:07.0:pcie01 failed with error 1
> 
> Full dmesg, lspci, and ACPI DSDT are available here:
>   http://jim.sh/~jim/tmp/nmi/
> 
> -jim


---
~Randy
Phaedrus says that Quality is about caring.
