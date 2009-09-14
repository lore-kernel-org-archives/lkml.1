Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbZINHKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbZINHKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZINHKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:10:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915AbZINHKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:10:49 -0400
Date: Mon, 14 Sep 2009 00:10:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suresh Jayaram <sureshjayaram@gmail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: mmotm 2009-09-09-22-56 uploaded
Message-Id: <20090914001039.8c4d467a.akpm@linux-foundation.org>
In-Reply-To: <38c3c4860909132302j3fd7afe1p984b91d74eb1d782@mail.gmail.com>
References: <200909100601.n8A61Eju002109@imap1.linux-foundation.org>
	<38c3c4860909132302j3fd7afe1p984b91d74eb1d782@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 11:32:59 +0530 Suresh Jayaram <sureshjayaram@gmail.com> wrote:

> Hi Andrew,
> 
> On Thu, Sep 10, 2009 at 11:31 AM, <akpm@linux-foundation.org> wrote:
> >
> > The mm-of-the-moment snapshot 2009-09-09-22-56 has been uploaded to
> >
> > __ http://userweb.kernel.org/~akpm/mmotm/
> >
> > and will soon be available at
> >
> > __ git://git.zen-sources.org/zen/mmotm.git
> >
> 
> The current mmotm doesn't boot my T60p. It hangs (hardlock) very early
> during the boot after Uncompressing the kernel image. The last message
> I see on the screen is
> 
> "Probing EDD (edd=off to disable)...
> 
> Trying with edd=off didn't help. Other commandline options that didn't
> help include (acpi=off, noapic,nolapic,pci=no). It appears that it
> hardlocks during hardware detection.

hm, that's before we even get into the kernel.  The next thing we do is
set_video() and there are some small video-related changes in
linux-next down in arch/x86/boot/.


> Attached is my kernel config:
> 
> lspci output:
> 
> ---cut here---
> 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML
> and 945GT Express Memory Controller Hub (rev 03)
> 00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML
> and 945GT Express PCI Express Root Port (rev 03)
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
> Definition Audio Controller (rev 02)
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 1 (rev 02)
> 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 2 (rev 02)
> 00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 3 (rev 02)
> 00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 4 (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
> UHCI Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
> UHCI Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
> UHCI Controller #3 (rev 02)
> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
> UHCI Controller #4 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
> EHCI Controller (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
> 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
> Bridge (rev 02)
> 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
> Controller (rev 02)
> 00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family)
> SATA AHCI Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
> 01:00.0 VGA compatible controller: ATI Technologies Inc M56GL
> [Mobility FireGL V5250]
> 02:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet
> Controller
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
> [Golan] Network Connection (rev 02)
> 15:00.0 CardBus bridge: Texas Instruments PCI1510 PC card Cardbus Controller

