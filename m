Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbZCPOvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbZCPOvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 10:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZCPOvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 10:51:32 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:59320 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbZCPOva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bEL9I5IhlSRGdg2iksIZUhwqN0xuPqGjPtYHLY93nTpDwkC5i7aEce3+ozMdTwVPkF
         PaOYaGAyzachetSePhJ3v20K1q4UmesQ8d/7ajJb7f0AYXpuY12vjzYExoABUe2XvyA0
         Y87eJjYpDaMQu1zOtpwMs24ruV/aKCu5rRfLM=
MIME-Version: 1.0
In-Reply-To: <49A70379.3050306@zytor.com>
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
	 <49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
	 <20090226025043.GJ1363@mit.edu>
	 <20090226030735.GA16891@parisc-linux.org>
	 <yq1eixlg4mn.fsf@sermon.lab.mkp.net> <49A6B604.1060702@zytor.com>
	 <yq1iqmxey1o.fsf@sermon.lab.mkp.net> <49A70379.3050306@zytor.com>
Date: Mon, 16 Mar 2009 10:51:28 -0400
Message-ID: <87f94c370903160751t6de5ed2t40163a6590ba633@mail.gmail.com>
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

On Thu, Feb 26, 2009 at 5:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Martin K. Petersen wrote:
>>>>>>>
>>>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:
>>
>>>> Quick answer from one of my contacts.  Desktop drives will indeed
>>>> ship with an alignment of 1(*).  The alignment is hardwired at time
>>>> of manufacture and can't be changed.
>>>>
>>
>> hpa> Oh God.
>>
>> hpa> This is a disaster.
>>
>> Rationale being that modern Microsoft operating systems know how to
>> interpret the alignment bits.  Legacy XP will work without changes
>> thanks to the shifted alignment.  And Vista+ will do the right thing to
>> align partition 1 to what the drive reports.
>>
>> Also note that Windows only aligns the first partition.  That's
>> something we need to be aware of when setting up dual boot systems.
>>
>
> Yeah, but all of this completely breaks the disk image abstraction, which is
> a very powerful paradigm.
>
>        -hpa
>
If the reported geometry of these drives was changed to have sectors /
track be a multiple of 8, wouldn't that fix most of the issues.

ie. If the drive were to report 56 sectors per track, then a
traditional partitioning tool would start the first partition as
sector 56 and a Vista like partitioning tool would place the first
partition at sector 2048.  Both would have the same 4K sector
alignment.

If my logic is sound, anyway to get this recommendation upstream to
hardware manufacturers.  It seems like an almost trivial change for
them.

FYI: It sounds to me like partitioning tools should totally drop
efforts to align with cylinders, instead they should start asking what
the unit of atomic read/writes is at the physical layer and if any
offsets are needed to align the partition with the atomic write areas.

That would fit better for both SSD technology and for this 4K sectors
issue than trying to continue to support cylinders at all.

Thanks
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
