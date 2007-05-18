Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbXERHZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbXERHZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXERHZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:25:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35896 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbXERHZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:25:08 -0400
Date: Fri, 18 May 2007 00:22:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mattia Dongili <malattia@linux.it>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
Subject: Re: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after
 STR
Message-Id: <20070518002240.bc08e811.akpm@linux-foundation.org>
In-Reply-To: <20070518071523.GA3195@inferi.kami.home>
References: <20070518071523.GA3195@inferi.kami.home>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 16:15:24 +0900 Mattia Dongili <malattia@linux.it> wrote:

> Hello,
> 
> After finally catching fw-{ohci,core} to be problematic during resume,
> I'm now experiencing an immediate resume after suspending.
> 
> 2.6.21-rc7-mm* didn't even suspend, my last known suspend-and-resuming
> kernel was 2.6.21-rc5-mm3 (I know one other vaio SZ user could STR with
> 2.6.21-rc6-mm* after the cpuidle fixes).
> 
> my .config is: http://oioio.altervista.org/linux/config-2.6.22-rc1-mm1-1
> and a str cycle with PM_DEBUG=y:
> http://oioio.altervista.org/linux/dmesg-SRT-immediately-resumes.txt
> 
> So this is on a vaio Sz72B,
> 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
> 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
> 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
> 00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
> 00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 02)
> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
> 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
> 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02)
> 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA Storage Controller IDE (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
> 06:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
> 07:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8036 PCI-E Fast Ethernet Controller (rev 15)
> 09:04.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
> 09:04.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller
> 09:04.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD)
> 
> Any idea where to start from? (bisecting is ok, but it'll take some
> time...)

Bisecting isn't that bad ;) I'd pick git-acpi.patch as the starting point.

