Return-Path: <linux-kernel-owner+w=401wt.eu-S1422659AbXBUQWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422659AbXBUQWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422658AbXBUQWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:22:31 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:4185 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422640AbXBUQWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:22:30 -0500
X-Greylist: delayed 4494 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Feb 2007 11:22:30 EST
Date: Wed, 21 Feb 2007 17:22:07 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070221172207.d469b17d.khali@linux-fr.org>
In-Reply-To: <45DC6D3B.80500@redhat.com>
References: <45D5EA88.7090300@redhat.com>
	<45D6DDCE.5050803@assembler.cz>
	<45D7461A.2040808@redhat.com>
	<45D8D6AE.3000204@assembler.cz>
	<45DB0EEA.2010205@redhat.com>
	<20070221155444.99386b98.khali@linux-fr.org>
	<45DC6D3B.80500@redhat.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007 11:03:07 -0500, Chuck Ebbert wrote:
> Jean Delvare wrote:
> > Can you try to load the i2c-dev driver, then run the following commands
> > and report the results:
> > $ i2cdetect -l
> > For each bus listed:
> > $ i2cdetect N
> 
> FWIW it's really an ATIIXP chipset, but supposedly PIIX4 compatible:
> 
> # i2cdetect -l
> i2c-0   smbus           SMBus PIIX4 adapter at 8400             Non-I2C SMBus adapter

No i2c_ec. Maybe your distribution is loading it by default for
everyone then.

Either way, it means you can forget right away about sbs, if i2c_ec
didn't register a device, sbs cannot be used.

> # i2cdetect 0
> WARNING! This program can confuse your I2C bus, cause data loss and worse!
> I will probe file /dev/i2c-0.
> I will probe address range 0x03-0x77.
> Continue? [Y/n] y
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          XX XX XX XX XX XX XX XX XX XX XX XX XX
> 10: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX
> 20: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX
> 30: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX
> 40: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX
> 50: 50 51 XX XX XX XX XX XX XX XX XX XX XX XX XX XX
> 60: XX XX XX XX XX XX XX XX XX 69 XX XX XX XX XX XX
> 70: XX XX XX XX XX XX XX XX

Only a couple EEPROMs and a clock chip on your SMBus, it's very
unlikely that ACPI accesses this at all. So I'd be surprised that
i2c-piix4 is causing any trouble.

This leaves asus_acpi as the only candidate? Better unload _all_ the
drivers you consider as suspects, and see if it changes anything. I
guess not.

-- 
Jean Delvare
