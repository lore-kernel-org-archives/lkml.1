Return-Path: <linux-kernel-owner+w=401wt.eu-S1751885AbXFKLNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbXFKLNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 07:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbXFKLNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 07:13:15 -0400
Received: from relay4.usu.ru ([194.226.235.39]:34094 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbXFKLNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 07:13:14 -0400
Message-ID: <466D2E52.4000904@ums.usu.ru>
Date: Mon, 11 Jun 2007 17:13:22 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org
Subject: Re: ide0=noprobe, hda=noprobe, hda=none ignored?
References: <20070610185439.GA12202@alinoe.com>
In-Reply-To: <20070610185439.GA12202@alinoe.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carlo Wood wrote:
> I've been trying for months to get my box to boot faster
> by ignoring the not connected hda/hdb (ide0).
> 
> ansset:~>dmesg | egrep '(noprobe|ide0|hda|hdb)'
> 
> Kernel command line: root=/dev/hde3 ro ide0=noprobe
>     ide0: BM-DMA at 0xd800-0xd807, BIOS settings: hda:pio, hdb:pio
> Probing IDE interface ide0...
> hda: IRQ probe failed (0xfffffdb8)
> etc.
> 
> or
> 
> Kernel command line: root=/dev/hde3 ro hda=none hdb=none
>     ide0: BM-DMA at 0xd800-0xd807, BIOS settings: hda:pio, hdb:pio
> Probing IDE interface ide0...
> hda: IRQ probe failed (0xfffffdb8)
> 
> same for hda=noprobe hdb=noprobe
> 
> Nothing helps.
> 
> Is this a bug or not? I'd think that saying "noprobe" means
> "do NOT probe" - but it probes anyway.


If your kernel uses modular IDE drivers and an initrd/initramfs that loads 
them, your result is the expected one (i.e.: not a bug). One should add the 
following or similar options into /etc/modprobe.conf in the initrd in order 
to get the result:

options ide_core options="ide0=noprobe hda=noprobe hdb=noprobe"

If you don't use initrd, or have a non-modular IDE driver, please ignore 
this message.

-- 
Alexander E. Patrakov
