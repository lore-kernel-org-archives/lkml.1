Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbZCPRh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbZCPRh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZCPRhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:37:13 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:44332 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbZCPRhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cOkfVdX7ZsVhrP/KlSPbQkGYTxH2K025sbZPIG3+UVJlLU404NKNmMr9XP8lhyEevB
         6tRL6LTWEpT2wxHc0aj1UcnBRs7u9xccHDV3h7uSiwGb/lXmlYH/wRrpEs4msqgD1pG8
         Sdbcnq4xstbyQPYL1/1Er4ar9scgjake8qpjs=
MIME-Version: 1.0
In-Reply-To: <49BE7DEF.1060005@zytor.com>
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
	 <yq1hc2iumg9.fsf@sermon.lab.mkp.net> <20090226025043.GJ1363@mit.edu>
	 <20090226030735.GA16891@parisc-linux.org>
	 <yq1eixlg4mn.fsf@sermon.lab.mkp.net> <49A6B604.1060702@zytor.com>
	 <yq1iqmxey1o.fsf@sermon.lab.mkp.net> <49A70379.3050306@zytor.com>
	 <87f94c370903160751t6de5ed2t40163a6590ba633@mail.gmail.com>
	 <49BE7DEF.1060005@zytor.com>
Date: Mon, 16 Mar 2009 13:37:07 -0400
Message-ID: <87f94c370903161037q52ff5e1nb7512726e58e652c@mail.gmail.com>
Subject: Re: ATA support for 4k sector size
From: Greg Freemyer <greg.freemyer@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 12:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Greg Freemyer wrote:
>> If the reported geometry of these drives was changed to have sectors /
>> track be a multiple of 8, wouldn't that fix most of the issues.
>>
>> ie. If the drive were to report 56 sectors per track, then a
>> traditional partitioning tool would start the first partition as
>> sector 56 and a Vista like partitioning tool would place the first
>> partition at sector 2048.  Both would have the same 4K sector
>> alignment.
>>
>> If my logic is sound, anyway to get this recommendation upstream to
>> hardware manufacturers.  It seems like an almost trivial change for
>> them.
>>
>> FYI: It sounds to me like partitioning tools should totally drop
>> efforts to align with cylinders, instead they should start asking what
>> the unit of atomic read/writes is at the physical layer and if any
>> offsets are needed to align the partition with the atomic write areas.
>>
>> That would fit better for both SSD technology and for this 4K sectors
>> issue than trying to continue to support cylinders at all.
>
> As long as BIOSes played along with it (which some of them may not do --
> remember the geometry that matters is the one reported by the BIOS)
> However, it definitely would be a major step in the right direction, as
> it would let *most* systems Do The Right Thing instead of weirdly
> misaligning the partitions and trying to cope with that.
>
>        -hpa

I'm not intimate with the details, but I would hope most boot loaders
by now use LBA values to find the boot code, not CHS.

If so the issue becomes the partitioning tools (fdisk etc.) putting
the partitions at the right place.  Can't those tools bypass the bios
somehow and ask the drive itself what it's geometry is?

>From what I understand Vista has already made the jump and is now
ignoring CHS and instead just putting the first partition at 1 MiB
into the drive.  (sector 2048 with 512 byte sectors.)

Sounds like fdisk and friends should be updated to do the same.

A bigger issue in my mind is lots of clones, images, etc. are probably
LBA based today and simply start the first partition at sector 63.
Thus the hardware vendors will need to have drives that perform well
with partitions that start at sector 63.  The existing scheme
described may be as good as it gets for that need.

Also, how are SDD manufacturers handling this.  Their erase blocks
don't align with partitions that start at sector 63 either I assume?

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
