Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZAJGae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZAJGae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 01:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZAJGa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 01:30:26 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:51397 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZAJGa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 01:30:26 -0500
MIME-Version: 1.0
In-Reply-To: <adad4evoeu9.fsf@cisco.com>
References: <adaljtjog90.fsf@cisco.com> <adad4evoeu9.fsf@cisco.com>
Date: Sat, 10 Jan 2009 07:30:24 +0100
Message-ID: <ac3eb2510901092230i5f1a37c6s8e7ef20cfaf67dc6@mail.gmail.com>
Subject: Re: [PATCH] driver core: Convert '/' to '!' in dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 07:27, Roland Dreier <rdreier@cisco.com> wrote:
> Commit 3ada8b7e ("block: struct device - replace bus_id with dev_name(),
> dev_set_name()") deleted the code in register_disk() that changed a '/'
> to a '!' in the device name when registering a disk, but dev_set_name()
> does not perform this conversion.
>
> This leads to amusing problems with disks that have '/' in their names:
> for example a failure to boot with the root partition on a cciss device,
> even though the kernel says it knows about the root device:
>
>    VFS: Cannot open root device "cciss/c0d0p6" or unknown-block(0,0)
>    Please append a correct "root=" boot option; here are the available partitions:
>    6800        71652960 cciss/c0d0 driver: cciss
>      6802               1 cciss/c0d0p2
>      6805         2931831 cciss/c0d0p5
>      6806        34354908 cciss/c0d0p6
>    6810        71652960 cciss/c0d1 driver: cciss
>
> Fix this by adding code to change '/' to '!' in dev_set_name() to handle
> this until dev_set_name() is converted to use kobject_set_name().

Great! Thanks a lot for fixing this,
Kay
