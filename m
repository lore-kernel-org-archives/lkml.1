Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYFXHXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYFXHXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYFXHXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:23:39 -0400
Received: from nebensachen.de ([195.34.83.29]:49260 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYFXHXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:23:38 -0400
X-Hashcash: 1:20:080624:bzolnier@gmail.com::YNl+eZz+j7Ge5miB:00000000000000000000000000000000000000000007rnh
X-Hashcash: 1:20:080624:linux-ide@vger.kernel.org::yAlJiDNx1b0I/q3+:0000000000000000000000000000000000004f1r
X-Hashcash: 1:20:080624:linux-kernel@vger.kernel.org::oH5WpDGOV5/pkDi8:000000000000000000000000000000000Cb89
X-Hashcash: 1:20:080624:randy.dunlap@oracle.com::TgDPlUe1G+I+Vh5N:000000000000000000000000000000000000000pED
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
References: <87k5gmz596.fsf@denkblock.local>
	<200806192247.25063.bzolnier@gmail.com>
	<87wskhuk98.fsf@denkblock.local>
	<200806240041.42796.bzolnier@gmail.com>
Date: Tue, 24 Jun 2008 09:23:30 +0200
In-Reply-To: <200806240041.42796.bzolnier@gmail.com> (Bartlomiej
	Zolnierkiewicz's message of "Tue, 24 Jun 2008 00:41:42 +0200")
Message-ID: <87skv3s3d9.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On Monday 23 June 2008, Elias Oltmanns wrote:
[...]
>> Indeed, the following patch series is based on nex-20080620.  Just to be
>> absolutely clear though, this is actually a bug fix since a
>> 
>> # hdparm -w /dev/hda
>> 
>> currently freezes the system if there happens to be any I/O operation in
>> progress.  Not sure whether this is serious enough for -rc or, indeed,
>> -stable trees, but I thought I'd mention it.
>
> According to 'man hdparm':
>
>        -w     Perform a device reset (DANGEROUS).  Do NOT use this option.  It
>               exists for unlikely situations where a reboot might otherwise be
>               required to get a confused drive back into a useable state.
>
> so I don't think that a rush is necessary (however we may still want to get
> patch #1 in for 2.6.26).

I see.

>
> BTW Your fix adds framework which can be re-used for fixing locking of
>IDE
> settings (+ it finally makes sense to dust-off my IDE settings rework which
> was always low-prio and was never posted :) and maybe it could be also used
> for drive->special handling.

Alan's remark made me think again and I'm still not quite sure whether I
can (and indeed should) fix ide_abort() and allow for out of band
execution of HDIO_DRIVE_RESET as well as idle immediate with head unload
for disk shock protection. What are your views on Alan's remark and my
reply?

[...]
>> 4. Adds some more error reporting facilities and documents them as well.
>> 
>> Please be particularly alert when reviewing the last patch.  I merely
>> did what seemed to be the right and obvious thing to do but I ironed out
>> some irregularities along the way which (for all improbability) may have
>> been there for some reason or other.  It beats me, for instance, why
>> ->polling but not ->resetting should be reset to 0 when
>> sil_sata_reset_poll() returns non zero.  So, I now both are 0 once any
>> of the poll functions returns ide_stopped.
>
> Looks OK but please move the above description to the patch description.

Will do.

>
> Patches #2 and #3 also look good.

Thanks for reviewing.

Regards,

Elias
