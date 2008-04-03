Return-Path: <linux-kernel-owner+w=401wt.eu-S932145AbYDCHNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbYDCHNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761453AbYDCHMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:12:46 -0400
Received: from smtp.nokia.com ([192.100.122.230]:25091 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761388AbYDCHMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:12:45 -0400
Message-ID: <47F48244.9000500@yandex.ru>
Date: Thu, 03 Apr 2008 10:07:48 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Matthieu CASTET <castet.matthieu@free.fr>
CC: linux-kernel@vger.kernel.org, Hunter Adrian <ext-Adrian.Hunter@nokia.com>
Subject: Re: [RFC PATCH] UBIFS - new flash file system
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <loom.20080401T204425-749@post.gmane.org>
In-Reply-To: <loom.20080401T204425-749@post.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Apr 2008 07:12:07.0477 (UTC) FILETIME=[06DC8650:01C8955A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthieu,

Not sure why me/Adrian were not in CC, but it is difficult to notice 
e-mails in this case.

Matthieu CASTET wrote:
>> UBIFS is stable and very close to be production ready. It was
>> tested on OLPC and N810. The development was done on flash simulator
>> on a 2-way x86 machine. However, UBIFS needs a good review.
> Did you have a chance of testing it with various real flash : old small page
> nand flash, very big large page NAND (4GB), ...

Most of the development was done on nandsim. We tested 512/2048 NAND page
sizes on nandsim. We also tried mtdram which emulates NOR flash as well,
UBIFS worked fine.

Vs. real hardware, unfortunately we have only tried Nokia N8100 which has
256MiB internal SLC NAND flash and OLPC which has 1GiB internal SLC NAND flash.
It would be nice to try on more hardware, but we do not have it available.

Nevertheless, we expect it to work fine on different NAND page sizes as
long as they are power of 2.

> May be you could update your benchmark :
> http://osl.sed.hu/wiki/ubifs/index.php/Mount_results doesn't give super result :
> 1 second mount time on a 64 MB flash with 517.73 BogoMIPS CPU.
> What will be the result for a 4GB flash ? 64 seconds ?

Not sure about that measurement. As far as I know the guys from Szeged have some
board with very slow flash I/O which gave them these results.

But it included both UBI initialization and UBIFS mount time. The latter part
is always quick. The former may be slow if I/O speed is slow. Depending on
hardware, for 4GB I would expect 4-10 sec UBI initialization time. Not perfect.
UBI needs improvements to work with large flashes. We have few ideas for
improving current UBI. But for dramatical to developing UBI2 would be needed.

Here you may find some figures I observed:
http://www.linux-mtd.infradead.org/doc/ubi.html#L_scalability

> Did you do very intensive and long test where you can see bad block appearing on
> the flash ?

Yes, we tried. But we were unable to wear out Samsung OneNAND. Surprisingly, it
survived much more erase cycles that the manual declares. It is SLC. We need an
MLC flash to do this, which we do not have, unfortunately. 

The way we made sure wear-leveling is OK - we improved nandsim to report wear
information (see rptwear nandsim module option).

> Speaking of big nand, is UBI/UBI-FS free of 2GB/4GB limit ?
Yes, I believe so. All the addressing is done in eraseblock number/offset within
the eraseblock units.

>> UBIFS is quite complex because
> Is it possible to create small and fast code for read only support in 
> bootloader ?
Yeah, read-only implementation should not be very complex, but it would anyway
be much more complex than the one for JFFS2. It might be easier to have /boot
partition as JFFS2 I guess.

I had a wild idea of implanting boot-loader support into UBI/UBIFS. That would
mean to store additional information about location of specific files in a
dedicated place on flash. Just for few files, like the ones in /boot. Not sure
how much sense does it make, though.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
