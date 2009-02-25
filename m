Return-Path: <linux-kernel-owner+w=401wt.eu-S1763779AbZBYXvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763779AbZBYXvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763635AbZBYXvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:51:18 -0500
Received: from mail.lang.hm ([64.81.33.126]:34503 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763483AbZBYXvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:51:16 -0500
Date: Wed, 25 Feb 2009 15:49:58 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
In-Reply-To: <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
Message-ID: <alpine.DEB.1.10.0902251549180.26625@asgard.lang.hm>
References: <1235600698-6446-1-git-send-email-matthew@wil.cx> <49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009, Martin K. Petersen wrote:

>>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:
>
>>> The two patches following this add support for drives which have
>>> sector sizes other than 512 bytes.  I haven't been able to test this
>>> as I don't have the hardware.
>
> hpa> What sector size do we report to user space for this?  I'm asking
> hpa> because logical sector size is visible in most partition formats.
>
> There are several flavors of drives we have to deal with:
>
> 512-byte logical / 512-byte hardware (current)
> 512-byte logical / 4096-byte hardware (ATA, doing read-modify-write)
> 4096-byte logical / 4096-byte hardware (SCSI initially, ATA later)

add to this good support for SSDs

?? logical / 128K hardware

or similar.

David Lang

> Because of 63-sector legacy problems a bunch of ATA vendors will
> initially ship 512/4096 drives that are not naturally aligned.
> I.e. logical sector 63 will be aligned on a 4KB hardware sector
> boundary to overcome the misaligned default partitioning.
>
> I have been working on some alignment patches the last week.  They hook
> into the stuff Matthew has been doing in libata and I'll post them
> shortly.
>
> For each block device you'll get a hardware sector size exposed as well
> as whether the device (partition) is naturally aligned or not.  This
> works for both ATA and SCSI devices.
>
> I'll defer to people like yourself for how this needs to work wrt. boot
> loaders and creating partition tables.  I'm CC:ing Eric Sandeen because
> he's also looking at this...
>
>
