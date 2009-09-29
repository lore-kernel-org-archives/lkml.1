Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbZI2HyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbZI2HyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 03:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZI2HyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 03:54:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:54597 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751316AbZI2HyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 03:54:15 -0400
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 29 Sep 2009 09:54:16 +0200
From: "Lennart Baruschka" <FunFlyer@gmx.net>
In-Reply-To: <20090928234025.6dc4e3f7@lxorguk.ukuu.org.uk>
Message-ID: <20090929075416.77960@gmx.net>
MIME-Version: 1.0
References: <1254173481.4454.32.camel@goodbyte.homelinux.com>
 <20090928234025.6dc4e3f7@lxorguk.ukuu.org.uk>
Subject: Re: Disabling DMA with ICH10?
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
X-Authenticated: #272795
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/uPWwt3AHupZNG8Yw97BnefPxs36eMBL85tl3fUs
 kFDnqdomK7XXHbUvlvP5Sd6z3D8auDYtCpkQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: e8mkOhx/ZCEEIfVTYWwh0a54IGhpZcbz
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

On Mon, 2009-09-28 at 23:40 +0100, Alan Cox wrote:
> > 2. My system uses an ICH10 chipset, the harddrive is connected to the
> > Intel SATA controller. Is there a way to disable DMA and switch back to
> > PIO? I tried compiling with libata support and without SCSI support, but
> > the kernel is unable to mount root (no matter if /dev/sda1
> > or /dev/hda1), then.
> 
> If you disable DMA you will make your performance and latency worse not
> better as the PIO transfers will stall the bus and thus the processor.

I thought that PIO transfers (which I understand to be
write32()/read32()'s) unlike DMA transfers could be interrupted by an
high-priority interrupt. Is that wrong?



> If you really are that latency sensitive then the more normal approach
> would be to lock one core for real time use, load the critical code into
> that core CPU cache and run from cache. If you are utterly pushing the
> limit you might even do crazy stuff like use on thread on the core to
> execute RT stuff and the other to issue any I/O accesses that might stall.

Actually, that's what I do - except for locking the page, yet. I do need
to access the PCI bus in real time, though. So I wonder what happens
when the RT CPU is getting data from the PCI device, doing some
calculations on it and then writing back some data to the device,
__while at the same time__ another (non-RT) CPU starts a DMA transfer. I
figured the DMA would block the PCI bus, having my interrupt wait for it
to finish. That's why I'm trying to avoid DMA. 

Please let me know at what point I am mistaken.


Cheers
Lennart

-- 
Jetzt kostenlos herunterladen: Internet Explorer 8 und Mozilla Firefox 3.5 -
sicherer, schneller und einfacher! http://portal.gmx.net/de/go/atbrowser
