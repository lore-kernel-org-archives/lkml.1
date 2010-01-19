Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714Ab0ASI6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0ASI6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583Ab0ASI6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:58:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:60192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571Ab0ASI6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:58:51 -0500
Message-ID: <4B557417.6030806@kernel.org>
Date: Tue, 19 Jan 2010 17:57:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Robert Hancock <hancockrwd@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       Seth Heasley <seth.heasley@intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: JMB363 false hotplug detections
References: <51f3faa71001161010m47d885cfx5d17486016476ed5@mail.gmail.com>	<4B5270D6.6030005@kernel.org> <m3eilocwmz.fsf@intrepid.localdomain>
In-Reply-To: <m3eilocwmz.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Jan 2010 08:58:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/18/2010 05:19 AM, Krzysztof Halasa wrote:
> http://lkml.org/lkml/2010/1/13/342
> http://lkml.org/lkml/2010/1/15/245

Definitely looks like electrical problem to me.  The controller is
repeatedly reporting spurious hotplug events and the problem is not
universal to the controller either.  I've played with several
different jmb363s and they all worked just fine.  It would be
interesting to see whether the problem is reproducible on different
boards of the same model.

> BTW setting the JMB363 mode in BIOS setup from IDE to AHCI or RAID
> (thus enabling JMB363 BIOS) changes nothing.

That's expected.  The controller is always put into ahci mode during
intialization regardless of the mode programmed by the bios.

> The only weird thing is that some time ago the problems weren't there.
> It could be genuine hardware problem. I have full kernel logs. Sometimes
> the same kernel (build) is "good" at one time and "bad" at another.
> 
> I had booted the board (with JMB363 and the driver enabled) 57 times.
> Out of these, there was no problems 16 times (date-hrs-result):
...
> There are no significant kernel log differences between *good and *bad
> (excluding the AHCI messages). Sometimes the exceptions were sporadic,
> like in 09-01-12:53-bad case:
> 
> Sep  1 12:53:38 Machine booted
> Sep  1 13:02:33 ata8: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
> Sep  1 13:02:33 ata8: irq_stat 0x00000040, connection status changed
> Sep  1 13:02:33 ata8: SError: { CommWake DevExch }
> Sep  1 13:02:33 ata8: hard resetting link
> Sep  1 13:02:34 ata8: SATA link down (SStatus 0 SControl 300)
> Sep  1 13:02:34 ata8: EH complete
> Sep  1 15:47:12 Machine rebooted
> 
> Perhaps I should really check these resistors around the JMB363 chip,
> and maybe using a vacuum cleaner is a good idea? I think I will do.
> 
> It's certaing there was nothing connected do JMB363 SATA. I don't know
> BIOS versions and CMOS (BIOS) configs.

They don't matter.  Once the OS takes over, the controller is forced
into multi function ahci mode and the kernel version wouldn't have any
effect on it either.  That part of code hasn't changed for years now.
So, yeah, looks like a genuine hardware problem to me.

Thanks.

-- 
tejun
