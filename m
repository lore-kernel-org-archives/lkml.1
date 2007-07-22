Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbXGVQjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbXGVQjG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 12:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXGVQiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 12:38:54 -0400
Received: from mail.trixing.net ([87.230.125.58]:33516 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064AbXGVQix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 12:38:53 -0400
Message-ID: <46A3882C.7040709@l4x.org>
Date: Sun, 22 Jul 2007 18:39:08 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070329 Thunderbird/1.5.0.10 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: linux-kernel@vger.kernel.org
References: <20070720091707.GA26717@linux-sh.org> <46A0C199.8050401@l4x.org> <20070720151543.GA28274@linux-sh.org> <46A33D03.3000105@l4x.org> <20070722114253.GA11519@linux-sh.org>
In-Reply-To: <20070722114253.GA11519@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.195
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [GIT PULL] Trivial sh64 updates for 2.6.23-rc1
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Sun, Jul 22, 2007 at 01:18:27PM +0200, Jan Dittmer wrote:
>> Paul Mundt wrote:
>>> On Fri, Jul 20, 2007 at 04:07:21PM +0200, Jan Dittmer wrote:
>>>> Paul Mundt wrote:
>>>> Tangential question. Which is the currently recommended cross toolchain
>>>> for sh64? With "gcc 3.2 20020529", "binutils 020306 20030206" (some
>>>> binary toolchain from ~2 years ago somewhere off the web) I get [1]
>> <error snipped>
>>
>>>> gcc 3.4.x, 4.0.x, 4.1.x don't build for me from source
>>>> (target -superh-linux-gnu, binutils 2.15.x or 2.17.x).
>>> I've been using sh64-linux targetted toolchains created from the gentoo
>>> crossdev, which works fine with stock versions. I can send you a tarball
>>> of the toolchain off-list if you like.
>> Binutils, gcc versions would be fine to. Meanwhile I got binutils
>> 2.17.50.0.17.20070615 and gcc 4.1.3 20070704 (prerelease) to compile
>> (supplying it with uclibc- and lk-headers). But compiling 2.6.22-git17
>> now fails with
>>
>>   CC      drivers/video/cfbimgblt.o
>>   CC      drivers/video/fb_defio.o
>>   LD      drivers/video/built-in.o
>>   LD      drivers/built-in.o
>> sh64-linux-ld: sh3 architecture of input file `drivers/media/built-in.o'
>> is incompatible with sh5 output
>> sh64-linux-ld: sh3 architecture of input file `drivers/i2c/built-in.o'
>> is incompatible with sh5 output
>> make[2]: *** [drivers/built-in.o] Error 1
>> make[1]: *** [drivers] Error 2
>> make: *** [_all] Error 2
>>
>> Known?
>>
> It's known that empty objects require explicit tuning for the ABI,
> however, this has never been anything that was fatal. If you flip
> something on within each of those subsystems, does the error go away?

Yes, thanks this fixes it. Would you accept a patch to modify the
defconfig so that it builds by default? Would be most useful for
my pet project (http://l4x.org/k/). A fixed toolchain would of course
also be nice.

Thanks,

Jan
