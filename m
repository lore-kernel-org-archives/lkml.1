Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYJ0Q0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYJ0Q0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYJ0Q0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:26:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:46113 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYJ0Q0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:26:18 -0400
Message-ID: <ac3eb2510810270926m2e47bdb2ra8ff38282a8a9ed0@mail.gmail.com>
Date: Mon, 27 Oct 2008 17:26:17 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: usb hdd problems with 2.6.27.2
Cc: dgilbert@interlog.com, "Alan Stern" <stern@rowland.harvard.edu>,
       "Luciano Rocha" <luciano@eurotux.com>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       "USB list" <linux-usb@vger.kernel.org>,
       "SCSI development list" <linux-scsi@vger.kernel.org>
In-Reply-To: <4905D986.6050001@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0810271007030.4059-100000@iolanthe.rowland.org>
	 <4905D68D.7030407@interlog.com> <4905D986.6050001@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 16:08, Boaz Harrosh <bharrosh@panasas.com> wrote:
> Douglas Gilbert wrote:
>>
>> Since the READ CAPACITY "off by one" error is so common,
>> perhaps drivers such as usb-storage could have a hook to
>> do a pseudo READ CAPACITY. Then if the capacity value
>> looked odd (in both senses) the driver could do an IO to
>> the suspect block and if that failed decrement the capacity
>> value passed back to the mid level.
>> Put another way, why don't these defective devices trip up
>> another OS?
>>
>
> Window$ never reads the last sector unless it is actually written
> to. I had such a device it got stuck when I wrote to the
> last sector.
>
>> BTW a single disk in RAID 0 (seen on a HP E200 controller)
>> has a shortened capacity value seen in the midlevel on the
>> corresponding logical drive. That missing chunk is probably
>> where the RAID controller puts its control information.
>> Anyway, playing with the capacity value returned by READ
>> CAPACITY certainly has a precedent.
>>
>>> Later on the system tries to read the contents of what it thinks is the
>>> last sector:
>>
>> I know that happens but it seems strange that upper levels
>> are reading a block that has never been written to. Read ahead?
>>
>
> That would be udev or hald, I can't remember which. It is a special Linux
> fixture. ;)

It's vol_id from udev. To auto-detect raid setups, LVM, MD metadata, ...

Such devices carry their magic sequence at the "end" of the device,
usually the last sector or a few sectors before the last sector. The
"last" sector is obviously determined by the capacity the device
reports.

There is no way around looking at all block devices' last sector on a
Linux box, as long as people expect auto-setup, auto-mounting,
anything that is not put in /etc/fstab to work, as long as any "meta
device" format puts a magic number at the end of the device.

Kay
