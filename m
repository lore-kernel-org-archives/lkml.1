Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbZAEUCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbZAEUCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZAEUCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:02:25 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:48703 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbZAEUCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:02:24 -0500
Date: Mon, 5 Jan 2009 21:02:21 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci-quirks: HP hides SMBus controller in Compaq nx9500 laptops
Message-ID: <20090105200221.GA26115@rere.qmqm.pl>
References: <20081223215407.GB32525@rere.qmqm.pl> <19700101064603.GA1406@ucw.cz> <200901051119.20684.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901051119.20684.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 11:19:20AM -0800, Jesse Barnes wrote:
> On Wednesday, December 31, 1969 10:46 pm Pavel Machek wrote:
> > On Tue 2008-12-23 22:54:07, Micha? Miros?aw wrote:
> > > I found no references to SMBus in ACPI DSDT disassembly on my laptop
> > > so this should be safe.
> > >
> > > Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>
> > Well, it could still be used by smm bios traps...
> Also, the changelog doesn't include a description of what this patch fixes, if 
> anything.  Care to resend with an explanation Michal?

This patch enables SMBus controller on HP Compaq nx9500 laptop and
allowes to read SPD EEPROMs of the memory modules.
I found no references to SMBus in ACPI DSDT disassembly on my laptop, but
there are some additional devices on the bus (besides SPD chips).

rechot ~ # lspci -s 00:1f.3
00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus Controller (rev 02)

rechot ~ # i2cdetect -a 0
WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-0.
I will probe address range 0x00-0x7f.
Continue? [Y/n] y
          0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
     00: -- -- -- -- -- -- -- -- 08 -- -- -- -- -- -- --
     10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
     20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
     30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
     40: -- -- -- -- 44 -- -- -- -- -- -- -- -- -- -- --
     50: 50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
     60: -- -- -- -- -- -- -- -- -- 69 -- -- -- -- -- --
     70: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

I observed no ill effects after scanning the bus, but YMMV.

Using the bus is probably not a good idea if the SMM code is really using
it, and so it might be better if this patch lies in the archives for now.
After I get the BIOS flashing to work I'll look into this.

Best Regards,
Michal Miroslaw
