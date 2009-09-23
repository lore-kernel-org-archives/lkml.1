Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbZIWPt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbZIWPt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZIWPt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:49:28 -0400
Received: from server78.greatnet.de ([83.133.96.102]:45685 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZIWPt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:49:27 -0400
Message-ID: <4ABA4382.1000707@nachtwindheim.de>
Date: Wed, 23 Sep 2009 17:49:22 +0200
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Wolfram Sang <w.sang@pengutronix.de>, linux-pci@vger.kernel.org,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Crash on reading the whole PCI config of PIIX4 SMBus
References: <4AB8F142.9090609@nachtwindheim.de>	<20090922231839.GA20656@pengutronix.de>	<4ABA1B9C.9070302@nachtwindheim.de>	<20090923153531.1642b77d@hyperion.delvare>	<4ABA2CA1.8070806@nachtwindheim.de> <20090923161518.5cb29107@hyperion.delvare>
In-Reply-To: <20090923161518.5cb29107@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare schrieb:

> That's right, but it doesn't explain why i2c-piix4 crashes in the first
> place, not why merely loading it causes further lspci -xxx to crash
> when they did not beforehand. I admit I am totally clueless.
>   
Sorry, I expressed myself a bit unclear.

With _worked_ I meant the system crashed (thats what killer commands are for).

lspci -xxx (and co) bring this system down in every case, module loaded or not.
Obvious this crash occuress when reading the config space in short periods.

lspci (or better proc-fs and sys-fs) do that, and i2c-piix4 does it sometimes.

Looking at read() of drivers/pci/proc.c i had the idea of stalking the critical area with:

#!/bin/sh
for i in `seq 100`; do
 dd if=/proc/bus/pci/00/07.3 of=/dev/null bs=1 count=n 2>/dev/null;
done


I got no crashes with n == 192, but with n == 193 theres no reaction from the system.

Maybe it's interesting, that (all the time after crashes) the screen
(in my case the console with a blinking cursor) can still be seen.
But no reaction on keyboard hits.

Also strange is, that the device works well IF those two read accesses have not done the crash.
I'll test tomorrow without the second read access, just to know if it works.





