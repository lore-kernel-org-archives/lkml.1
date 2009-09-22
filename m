Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbZIVSH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbZIVSH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbZIVSH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:07:56 -0400
Received: from poutre.nerim.net ([62.4.16.124]:51775 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755745AbZIVSHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:07:55 -0400
Date: Tue, 22 Sep 2009 20:07:56 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Crash on reading the whole PCI config of PIIX4 SMBus
Message-ID: <20090922200756.245c43b0@hyperion.delvare>
In-Reply-To: <4AB8F142.9090609@nachtwindheim.de>
References: <4AB8F142.9090609@nachtwindheim.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 17:46:10 +0200, Henrik Kretzschmar wrote:
> Hi there,
> 
> at boot time my system (Wincor/Nixdorf Beetle D1) sometimes crashs while loading the i2c-piix4 driver.
> I found out that I can always trigger the crash as root, which one of those:  
> 
> # hexdump -C /proc/bus/pci/00/07.3
> # hexdump -C /sys/bus/pci/devices/0000:00:07.3/config
> # lspci -s 07.3 -xxx
> 
> While initialization the i2c-piix4 driver does two reads to the config space, at 0xd2 and 0xd6,
> in a relative short time. That sometimes triggers the crash,
> but isn't that precise like one of those commands.
> 
> While my investigations I put a printk() between those two reads and had no more crashs
> on module loading. I tested that with a script, doing insmod/rmmod 100 times in a row.
> 
> But printk() can't be the solution, so I tried msleep(1) and udelay(250),
> but with each of these my system crashed.
> The time for the read and one printk() takes ~100 us on my machine,
> so both time values should be more than enough, if time would have been the reason.
> 
> Does someone have an idea what the driver should do between those two reads, to avoid crashing?
> Can somebody with the same device trigger this crash too (greped LKML 2001-2008, found nothing)?

And to answer this question: with the same device (except that it's at
01.3 instead of 07.3 here), none of the 3 above commands crash my
system (kernel 2.6.29.)

-- 
Jean Delvare
