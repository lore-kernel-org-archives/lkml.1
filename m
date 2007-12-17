Return-Path: <linux-kernel-owner+w=401wt.eu-S1762479AbXLQF33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762479AbXLQF33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 00:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbXLQF3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 00:29:21 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22944 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbXLQF3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 00:29:21 -0500
Message-ID: <47660927.9070002@msgid.tls.msk.ru>
Date: Mon, 17 Dec 2007 08:29:11 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: /sys/block [was: [PATCH 007 of 7] md: Get name for block device in
 sysfs]
References: <20071214171950.1308.patches@notabene>	 <1071214062647.1928@suse.de>	 <3ae72650712150858v14681823td2b0410eb67b1d04@mail.gmail.com>	 <18277.43533.991986.323212@notabene.brown> <1197857414.2585.16.camel@lov.site>
In-Reply-To: <1197857414.2585.16.camel@lov.site>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Mon, 2007-12-17 at 09:43 +1100, Neil Brown wrote:
>> On Saturday December 15, kay.sievers@vrfy.org wrote:
>>> On Dec 14, 2007 7:26 AM, NeilBrown <neilb@suse.de> wrote:
>>>> Given an fd on a block device, returns a string like
>>>>
>>>>         /block/sda/sda1
>>>>
>>>> which can be used to find related information in /sys.
>> ....
>>> As pointed out to when you came up with the idea, we can't do this. A devpath
>>> is a path to the device and will not necessarily start with "/block" for block
>>> devices. It may start with "/devices" and can be much longer than
>>> BDEVNAME_SIZE*2  + 10.
>> When you say "will not necessarily" can I take that to mean that it
>> currently does, but it might (will) change??
> 
> It's in -mm. The devpath for all block devices, like for all other
> devices, will start with /devices/* if !SYSFS_DEPRECATED.

This is the second time I come across this (planned?) change, and for
the second time I can't understand it.

How to distinguish char devices from block devices in sysfs?
Is the only way to read a symlink `subsystem' in the device
directory?

For now, I've a shell code (used heavily in numerous places),
which looks like this:

  function makedev() {
    ...
    case $DEVPATH in
      /block/*) TYPE=b ;;
      *) TYPE=c ;;
    esac
    ...
    mknod /dev/$DEV $TYPE $MAJOR $MINOR
  }

The only external process invocation in there is mknod, all
the rest is done using pure shell constructs.  Is it really
necessary to spawn another process just to read a symlink
now?  It will be almost 2 times slower....

(Sure thing this may be rewritten in C, but using shell it's
MUCH easier to customize if necessary.)

Also, /sys/block/ directory is very easy to use currently, --
unlike other /sys/ stuff which is way too deep and often
placed in unknown/unexpected places (and /sys/class/ and
/sys/bus/ directories are changing all the time).

What's the benefit of moving things from /sys/block/ to
/sys/devices/ ?

Thanks.

/mjt
