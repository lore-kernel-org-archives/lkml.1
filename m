Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbZBZAOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbZBZAOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZBZAOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:14:08 -0500
Received: from mail.lang.hm ([64.81.33.126]:35160 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbZBZAOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:14:07 -0500
Date: Wed, 25 Feb 2009 16:13:42 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
In-Reply-To: <yq1wsbegj1i.fsf@sermon.lab.mkp.net>
Message-ID: <alpine.DEB.1.10.0902251609490.26625@asgard.lang.hm>
References: <1235600698-6446-1-git-send-email-matthew@wil.cx> <49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net> <alpine.DEB.1.10.0902251549180.26625@asgard.lang.hm> <yq1wsbegj1i.fsf@sermon.lab.mkp.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009, Martin K. Petersen wrote:

>>>>>> "david" == david  <david@lang.hm> writes:
>
>>> 512-byte logical / 512-byte hardware (current) 512-byte logical /
>>> 4096-byte hardware (ATA, doing read-modify-write) 4096-byte logical /
>>> 4096-byte hardware (SCSI initially, ATA later)
>
> david> add to this good support for SSDs
>
> david> ?? logical / 128K hardware
>
> david> or similar.
>
> Yep.  And that goes for RAID arrays too.
>
> For SCSI there some knobs we can query to get this information and my
> alignment changes are using those (and they are in turn what Willy's
> stuff hooks into).
>
> I've been lobbying the SSD vendors whose architecture is prone to
> misalignment problems to propose a similar set of knobs for ATA.  But so
> far it's just been a lot of talking.

even if we can't get them to give us any info from the drive directly, we 
still want to allow the sysadmin to configure the use of the systems when 
they can find the info in other ways.

> My topology changes are a bit abstract in the sense that they expose:
>
> - smallest I/O you can submit without incurring a penalty (hw sector,
>   raid chunk size)
>
> - optimal I/O size for the device in question
>
> - biggest I/O you can submit without incurring a penalty
>
> - alignment
>
> We can use these parameters to lay out partitions and filesystems
> optimally.  Just like we currently do with XFS but implemented in a more
> generic way that all filesystems can use.

if you have the smallest and largest I/O you can submit without a penalty 
and the alignment, isn't the optimal I/O size everything between these 
two? (or at least everything between these two may be close enough that 
defining an 'optimal' size may not be worthwhile)

David Lang
