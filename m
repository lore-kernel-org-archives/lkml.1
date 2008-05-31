Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYEaHIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYEaHIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 03:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYEaHIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 03:08:40 -0400
Received: from gw.goop.org ([64.81.55.164]:45531 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbYEaHIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 03:08:39 -0400
Message-ID: <4840F951.1090908@goop.org>
Date: Sat, 31 May 2008 08:08:01 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2 of 5] xn/blkfront: Add the CDROM_GET_CAPABILITY ioctl
 to	blkfront
References: <84dc2b8e1677cbc6f5ec.1212192092@localhost> <4840B077.70705@pobox.com>
In-Reply-To: <4840B077.70705@pobox.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jeremy Fitzhardinge wrote:
>> +    case CDROM_GET_CAPABILITY: {
>> +        struct gendisk *gd = info->gd;
>> +        if (gd->flags & GENHD_FL_CD)
>> +            return 0;
>> +        return -EINVAL;
>> +    }
>
>
> Surely you can come up with a better implementation than this?  It's 
> just a bitmask returned to userspace...

Unfortunately the Xen block driver interface doesn't seem to pass 
through any capabilities of the underlying CDROM device, so there's not 
much to return.  I suspect this is primarily a hack to make installers a 
bit happier installing off a Xen VBD rather than because real programs 
will use this in earnest.

    J
