Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbYECXSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbYECXSl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 19:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYECXSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 19:18:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45053 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbYECXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 19:18:32 -0400
Date: Sat, 3 May 2008 16:18:13 -0700
From: Greg KH <greg@kroah.com>
To: Malte =?iso-8859-1?Q?Schr=F6der?= <maltesch@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hard lockup with kernel 2.6.25 and 2.6.25.1
Message-ID: <20080503231813.GA18248@kroah.com>
References: <20080504005209.13af2b2c@highlander.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080504005209.13af2b2c@highlander.home.lan>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 12:52:09AM +0200, Malte Schröder wrote:
> Hello,
> my Athlon XP locks up hard with the current stable kernel. Output of
> lspci, the .config and dump from serial console is attached.
> This happens without warning or special actions. 
> This incident happened only a few hours after booting the new kernel,
> SysRq-keys didn't work. 2.6.24.5 has been running fine.
> 
> The problem starts at line 390 of the dump ([42323.063854] eth0:
> command 0x3002 did not complete! Status=0x9000), after that it looks like all pci devices get stuck.
> I hope this mail contains all relevant information.

Hm, this doesn't look good.  Is it repeatable?  Your log shows all the
PCI devices pretty much going out to lunch, which is very odd.

If it's repeatable, it would be interesting if you are able to do a
git-bisect to try to narrow the issue down...

> [    0.674334] ACPI: PCI Interrupt Link [ALKA] disabled and referenced, BIOS bug
> [    0.675016] ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
> [    0.675909] ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20

Does these lines also show up in 2.6.24.5?

thanks,

greg k-h
