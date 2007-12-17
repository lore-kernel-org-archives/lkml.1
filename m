Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbXLQIdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbXLQIdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 03:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbXLQIcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 03:32:52 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22476 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334AbXLQIcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 03:32:52 -0500
Message-ID: <47663431.8000603@msgid.tls.msk.ru>
Date: Mon, 17 Dec 2007 11:32:49 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: /sys/block [was: [PATCH 007 of 7] md: Get name for block	device
 in sysfs]
References: <20071214171950.1308.patches@notabene>	 <1071214062647.1928@suse.de>	 <3ae72650712150858v14681823td2b0410eb67b1d04@mail.gmail.com>	 <18277.43533.991986.323212@notabene.brown>	 <1197857414.2585.16.camel@lov.site>  <47660927.9070002@msgid.tls.msk.ru> <1197879879.2585.28.camel@lov.site>
In-Reply-To: <1197879879.2585.28.camel@lov.site>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Mon, 2007-12-17 at 08:29 +0300, Michael Tokarev wrote:
[]
>> How to distinguish char devices from block devices in sysfs?
>> Is the only way to read a symlink `subsystem' in the device
>> directory?
> 
> By its subsystem value (block), from the symlink, from the environment,
> or from $1.

Environment and $1 comes as arguments for hotplug helper, not
when scanning /sys/.

>> For now, I've a shell code (used heavily in numerous places),
>> which looks like this:
>>
>>   function makedev() {
>>     ...
>>     case $DEVPATH in
>>       /block/*) TYPE=b ;;
>>       *) TYPE=c ;;
>>     esac
>>     ...
>>     mknod /dev/$DEV $TYPE $MAJOR $MINOR
>>   }
>>
>> The only external process invocation in there is mknod, all
>> the rest is done using pure shell constructs.  Is it really
>> necessary to spawn another process just to read a symlink
>> now?  It will be almost 2 times slower....
> 
> No need.

It seems there IS a need now ;)

Thanks for the clarification.

/mjt
