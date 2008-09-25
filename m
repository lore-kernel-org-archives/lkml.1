Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbYIYVNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbYIYVNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYIYVNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:13:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39509 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYIYVNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:13:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48DBFEEF.8090109@s5r6.in-berlin.de>
Date: Thu, 25 Sep 2008 23:13:19 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Tino Keitel <tino.keitel@gmx.de>
CC: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Differend udev names with different kernels
References: <20080924200127.GA2452@dose.home.local> <3ae72650809242012r7d144a64l35777f2a7bacbaa0@mail.gmail.com> <48DB1CC4.2040004@s5r6.in-berlin.de> <20080925054708.GA18645@dose.home.local>
In-Reply-To: <20080925054708.GA18645@dose.home.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel wrote:

Tino, when you reply on LKML, please keep _all_ responders in a thread 
in the Cc list.  I for one am not subscribed to linux-hotplug, and I may 
easily miss a response on LKML with its hundreds of messages per day if 
I am not Cc'd.  Thanks.

> On Thu, Sep 25, 2008 at 07:08:20 +0200, Stefan Richter wrote:
>> Kay Sievers wrote:
>>> On Wed, Sep 24, 2008 at 13:01, Tino Keitel <tino.keitel@gmx.de> wrote:
>>>> what's the intention of /dev/disk/by-id/?
>>>>
>>>> My firewire hard disk seems to have different names with different
>>>> kernels.
>>>>
>>>> With 2.6.26.3, it's name is
>>>> /dev/disk/by-id/ieee1394-0030e001e0006585:00043c:0000.
>>>>
>>>> With someting after 2.6.27-rc7, merged with Arjan's fastboot branch,
>>>> the disk has the same name.
>> Then this is a regression of the fastboot patch or whatever.
> 
> It has the same name with 2.6.26.3 and with 2.6.27-rc7-something with
> fastboot merged. So why would this be a regression? The different name
> (scsi-...) happended with a vanilla 2.6.27-rc7.

I misunderstood.  (Comprehension difficulties at 0700 AM.)

It is of course intended that FireWire disks get the 
/dev/disk/by-id/ieee1394-* link.  Only this one is reliably unique.  The 
/dev/disk/scsi-* link, which I presume is generated from SCSI INQUIRY 
data, is alas often not unique if it comes from FireWire disks.

> Initially, my intention was to find a unique name for the hard disk,
> that stays even if the disk is changed from Firewire to USB. However,
> this doesn't seem to be possible with a default udev.

This is only possible with udev scripts that are customized by the user 
for each individual disk.

Dual FireWire + USB enclosures use entirely separate firmwares for their 
FireWire and USB interfaces because the protocols are so different. 
Hence there are also no unique device properties of the FireWire and USB 
side that can be generally recognized as belonging to the identical device.

An alternative though would be filesystem labels or filesystem UUIDs, if 
unique and persistent identifiers at the filesystem level rather than at 
the block device level are sufficient for your needs.
-- 
Stefan Richter
-=====-==--- =--= ==--=
http://arcgraph.de/sr/
