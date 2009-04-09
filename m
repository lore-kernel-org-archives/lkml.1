Return-Path: <linux-kernel-owner+w=401wt.eu-S1764288AbZDISMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764288AbZDISMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbZDISM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:12:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:34123 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbZDISMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:12:25 -0400
MIME-Version: 1.0
In-Reply-To: <1239300433.19984.270.camel@grinch>
References: <20090407180411.GA4324@beardog.cca.cpqcorp.net> 
	<20090408061901.GN5178@kernel.dk> <ac3eb2510904080526h36673aa7qb5d530df33a60104@mail.gmail.com> 
	<1239258160.19984.217.camel@grinch> <ac3eb2510904090719n730dededp54b25390a9087a79@mail.gmail.com> 
	<1239296221.19984.218.camel@grinch> <ac3eb2510904091005q13e5b5a1j3907de22ad3df70c@mail.gmail.com> 
	<1239300433.19984.270.camel@grinch>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 9 Apr 2009 11:12:09 -0700
Message-ID: <ac3eb2510904091112p4d4cc491o703ead8b93d0b45f@mail.gmail.com>
Subject: Re: [PATCH 1/1] cciss: resubmit export uid, model, vendor, rev to 
	sysfs
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: ens Axboe <jens.axboe@oracle.com>,
       "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LKML-SCSI <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 9, 2009 at 11:07, Andrew Patterson <andrew.patterson@hp.com> wrote:
> On Thu, 2009-04-09 at 10:05 -0700, Kay Sievers wrote:

>> The block device needs a parent, please assign the cciss bus device.
>> It's the driverfs_dev in the genhd struct.
>>
>
> This is already done in cciss_add_disk():
>
>        disk->fops = &cciss_fops;
>        disk->private_data = &h->drv[drv_index];
>        disk->driverfs_dev = &h->drv[drv_index].dev;
>
> I think my problem is I was assigning cciss_bus_type to the controller,
> not the block device. I have fixed that.

> # /sbin/udevadm info --attribute-walk "--path=/block/cciss!c0d0"

>  looking at parent device
> '/devices/pci0000:4f/0000:4f:00.0/0000:50:00.0/0000:51:04.0/0000:8b:00.0/cciss0':
>    KERNELS=="cciss0"
>    SUBSYSTEMS==""

This device also needs the cciss bus_type assigned, so the subsystem
becomes cciss, and it also shows up in /sys/bus/cciss/devices/.

Other than that, the sysfs hierarchy looks fine.

Thanks,
Kay
