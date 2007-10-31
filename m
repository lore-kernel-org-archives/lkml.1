Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbXJaLF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbXJaLF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbXJaLFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:05:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37354 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbXJaLFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:05:18 -0400
Date: Wed, 31 Oct 2007 12:05:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: iwl3945 in 2.6.24-rc1 dies under load
Message-ID: <20071031110511.GA2194@elf.ucw.cz>
References: <20071031005202.GA1534@elf.ucw.cz> <1193792098.9704.16.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193792098.9704.16.camel@debian.sh.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-10-31 08:54:58, Zhu Yi wrote:
> 
> On Wed, 2007-10-31 at 01:52 +0100, Pavel Machek wrote:
> > tcpspray -n 1 -b 10000000 10.0.0.2
> > 
> > Oct 31 01:42:56 amd kernel: iwl3945: Microcode SW error detected.
> > Restarting 0x82000008.
> > Oct 31 01:42:56 amd kernel: iwl3945: Error Reply type 0x00000005 cmd
> > REPLY_TX (0x1C) seq 0x02C7 ser 0x0000004B
> > Oct 31 01:42:58 amd kernel: iwl3945: Can't stop Rx DMA.
> 
> Please attach the dmesg with module param debug=0x43fff (make sure
> CONFIG_IWLWIFI_DEBUG is selected). This will dump the firmware event log
> for debug.

I addded debug=0x43fff to command line, and it produces _incredible_
ammount of syslog noise... and the error goes away, probably due to
changed timing :-(. I can now reliably transfer huge files:

root@amd:/data/l/linux/drivers/net/wireless/iwlwifi# tcpspray -n 1 -b
10000000 hobit

Transmitted 10000000 bytes in 12.388257 seconds (788.297 kbytes/s)
root@amd:/data/l/linux/drivers/net/wireless/iwlwifi# tcpspray -n 1 -b
100000000 hobit

Transmitted 100000000 bytes in 123.807061 seconds (788.778 kbytes/s)
root@amd:/data/l/linux/drivers/net/wireless/iwlwifi# tcpspray -n 1 -b
1000000000 hobit

Transmitted 1000000000 bytes in 1265.784625 seconds (771.508 kbytes/s)
root@amd:/data/l/linux/drivers/net/wireless/iwlwifi#

rmmod/insmod w/o debug=, and ...huh... problem is _still_ away?!


								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
