Return-Path: <linux-kernel-owner+w=401wt.eu-S1751556AbZHSHW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbZHSHW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZHSHW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:22:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42727 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbZHSHW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:22:26 -0400
Date: Wed, 19 Aug 2009 09:21:00 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dirk Behme <dirk.behme@googlemail.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
Message-ID: <20090819072100.GA23444@pengutronix.de>
References: <20090814170228.GM13320@pengutronix.de> <20090818140605.GB9943@pengutronix.de> <4A8AC95E.2040907@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8AC95E.2040907@googlemail.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 09:15:45 up 13 days, 18:34, 17 users,  load average: 1.33, 1.16,
	1.09
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 05:31:42PM +0200, Dirk Behme wrote:
> Sascha Hauer wrote:
>> On Fri, Aug 14, 2009 at 07:02:28PM +0200, Robert Schwebel wrote:
>>> Hi,
>>>
>>> On Thu, Aug 13, 2009 at 05:33:26PM +0200, Robert Schwebel wrote:
>>>> On Thu, Aug 13, 2009 at 08:28:26AM -0700, Arjan van de Ven wrote:
>>>>>> That's bad :-) So there is no room for improvement any more in our
>>>>>> ARM boot sequences ...
>>>>> on x86 we're doing pretty well ;-)
>>>> On i.MX27 (400 MHz ARM926EJ-S) we currently need 7 s, measured from
>>>> power-on through the kernel up to "starting init". This is with
>>>>
>>>> - no delay in u-boot-v2
>>>> - rootfs on NAND (UBIFS)
>>>> - quiet
>>>> - precalculated loops-per-jiffy
>>>> - zImage kernel instead of uImage
>>> Here's a little video of our demo system booting:
>>> http://www.youtube.com/watch?v=xDbUnNsj0cI
>>>
>>> As you can see there, it needs about 15 s from the release of the reset button
>>> up to the moment where the application shows it's Qt 4.5.2 based GUI (which is
>>> when we fade over from the initial framebuffer to the final one, in order to
>>> hide the qt application startup noise).
>>>
>>> And below is the boot log (after turning "quiet" off again). The numbers are
>>> the timestamp and the delta to the last timestamp, measured on the controlling
>>> PC by looking at the serial console output. The ptx_ts script starts when the
>>> regexp was found, so the numbers start basically in the moment when u-boot-v2
>>> has initialized the system up to the point where we can see something.
>>>
>>> Result:
>>>
>>> - 2.4 s up from u-boot to the end of "Uncompressing Linux"
>>> - 300 ms until ubifs initialization starts
>>> - 3.7 s for ubifs, until "mounted root"
>>>
>>> So we basically have 7 s for the kernel. The rest is userspace, which hasn't
>>> seen much optimization yet, other than trying to start the GUI application as
>>> early as possible, while doing all other init stuff in parallel. Adding "quiet"
>>> brings us another 300 ms.
>>>
>>> That's factor 70 away from the 110 ms boot time Tim has talked about some days
>>> ago (and he measured on an ARM cpu which had almost half the speed of this
>>> one), and I'm wondering what we can do to improve the boot time.
>>>
>>> Robert
>>>
>>> rsc@thebe:~$ microcom | ptx_ts "U-Boot 2.0.0-rc9"
>>> [ 13.522625] <  0.043189>
>>> [ 13.546627] <  0.024002> OSELAS(R)-phyCORE-trunk (PTXdist-1.99.svn/2009-08-06T08:37:25+0200)
>>> [ 13.558613] <  0.011986>
>>> [ 13.690643] <  0.132030>        _            ____ ___  ____  _____
>>> [ 13.690731] <  0.000088>  _ __ | |__  _   _ / ___/ _ \|  _ \| ____|
>>> [ 13.698595] <  0.007864> | '_ \| '_ \| | | | |  | | | | |_) |  _|
>>> [ 13.698654] <  0.000059> | |_) | | | | |_| | |__| |_| |  _ <| |___
>>> [ 13.702581] <  0.003927> | .__/|_| |_|\__, |\____\___/|_| \_\_____|
>>> [ 13.706573] <  0.003992> |_|          |___/
>>> [ 13.706622] <  0.000049>
>>> [ 13.725043] <  0.018421>
>>> [ 14.742608] <  1.017565>
>>
>> I made some changes suggested in this thread:
>>
>> - enable MMU in the bootloader
>> - use assembler optimized memcpy/memset in the bootloader
>> - start an uncompressed image
>> - disable IP autoconfiguration in the Kernel
>> - use lpj= command line parameter
>> - use static device nodes instead of udev
>> - skip some init scripts
>> - made the kernel smaller (I do not have both configs handy, so I do not
>>   know what exactly I changed)
>>
>> Already looks much better:
>>
>> [  0.000005] <  0.000005> U-Boot 2.0.0-rc10-00241-g3f10fe9-dirty (Aug 18 2009 - 13:29:25)
>> [  0.000026] <  0.000021>
>> [  0.000041] <  0.000015> Board: Phytec phyCORE-i.MX27
>> [  0.000054] <  0.000013> cfi_probe: cfi_flash base: 0xc0000000 size: 0x02000000
>> [  0.000067] <  0.000013> NAND device: Manufacturer ID: 0x20, Chip ID: 0x36 (ST Micro NAND 64MiB 1,8V 8-bit)
>> [  0.000080] <  0.000013> imxfb@imxfb0: i.MX Framebuffer driver
>> [  0.000092] <  0.000012> dma_alloc: 0xa6f56e40 0x10000000
>> [  0.000105] <  0.000013> dma_alloc: 0xa6f57088 0x10000000
>> [  0.000118] <  0.000013> dev_protect: currently broken
>> [  0.000129] <  0.000011> Using environment in NOR Flash
>> [  0.000141] <  0.000012> initialising PLLs
>> [  0.128972] <  0.128831> Malloc space: 0xa6f00000 -> 0xa7f00000 (size 16 MB)
>> [  0.128995] <  0.000023> Stack space : 0xa6ef8000 -> 0xa6f00000 (size 32 kB)
>> [  0.129008] <  0.000013> running /env/bin/init...
>> [  0.224963] <  0.095955>
>> [  0.224984] <  0.000021> Hit any key to stop autoboot:  0
>> [  0.224999] <  0.000015> copy
>> [  0.592964] <  0.367965> done
>> [  0.652010] <  0.059046> Linux version 2.6.31-rc4-00004-g05786f8-dirty (sha@octopus) (gcc version 4.3.2 (OSELAS.Toolchain-1.99.3) ) #206 PREEMPT Tue Aug 18 14:08:51 CEST 2009
>
> So, this are ~0.6 s in boot loader and kernel copy until kernel starts, 
> correct?

Yes, correct. The copying itself is between 'copy' and 'done' so it
takes about 0.4s.

>
> What's the size of the uncompressed kernel copied here?

The image is about 2.8MB, but I copied the whole partition of 3MB
because with raw images you can't detect the image size.

>
> Btw.: I tried to summarize some hints given in this thread in
>
> http://elinux.org/Boot_Time#Boot_time_check_list

Nice work!

Regards
  Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
