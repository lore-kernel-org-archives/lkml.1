Return-Path: <linux-kernel-owner+w=401wt.eu-S1762788AbZBYX2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762788AbZBYX2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZBYX2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:28:43 -0500
Received: from rcsinet14.oracle.com ([148.87.113.126]:21061 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbZBYX2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:28:42 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
	<49A5CBF7.9000501@zytor.com>
Date: Wed, 25 Feb 2009 18:27:18 -0500
In-Reply-To: <49A5CBF7.9000501@zytor.com> (H. Peter Anvin's message of "Wed\, 25 Feb 2009 14\:53\:43 -0800")
Message-ID: <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49A5D3DB.0025:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:

>> The two patches following this add support for drives which have
>> sector sizes other than 512 bytes.  I haven't been able to test this
>> as I don't have the hardware.

hpa> What sector size do we report to user space for this?  I'm asking
hpa> because logical sector size is visible in most partition formats.

There are several flavors of drives we have to deal with:

512-byte logical / 512-byte hardware (current)
512-byte logical / 4096-byte hardware (ATA, doing read-modify-write)
4096-byte logical / 4096-byte hardware (SCSI initially, ATA later)

Because of 63-sector legacy problems a bunch of ATA vendors will
initially ship 512/4096 drives that are not naturally aligned.
I.e. logical sector 63 will be aligned on a 4KB hardware sector
boundary to overcome the misaligned default partitioning.

I have been working on some alignment patches the last week.  They hook
into the stuff Matthew has been doing in libata and I'll post them
shortly.

For each block device you'll get a hardware sector size exposed as well
as whether the device (partition) is naturally aligned or not.  This
works for both ATA and SCSI devices.

I'll defer to people like yourself for how this needs to work wrt. boot
loaders and creating partition tables.  I'm CC:ing Eric Sandeen because
he's also looking at this...

-- 
Martin K. Petersen	Oracle Linux Engineering

