Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXBAW1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXBAW1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXBAW1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:27:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44490 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344AbXBAW1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:27:13 -0500
Date: Thu, 1 Feb 2007 14:26:48 -0800
From: Andrew Morton <akpm@osdl.org>
To: TJ <linux@tjworld.net>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Neil Brown <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] filesystem: Disk Errors at boot-time caused by
 probe of partitions
Message-Id: <20070201142648.7d16e4b6.akpm@osdl.org>
In-Reply-To: <1170287439.13764.24.camel@butch.lan.tjworld.net>
References: <1170287439.13764.24.camel@butch.lan.tjworld.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 23:50:39 +0000
TJ <linux@tjworld.net> wrote:

> +		if (!insane && is_extended_partition(p)) { /* check the extended partition */
> +			data = read_dev_sector(bdev, START_SECT(p)*sector_size, &sect); /* fetch sector from cache */
> +			if (data) {
> +				if (msdos_magic_present(data + 510)) { /* check for signature */
> +					ext = (struct partition *) (data + 0x1be);
> +					ret = check_sane_values(ext, bdev); /* recursive call */

The recursion is a concern.  Is there any way in which a cunningly-crafted
device can cause sufficiently deep recursion to crash the kernel?

Also, from reading the replies I think we'd like to see some more
explanation of why this is necessary: are you really really sure that those
disks were incorrectly handling illegal sector numbers?  Knowing the IBM
and Maxtor model numbers might be useful.

I assume you were using a driver in drivers/ide/?  Perhaps this is really
an IDE-layer bug.
