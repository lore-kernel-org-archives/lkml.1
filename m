Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbXHKOBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbXHKOBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 10:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbXHKOA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 10:00:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:63335 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbXHKOAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 10:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZpbkFA6zWR8xdSoFBVHArxyViIWX0xEFig2QEBkU3N87jvpxBkFPb4nblNGjaIsN0Bn2b6UDCpP510DgC3Y9L5c01I7qJc9vhHm7O44mxDU7BfWNqc3QkfnTniYfiUwaGxl1GZTx4LrojeaVL/ctPsoUhuBYTAisJhLMk2oN9Rc=
Message-ID: <3ae72650708110700x7ddf3d57ue9a8875761425f52@mail.gmail.com>
Date: Sat, 11 Aug 2007 16:00:53 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Kristen Carlson Accardi" <kristen.c.accardi@intel.com>
Subject: Re: [patch 0/4] Updated AN patches, now without gendisk
Cc: jeff@garzik.org, James.Bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "David Zeuthen" <david@fubar.dk>
In-Reply-To: <20070808120739.c3097d19.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070808120739.c3097d19.kristen.c.accardi@intel.com>
X-Google-Sender-Auth: cb26bed16492ca2d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:
> Here is an updated set of patches that implement Asynchronous Notification
> support for ATAPI devices.  In this version I no longer export the AN
> capability through genhd, and the uevent is sent by the scsi_device
> instead of gendisk.  I added a generic SCSI device event mechanism so
> that it can be expanded in the future with other types of events.  Please
> let me know what you think.

Does that mean:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8ce7ad7b2d11fae2c3d285a6a0caea9322c0b8fc

will go away?

Then we will need to come up with an idea to propagate that to the
blockdev, it gets a bit nasty for userspace to find out which
blockdevice it should update. It's certainly possible, but just not as
easy as it is now, because userspace just doesn't really care in most
cases what kind of bus device a block device is coming from.

And it would also be nice to plug exactly the same kind of media
change notification for devices which only revalidate at open(). That
way we could unify all the removable media handling into a single code
path. We would just check if AN is supported, and wait for events, or
start polling the device if AN isn't supported. It would be great if
we can get the same events in both cases, so we don't need to keep two
completely different ways to implement this.

Thanks,
Kay
